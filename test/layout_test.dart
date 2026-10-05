import 'dart:ui' show DisplayFeature, DisplayFeatureState, DisplayFeatureType;

import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pull_down_button/pull_down_button.dart';
import 'package:pull_down_button/src/internals/item_layout.dart';
import 'package:pull_down_button/src/internals/route.dart';

class _CountingTextScaler extends TextScaler {
  const _CountingTextScaler(this.factor, this.onScale);

  final double factor;
  final VoidCallback onScale;

  @override
  double scale(double fontSize) {
    onScale();
    return factor * fontSize;
  }

  @override
  double get textScaleFactor => factor;
}

Future<SingleChildLayoutDelegate> _pumpRouteLayout(
  WidgetTester tester, {
  required Rect buttonRect,
  double menuOffset = 0,
  PullDownMenuPosition menuPosition = PullDownMenuPosition.automatic,
  EdgeInsets padding = EdgeInsets.zero,
  List<DisplayFeature> displayFeatures = const [],
}) async {
  const layoutKey = ValueKey<String>('route-layout');
  await tester.pumpWidget(
    CupertinoApp(
      home: MediaQuery(
        data: MediaQueryData(
          size: const Size(800, 600),
          padding: padding,
          displayFeatures: displayFeatures,
        ),
        child: Builder(
          builder: (context) {
            final route = PullDownMenuRoute<VoidCallback>(
              items: const [SizedBox(width: 100, height: 88)],
              barrierLabel: 'Dismiss',
              routeTheme: const PullDownMenuRouteTheme(menuScreenPadding: 8),
              buttonRect: buttonRect,
              menuPosition: menuPosition,
              capturedThemes: InheritedTheme.capture(
                from: context,
                to: context,
              ),
              hasLeading: false,
              itemsOrder: PullDownMenuItemsOrder.downwards,
              alignment: Alignment.topLeft,
              menuOffset: menuOffset,
              scrollController: null,
              settings: const RouteSettings(),
            );
            return KeyedSubtree(
              key: layoutKey,
              child: route.buildTransitions(
                context,
                const AlwaysStoppedAnimation(1),
                const AlwaysStoppedAnimation(0),
                const SizedBox(width: 100, height: 88),
              ),
            );
          },
        ),
      ),
    ),
  );
  return tester
      .widget<CustomSingleChildLayout>(
        find.descendant(
          of: find.byKey(layoutKey),
          matching: find.byType(CustomSingleChildLayout),
        ),
      )
      .delegate;
}

void main() {
  final boxes = <
    ({
      String name,
      Widget Function(Widget) create,
      Size boxSize,
      double iconSize,
    })
  >[
    (
      name: 'normal icon',
      create: (child) => IconBox(child: child),
      boxSize: const Size(20, 22),
      iconSize: 22,
    ),
    (
      name: 'small icon',
      create: (child) => IconBox.small(child: child),
      boxSize: const Size(18, 18),
      iconSize: 17,
    ),
    (
      name: 'custom icon',
      create: (child) => IconBox(size: 32, child: child),
      boxSize: const Size.square(32),
      iconSize: 32,
    ),
    (
      name: 'header action',
      create: (child) => IconActionBox(color: null, child: child),
      boxSize: const Size.square(28),
      iconSize: 17,
    ),
    (
      name: 'custom header action',
      create: (child) => IconActionBox(color: null, size: 56, child: child),
      boxSize: const Size.square(56),
      iconSize: 34,
    ),
  ];

  for (final box in boxes) {
    testWidgets('${box.name} resolves text scale once and preserves geometry', (
      tester,
    ) async {
      for (final factor in [1.0, 1.5, 3.1176470588235294]) {
        var scaleCalls = 0;
        final scaler = _CountingTextScaler(
          factor,
          () => scaleCalls++,
        );
        const childKey = ValueKey<String>('icon-child');
        double? iconSize;
        await tester.pumpWidget(
          Directionality(
            textDirection: TextDirection.ltr,
            child: MediaQuery(
              data: MediaQueryData(textScaler: scaler),
              child: Center(
                child: box.create(
                  Builder(
                    builder: (context) {
                      iconSize = IconTheme.of(context).size;
                      return const SizedBox.expand(key: childKey);
                    },
                  ),
                ),
              ),
            ),
          ),
        );

        expect(tester.getSize(find.byKey(childKey)), box.boxSize * factor);
        expect(iconSize, box.iconSize * factor);
        // One scale resolution supplies both the box and glyph dimensions.
        expect(scaleCalls, 1);
      }
    });
  }

  testWidgets('text scaling updates a reused icon widget', (tester) async {
    const childKey = ValueKey<String>('icon-child');
    const icon = IconBox(child: SizedBox.expand(key: childKey));
    for (final factor in [1.0, 2.0, 1.0]) {
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: MediaQuery(
            data: MediaQueryData(textScaler: TextScaler.linear(factor)),
            child: const Center(child: icon),
          ),
        ),
      );
      expect(
        tester.getSize(find.byKey(childKey)),
        Size(20 * factor, 22 * factor),
      );
    }
  });

  testWidgets('normal screens preserve placement, padding, and menu offsets', (
    tester,
  ) async {
    final SingleChildLayoutDelegate layout = await _pumpRouteLayout(
      tester,
      buttonRect: const Rect.fromLTWH(40, 100, 44, 44),
      padding: const EdgeInsets.fromLTRB(16, 24, 20, 12),
      menuOffset: 4,
    );
    expect(
      layout.getConstraintsForChild(BoxConstraints.tight(const Size(800, 600))),
      const BoxConstraints(maxWidth: 784, maxHeight: 444),
    );
    expect(
      layout.getPositionForChild(const Size(800, 600), const Size(100, 88)),
      const Offset(36, 144),
    );

    final SingleChildLayoutDelegate bottomLayout = await _pumpRouteLayout(
      tester,
      buttonRect: const Rect.fromLTWH(740, 500, 24, 24),
      menuOffset: 4,
    );
    expect(
      bottomLayout.getPositionForChild(
        const Size(800, 600),
        const Size(100, 88),
      ),
      const Offset(668, 407),
    );

    final SingleChildLayoutDelegate overLayout = await _pumpRouteLayout(
      tester,
      buttonRect: const Rect.fromLTWH(378, 500, 44, 44),
      menuPosition: PullDownMenuPosition.over,
    );
    expect(
      overLayout.getPositionForChild(const Size(800, 600), const Size(100, 88)),
      const Offset(350, 456),
    );
  });

  testWidgets('foldable menus stay on the closest screen and preserve ties', (
    tester,
  ) async {
    const hinge = DisplayFeature(
      bounds: Rect.fromLTWH(390, 0, 20, 600),
      type: DisplayFeatureType.hinge,
      state: DisplayFeatureState.postureFlat,
    );
    final cases = <({Rect buttonRect, double expectedX})>[
      (buttonRect: const Rect.fromLTWH(500, 100, 44, 44), expectedX: 444.0),
      (buttonRect: const Rect.fromLTWH(256, 100, 44, 44), expectedX: 256.0),
      (buttonRect: const Rect.fromLTWH(378, 100, 44, 44), expectedX: 282.0),
    ];
    for (final entry in cases) {
      final SingleChildLayoutDelegate layout = await _pumpRouteLayout(
        tester,
        buttonRect: entry.buttonRect,
        displayFeatures: const [hinge],
      );
      expect(
        layout.getPositionForChild(const Size(800, 600), const Size(100, 88)),
        Offset(entry.expectedX, 144),
      );
    }
  });

  testWidgets('changing menu offset schedules a new layout', (tester) async {
    const buttonRect = Rect.fromLTWH(40, 100, 44, 44);
    final SingleChildLayoutDelegate first = await _pumpRouteLayout(
      tester,
      buttonRect: buttonRect,
    );
    final SingleChildLayoutDelegate same = await _pumpRouteLayout(
      tester,
      buttonRect: buttonRect,
    );
    final SingleChildLayoutDelegate changed = await _pumpRouteLayout(
      tester,
      buttonRect: buttonRect,
      menuOffset: 10,
    );

    expect(same.shouldRelayout(first), isFalse);
    expect(changed.shouldRelayout(first), isTrue);
    expect(
      changed.getPositionForChild(const Size(800, 600), const Size(100, 88)),
      const Offset(30, 144),
    );
  });
}
