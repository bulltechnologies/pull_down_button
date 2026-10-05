import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pull_down_button/pull_down_button.dart';
import 'package:pull_down_button/src/internals/route.dart';

void main() {
  testWidgets('route positioning is independent of animation frames', (
    tester,
  ) async {
    var screenPaddingReads = 0;
    final theme = _CountingRouteTheme(() => screenPaddingReads++);
    late Future<void> Function() showMenu;
    var canceled = 0;

    await tester.pumpWidget(
      CupertinoApp(
        home: Center(
          child: PullDownButton(
            routeTheme: theme,
            onCanceled: () => canceled++,
            itemBuilder:
                (_) => [
                  PullDownMenuItem(onTap: () {}, title: 'First'),
                  PullDownMenuItem(onTap: () {}, title: 'Second'),
                ],
            buttonBuilder: (_, open) {
              showMenu = open;
              return const SizedBox(width: 44, height: 44);
            },
          ),
        ),
      ),
    );

    final Future<void> closed = showMenu();
    await tester.pump();
    final initialReads = screenPaddingReads;
    expect(initialReads, greaterThan(0));

    for (var i = 0; i < 24; i++) {
      await tester.pump(const Duration(milliseconds: 16));
    }
    expect(screenPaddingReads, initialReads);

    await tester.tapAt(const Offset(10, 10));
    await tester.pump();
    await closed;
    expect(canceled, 1);

    final closingReads = screenPaddingReads;
    for (var i = 0; i < 24; i++) {
      await tester.pump(const Duration(milliseconds: 16));
    }
    expect(screenPaddingReads, closingReads);
    expect(find.text('First'), findsNothing);
  });

  testWidgets('cached route wrappers update children and safe-area placement', (
    tester,
  ) async {
    const ValueKey<String> childKey = ValueKey('route-child');
    PullDownMenuRoute<VoidCallback>? route;
    late StateSetter update;
    var wideChild = false;
    var leftPadding = 0.0;

    await tester.pumpWidget(
      CupertinoApp(
        home: StatefulBuilder(
          builder: (context, setState) {
            update = setState;
            return MediaQuery(
              data: MediaQueryData(
                size: const Size(800, 600),
                padding: EdgeInsets.only(left: leftPadding),
              ),
              child: Builder(
                builder: (context) {
                  route ??= PullDownMenuRoute<VoidCallback>(
                    items: const [],
                    barrierLabel: 'Dismiss',
                    routeTheme: const PullDownMenuRouteTheme(
                      menuScreenPadding: 8,
                    ),
                    buttonRect: const Rect.fromLTWH(40, 100, 44, 44),
                    menuPosition: PullDownMenuPosition.automatic,
                    capturedThemes: InheritedTheme.capture(
                      from: context,
                      to: context,
                    ),
                    hasLeading: false,
                    itemsOrder: PullDownMenuItemsOrder.downwards,
                    alignment: Alignment.topLeft,
                    menuOffset: 0,
                    scrollController: null,
                    settings: null,
                  );
                  return route!.buildTransitions(
                    context,
                    const AlwaysStoppedAnimation(1),
                    const AlwaysStoppedAnimation(0),
                    SizedBox(
                      key: childKey,
                      width: wideChild ? 140 : 100,
                      height: 88,
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );

    expect(
      tester.getRect(find.byKey(childKey)),
      const Rect.fromLTWH(40, 144, 100, 88),
    );

    update(() => wideChild = true);
    await tester.pump();
    expect(tester.getSize(find.byKey(childKey)), const Size(140, 88));

    update(() => leftPadding = 80);
    await tester.pump();
    expect(
      tester.getRect(find.byKey(childKey)),
      const Rect.fromLTWH(88, 144, 140, 88),
    );
  });
}

class _CountingRouteTheme extends PullDownMenuRouteTheme {
  const _CountingRouteTheme(this.onRead);

  final VoidCallback onRead;

  @override
  double get menuScreenPadding {
    onRead();
    return 8;
  }
}
