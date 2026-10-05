import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pull_down_button/pull_down_button.dart';
import 'package:pull_down_button/src/internals/content_size_category.dart';
import 'package:pull_down_button/src/internals/menu_config.dart';

void main() {
  testWidgets('ambient defaults reuse resolved text styles', (tester) async {
    late PullDownButtonTheme theme;

    await tester.pumpWidget(
      CupertinoApp(
        home: Builder(
          builder: (context) {
            theme = PullDownButtonTheme.ambientOf(context);
            return const SizedBox();
          },
        ),
      ),
    );

    expect(
      identical(theme.itemTheme.textStyle, theme.itemTheme.textStyle),
      true,
    );
    expect(
      identical(theme.itemTheme.subtitleStyle, theme.itemTheme.subtitleStyle),
      true,
    );
    expect(
      identical(
        theme.itemTheme.iconActionTextStyle,
        theme.itemTheme.iconActionTextStyle,
      ),
      true,
    );
    expect(
      identical(
        theme.itemTheme.trailingTextStyle,
        theme.itemTheme.trailingTextStyle,
      ),
      true,
    );
    expect(identical(theme.titleTheme.style, theme.titleTheme.style), true);
  });

  testWidgets('ambient defaults notify stable children on brightness changes', (
    tester,
  ) async {
    late PullDownButtonTheme resolvedTheme;
    late Color itemColor;
    var builds = 0;

    final child = Builder(
      builder: (context) {
        builds++;
        itemColor =
            MenuConfig.ambientThemeOf(context).itemTheme.textStyle!.color!;
        return const SizedBox();
      },
    );
    final Widget menu = Builder(
      builder: (context) {
        resolvedTheme = PullDownButtonTheme.ambientOf(context);
        return MenuConfig(
          hasLeading: false,
          ambientTheme: resolvedTheme,
          contentSizeCategory: ContentSizeCategory.large,
          child: child,
        );
      },
    );

    Widget app(Brightness brightness) => CupertinoApp(
      theme: CupertinoThemeData(brightness: brightness),
      home: menu,
    );

    await tester.pumpWidget(app(Brightness.light));
    final lightTheme = resolvedTheme;
    final lightHashCode = lightTheme.hashCode;
    final lightColor = itemColor;
    final initialBuilds = builds;

    await tester.pumpWidget(app(Brightness.dark));
    await tester.pumpAndSettle();

    expect(builds, initialBuilds + 1);
    expect(itemColor, isNot(lightColor));
    expect(resolvedTheme, isNot(lightTheme));
    expect(lightTheme.itemTheme.textStyle!.color, lightColor);
    expect(lightTheme.hashCode, lightHashCode);
  });

  testWidgets('all registered menu configuration aspects can notify', (
    tester,
  ) async {
    var builds = 0;
    late ContentSizeCategory contentSize;
    final child = Builder(
      builder: (context) {
        builds++;
        MenuConfig.hasLeadingOf(context);
        MenuConfig.ambientThemeOf(context);
        contentSize = MenuConfig.contentSizeCategoryOf(context);
        return const SizedBox();
      },
    );

    Widget menu({
      bool hasLeading = false,
      PullDownButtonTheme theme = const PullDownButtonTheme(),
      ContentSizeCategory category = ContentSizeCategory.large,
    }) => Directionality(
      textDirection: TextDirection.ltr,
      child: MenuConfig(
        hasLeading: hasLeading,
        ambientTheme: theme,
        contentSizeCategory: category,
        child: child,
      ),
    );

    await tester.pumpWidget(menu());
    expect(builds, 1);

    await tester.pumpWidget(menu(hasLeading: true));
    expect(builds, 2);

    const customTheme = PullDownButtonTheme(
      itemTheme: PullDownMenuItemTheme(iconSize: 24),
    );
    await tester.pumpWidget(menu(hasLeading: true, theme: customTheme));
    expect(builds, 3);

    await tester.pumpWidget(
      menu(
        hasLeading: true,
        theme: customTheme,
        category: ContentSizeCategory.accessibilityLarge,
      ),
    );
    expect(builds, 4);
    expect(contentSize, ContentSizeCategory.accessibilityLarge);
  });

  testWidgets('unrelated menu configuration changes do not rebuild children', (
    tester,
  ) async {
    var builds = 0;
    final child = Builder(
      builder: (context) {
        builds++;
        MenuConfig.hasLeadingOf(context);
        return const SizedBox();
      },
    );

    Widget menu(ContentSizeCategory category) => Directionality(
      textDirection: TextDirection.ltr,
      child: MenuConfig(
        hasLeading: false,
        ambientTheme: const PullDownButtonTheme(),
        contentSizeCategory: category,
        child: child,
      ),
    );

    await tester.pumpWidget(menu(ContentSizeCategory.large));
    await tester.pumpWidget(menu(ContentSizeCategory.accessibilityLarge));
    expect(builds, 1);
  });

  testWidgets('routed menus resolve captured themes below removed padding', (
    tester,
  ) async {
    const localTheme = PullDownButtonTheme(
      routeTheme: PullDownMenuRouteTheme(
        width: 300,
        showBackdropFilter: false,
      ),
      itemTheme: PullDownMenuItemTheme(
        titleColor: CupertinoColors.systemPurple,
      ),
    );
    late PullDownButtonTheme resolvedTheme;
    PullDownButtonTheme? capturedTheme;
    late EdgeInsets padding;
    final item = Builder(
      builder: (context) {
        resolvedTheme = MenuConfig.ambientThemeOf(context);
        capturedTheme = PullDownButtonTheme.maybeOf(context);
        padding = MediaQuery.paddingOf(context);
        return const SizedBox(height: 44);
      },
    );

    await tester.pumpWidget(
      CupertinoApp(
        builder:
            (context, child) => MediaQuery(
              data: MediaQuery.of(context).copyWith(
                padding: const EdgeInsets.fromLTRB(20, 40, 20, 30),
              ),
              child: child!,
            ),
        home: PullDownButtonInheritedTheme(
          data: localTheme,
          child: Center(
            child: PullDownButton(
              itemBuilder: (_) => [item],
              buttonBuilder:
                  (context, showMenu) => CupertinoButton(
                    onPressed: showMenu,
                    child: const Text('Open menu'),
                  ),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Open menu'));
    await tester.pumpAndSettle();

    expect(capturedTheme, localTheme);
    expect(resolvedTheme.routeTheme.width, 300);
    expect(resolvedTheme.routeTheme.showBackdropFilter, false);
    expect(
      resolvedTheme.itemTheme.textStyle!.color,
      CupertinoColors.systemPurple,
    );
    expect(padding, EdgeInsets.zero);
  });

  testWidgets('open routed menus update default colors with brightness', (
    tester,
  ) async {
    late Color itemColor;
    var builds = 0;
    final item = Builder(
      builder: (context) {
        builds++;
        itemColor =
            MenuConfig.ambientThemeOf(context).itemTheme.textStyle!.color!;
        return const SizedBox(height: 44);
      },
    );
    final home = Center(
      child: PullDownButton(
        itemBuilder: (_) => [item],
        buttonBuilder:
            (context, showMenu) => CupertinoButton(
              onPressed: showMenu,
              child: const Text('Open menu'),
            ),
      ),
    );

    Widget app(Brightness brightness) => CupertinoApp(
      theme: CupertinoThemeData(brightness: brightness),
      home: home,
    );

    await tester.pumpWidget(app(Brightness.light));
    await tester.tap(find.text('Open menu'));
    await tester.pumpAndSettle();
    final lightColor = itemColor;
    final initialBuilds = builds;

    await tester.pumpWidget(app(Brightness.dark));
    await tester.pumpAndSettle();

    expect(builds, greaterThan(initialBuilds));
    expect(itemColor, isNot(lightColor));
  });
}
