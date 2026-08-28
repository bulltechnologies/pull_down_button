import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pull_down_button/pull_down_button.dart';
import 'package:pull_down_button/src/internals/button.dart';
import 'package:pull_down_button/src/internals/item_layout.dart';
import 'package:pull_down_button/src/internals/menu.dart';

void main() {
  testWidgets('PullDownMenuRouteTheme.defaults uses ClipRSuperellipse clipper', (
    tester,
  ) async {
    late final PullDownMenuRouteTheme defaults;

    await tester.pumpWidget(
      CupertinoApp(
        home: Builder(
          builder: (context) {
            defaults = PullDownMenuRouteTheme.defaults(context);
            return const SizedBox();
          },
        ),
      ),
    );

    const BorderRadius radius = BorderRadius.all(Radius.circular(12));
    final Widget clipped = defaults.borderClipper!(radius, const SizedBox());

    expect(clipped, isA<ClipRSuperellipse>());
    expect((clipped as ClipRSuperellipse).borderRadius, radius);
  });

  testWidgets('MenuDecoration uses ClipRSuperellipse by default', (
    tester,
  ) async {
    await tester.pumpWidget(
      CupertinoApp(
        home: Builder(
          builder: (context) {
            final theme = PullDownMenuRouteTheme.defaults(context);
            return MenuDecoration(
              backgroundColor: CupertinoColors.white,
              borderRadius: theme.borderRadius!,
              borderClipper: theme.borderClipper!,
              backdropBlurSigma: theme.backdropBlurSigma!,
              child: const SizedBox(width: 200, height: 200),
            );
          },
        ),
      ),
    );

    expect(find.byType(ClipRSuperellipse), findsOneWidget);
  });

  testWidgets(
    'MenuDecoration with border uses ShapeDecoration with RoundedSuperellipseBorder',
    (tester) async {
      await tester.pumpWidget(
        CupertinoApp(
          home: Builder(
            builder: (context) {
              final theme = PullDownMenuRouteTheme.defaults(context);
              return MenuDecoration(
                backgroundColor: CupertinoColors.white,
                borderRadius: theme.borderRadius!,
                borderClipper: theme.borderClipper!,
                backdropBlurSigma: theme.backdropBlurSigma!,
                border: Border.all(color: CupertinoColors.black, width: 1),
                child: const SizedBox(width: 200, height: 200),
              );
            },
          ),
        ),
      );

      final decoratedBox = tester.widget<DecoratedBox>(
        find.byWidgetPredicate(
          (w) =>
              w is DecoratedBox &&
              w.decoration is ShapeDecoration &&
              (w.decoration as ShapeDecoration).shape
                  is RoundedSuperellipseBorder,
        ),
      );

      final decoration = decoratedBox.decoration as ShapeDecoration;
      final shape = decoration.shape as RoundedSuperellipseBorder;
      expect(shape.borderRadius, const BorderRadius.all(Radius.circular(12)));
      expect(shape.side.color, CupertinoColors.black);
      expect(shape.side.width, 1.0);
    },
  );

  testWidgets(
    'MenuActionButton uses ShapeDecoration with RoundedSuperellipseBorder',
    (tester) async {
      await tester.pumpWidget(
        CupertinoApp(
          home: Center(
            child: MenuActionButton(
              onTap: () {},
              pressedColor: CupertinoColors.systemGrey,
              hoverColor: CupertinoColors.systemGrey2,
              backgroundColor: CupertinoColors.systemBlue,
              borderRadius: const BorderRadius.all(Radius.circular(8)),
              child: const Text('Action'),
            ),
          ),
        ),
      );

      final decoratedBox = tester.widget<DecoratedBox>(
        find.descendant(
          of: find.byType(MenuActionButton),
          matching: find.byType(DecoratedBox),
        ),
      );

      expect(decoratedBox.decoration, isA<ShapeDecoration>());
      final decoration = decoratedBox.decoration as ShapeDecoration;
      expect(decoration.shape, isA<RoundedSuperellipseBorder>());
      final shape = decoration.shape as RoundedSuperellipseBorder;
      expect(shape.borderRadius, const BorderRadius.all(Radius.circular(8)));
      expect(decoration.color, CupertinoColors.systemBlue);
    },
  );

  testWidgets(
    'IconBox uses ShapeDecoration with RoundedSuperellipseBorder',
    (tester) async {
      await tester.pumpWidget(
        const CupertinoApp(
          home: Center(
            child: IconBox(
              backgroundColor: CupertinoColors.systemBlue,
              borderRadius: BorderRadius.all(Radius.circular(6)),
              child: Icon(CupertinoIcons.star),
            ),
          ),
        ),
      );

      final container = tester.widget<Container>(
        find.descendant(
          of: find.byType(IconBox),
          matching: find.byType(Container),
        ),
      );

      expect(container.decoration, isA<ShapeDecoration>());
      final decoration = container.decoration as ShapeDecoration;
      expect(decoration.shape, isA<RoundedSuperellipseBorder>());
      final shape = decoration.shape as RoundedSuperellipseBorder;
      expect(shape.borderRadius, const BorderRadius.all(Radius.circular(6)));
    },
  );

  testWidgets(
    'PullDownMenu renders with ClipRSuperellipse and ShapeDecoration shadow',
    (tester) async {
      await tester.pumpWidget(
        CupertinoApp(
          home: Center(
            child: PullDownMenu(
              items: [
                PullDownMenuItem(
                  onTap: () {},
                  title: 'Item 1',
                ),
                PullDownMenuItem(
                  onTap: () {},
                  title: 'Item 2',
                ),
                PullDownMenuItem(
                  onTap: () {},
                  title: 'Item 3',
                ),
                PullDownMenuItem(
                  onTap: () {},
                  title: 'Item 4',
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.byType(ClipRSuperellipse), findsOneWidget);

      final shadowDecoratedBox = tester.widget<DecoratedBox>(
        find.descendant(
          of: find.byType(PullDownMenu),
          matching: find.byWidgetPredicate(
            (w) =>
                w is DecoratedBox &&
                w.decoration is ShapeDecoration &&
                (w.decoration as ShapeDecoration).shadows != null,
          ),
        ),
      );

      final shadowDecoration =
          shadowDecoratedBox.decoration as ShapeDecoration;
      expect(shadowDecoration.shape, isA<RoundedSuperellipseBorder>());
      expect(
        (shadowDecoration.shape as RoundedSuperellipseBorder).borderRadius,
        const BorderRadius.all(Radius.circular(12)),
      );
    },
  );
}
