import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pull_down_button/pull_down_button.dart';
import 'package:pull_down_button/src/internals/route_menu.dart';

// Capture a reference from an unchanged checkout, then compare a candidate:
// flutter test --no-pub test/route_visual_compatibility_test.dart
//   --dart-define=VISUAL_CAPTURE_DIR=/absolute/reference/path
// flutter test --no-pub test/route_visual_compatibility_test.dart
//   --dart-define=VISUAL_BASELINE_DIR=/absolute/reference/path
//   --dart-define=VISUAL_CAPTURE_DIR=/absolute/candidate/path
// Use the same Flutter engine, platform, and font environment for both runs.
// These environment declarations configure optional test artifacts only.
// ignore: do_not_use_environment
const _captureDirectory = String.fromEnvironment('VISUAL_CAPTURE_DIR');
// Baseline paths belong to opt-in test tooling rather than widget behavior.
// ignore: do_not_use_environment
const _baselineDirectory = String.fromEnvironment('VISUAL_BASELINE_DIR');
// Paint counters write artifacts only when requested by a test invocation.
// ignore: do_not_use_environment
const _metricPath = String.fromEnvironment('VISUAL_METRIC_PATH');
const _screenKey = ValueKey<String>('screen');
const _buttonKey = ValueKey<String>('open-menu');
const _frameSteps = <int>[16, 34, 50, 50, 75, 75];

void main() {
  final paintMetrics = <String, Object>{};
  for (final _Scenario scenario in _scenarios) {
    testWidgets('route rendering and geometry: ${scenario.name}', (
      tester,
    ) async {
      _configureView(tester);
      final controller = ScrollController();
      await tester.pumpWidget(_buildApp(scenario, controller));
      await tester.pumpAndSettle();
      await _record(tester, '${scenario.name}_closed');

      await tester.tap(find.byKey(_buttonKey));
      await tester.pump();
      await _record(tester, '${scenario.name}_open_0');
      var elapsed = 0;
      for (final int step in _frameSteps) {
        elapsed += step;
        await tester.pump(Duration(milliseconds: step));
        await _record(tester, '${scenario.name}_open_$elapsed');
      }
      expect(find.byType(RoutePullDownMenu), findsOneWidget);
      final RoutePullDownMenu menu = tester.widget<RoutePullDownMenu>(
        find.byType(RoutePullDownMenu),
      );
      expect(menu.animation.value, 1);
      final double expectedWidth =
          scenario.customized
              ? 300
              : scenario.textScale > 1.3529411764705883
              ? 370
              : 250;
      expect(
        tester
            .getSize(
              find.byKey(
                ValueKey<String>(scenario.longMenu ? 'long-0' : 'header'),
              ),
            )
            .width,
        expectedWidth,
      );
      expect(tester.takeException(), isNull);

      if (scenario.longMenu) {
        expect(controller.position.maxScrollExtent, greaterThan(0));
        controller.jumpTo(230);
        await tester.pump(const Duration(milliseconds: 100));
        await _record(tester, '${scenario.name}_scrolled');
      }

      Navigator.of(tester.element(find.byType(RoutePullDownMenu))).pop();
      await tester.pump();
      await _record(tester, '${scenario.name}_close_0');
      elapsed = 0;
      for (final int step in _frameSteps) {
        elapsed += step;
        await tester.pump(Duration(milliseconds: step));
        await _record(tester, '${scenario.name}_close_$elapsed');
      }
      await tester.pumpAndSettle();
      expect(find.byType(RoutePullDownMenu), findsNothing);
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox());
      controller.dispose();
    });
  }

  for (final scenario in <_Scenario>[
    _scenarios.first,
    const _Scenario('opaque', opaque: true),
    const _Scenario('no_blur', noBlur: true),
  ]) {
    testWidgets(
      'static ${scenario.name} content paints once during transitions',
      (
        tester,
      ) async {
        _configureView(tester);
        final paints = List<int>.filled(8, 0);
        final items = <Widget>[
          for (var index = 0; index < paints.length; index++)
            PullDownMenuItem.custom(
              onTap: () {},
              child: SizedBox(
                height: 24,
                child: CustomPaint(painter: _CountingPainter(paints, index)),
              ),
            ),
        ];
        final controller = ScrollController();
        await tester.pumpWidget(_buildApp(scenario, controller, items));
        await tester.pumpAndSettle();
        await tester.tap(find.byKey(_buttonKey));
        await tester.pump();
        for (var frame = 0; frame < 20; frame++) {
          await tester.pump(const Duration(milliseconds: 16));
        }
        final openingPaints = List<int>.of(paints);
        Navigator.of(tester.element(find.byType(RoutePullDownMenu))).pop();
        await tester.pump();
        for (var frame = 0; frame < 20; frame++) {
          await tester.pump(const Duration(milliseconds: 16));
        }
        expect(openingPaints, List<int>.filled(paints.length, 1));
        expect(paints, openingPaints);
        expect(tester.takeException(), isNull);
        paintMetrics[scenario.name] = <String, Object>{
          'openPerItem': openingPaints,
          'closePerItem': <int>[
            for (var index = 0; index < paints.length; index++)
              paints[index] - openingPaints[index],
          ],
          'total': paints.fold<int>(0, (a, b) => a + b),
        };
        if (_metricPath.isNotEmpty) {
          await tester.runAsync<void>(() async {
            await File(_metricPath).writeAsString(jsonEncode(paintMetrics));
          });
        }
        await tester.pumpWidget(const SizedBox());
        controller.dispose();
      },
    );
  }

  testWidgets('inline opaque menu retains content while ancestor repaints', (
    tester,
  ) async {
    _configureView(tester);
    final paints = List<int>.filled(8, 0);
    final items = <Widget>[
      for (var index = 0; index < paints.length; index++)
        PullDownMenuItem.custom(
          onTap: () {},
          child: SizedBox(
            height: 24,
            child: CustomPaint(painter: _CountingPainter(paints, index)),
          ),
        ),
    ];
    final frame = ValueNotifier<int>(0);
    await tester.pumpWidget(
      CupertinoApp(
        home: AnimatedBuilder(
          animation: frame,
          builder:
              (context, child) => CustomPaint(
                painter: _ChangingBackdropPainter(frame.value),
                child: child,
              ),
          child: Center(
            child: PullDownMenu(
              routeTheme: const PullDownMenuRouteTheme(
                backgroundColor: CupertinoColors.white,
              ),
              items: items,
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    for (var index = 1; index <= 20; index++) {
      frame.value = index;
      await tester.pump(const Duration(milliseconds: 16));
    }
    expect(paints, List<int>.filled(paints.length, 1));
    expect(tester.takeException(), isNull);
    paintMetrics['inline_opaque'] = <String, Object>{'perItem': paints};
    if (_metricPath.isNotEmpty) {
      await tester.runAsync<void>(() async {
        await File(_metricPath).writeAsString(jsonEncode(paintMetrics));
      });
    }
    await tester.pumpWidget(const SizedBox());
    frame.dispose();
  });
}

void _configureView(WidgetTester tester) {
  tester.view.physicalSize = const Size(430, 820);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
}

Future<void> _record(WidgetTester tester, String name) async {
  if (_captureDirectory.isEmpty && _baselineDirectory.isEmpty) {
    return;
  }
  final geometry = <String, Object>{};
  for (final key in <String>[
    'open-menu',
    'header',
    'title',
    'primary',
    'secondary',
    'disabled',
    'custom',
    'actions-small',
    'actions-medium',
    for (var index = 0; index < 28; index++) 'long-$index',
  ]) {
    final Finder finder = find.byKey(ValueKey<String>(key));
    if (finder.evaluate().isNotEmpty) {
      final Rect rect = tester.getRect(finder);
      geometry[key] = <double>[rect.left, rect.top, rect.width, rect.height];
    }
  }
  final Finder routeFinder = find.byType(RoutePullDownMenu);
  if (routeFinder.evaluate().isNotEmpty) {
    geometry['animation'] =
        tester.widget<RoutePullDownMenu>(routeFinder).animation.value;
  }
  final RenderRepaintBoundary boundary = tester
      .renderObject<RenderRepaintBoundary>(
        find.byKey(_screenKey),
      );
  await tester.runAsync<void>(() async {
    final ui.Image image = await boundary.toImage();
    try {
      final Uint8List rgba = (await image.toByteData())!.buffer.asUint8List();
      final String json = jsonEncode(geometry);
      if (_captureDirectory.isNotEmpty) {
        await Directory(_captureDirectory).create(recursive: true);
        await File('$_captureDirectory/$name.rgba').writeAsBytes(rgba);
        await File('$_captureDirectory/$name.json').writeAsString(json);
        final Uint8List png =
            (await image.toByteData(
              format: ui.ImageByteFormat.png,
            ))!.buffer.asUint8List();
        await File('$_captureDirectory/$name.png').writeAsBytes(png);
      }
      if (_baselineDirectory.isNotEmpty) {
        final Uint8List expected =
            await File('$_baselineDirectory/$name.rgba').readAsBytes();
        expect(rgba.length, expected.length, reason: '$name image dimensions');
        var changedChannels = 0;
        var maximumDifference = 0;
        for (var index = 0; index < rgba.length; index++) {
          final int difference = (rgba[index] - expected[index]).abs();
          if (difference != 0) {
            changedChannels++;
            if (difference > maximumDifference) {
              maximumDifference = difference;
            }
          }
        }
        expect(
          changedChannels,
          0,
          reason:
              '$name differs in $changedChannels color channels; '
              'largest delta $maximumDifference',
        );
        expect(
          geometry,
          jsonDecode(
            await File('$_baselineDirectory/$name.json').readAsString(),
          ),
          reason: '$name layout or animation changed',
        );
      }
    } finally {
      image.dispose();
    }
  });
}

Widget _buildApp(
  _Scenario scenario,
  ScrollController controller, [
  List<Widget>? items,
]) => RepaintBoundary(
  key: _screenKey,
  child: CupertinoApp(
    theme: CupertinoThemeData(brightness: scenario.brightness),
    builder:
        (context, child) => Directionality(
          textDirection: scenario.direction,
          child: MediaQuery(
            data: MediaQuery.of(context).copyWith(
              textScaler: TextScaler.linear(scenario.textScale),
              padding: const EdgeInsets.only(top: 24, bottom: 34),
            ),
            child: child!,
          ),
        ),
    home: CupertinoPageScaffold(
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          const CustomPaint(painter: _BackdropPainter()),
          Align(
            alignment: scenario.alignment,
            child: Padding(
              padding: const EdgeInsets.all(64),
              child: PullDownButtonInheritedTheme(
                data:
                    scenario.customized
                        ? _customTheme
                        : PullDownButtonTheme(
                          routeTheme: PullDownMenuRouteTheme(
                            backgroundColor:
                                scenario.opaque ? CupertinoColors.white : null,
                            showBackdropFilter: scenario.noBlur ? false : null,
                          ),
                        ),
                child: PullDownButton(
                  scrollController: controller,
                  position:
                      scenario.over
                          ? PullDownMenuPosition.over
                          : PullDownMenuPosition.automatic,
                  itemsOrder:
                      scenario.automaticOrder
                          ? PullDownMenuItemsOrder.automatic
                          : PullDownMenuItemsOrder.downwards,
                  buttonAnchor: scenario.over ? PullDownMenuAnchor.start : null,
                  itemBuilder: (context) => items ?? _items(scenario),
                  buttonBuilder:
                      (
                        context,
                        showMenu,
                      ) => CupertinoButton.filled(
                        key: _buttonKey,
                        onPressed: showMenu,
                        child: const Text('Open'),
                      ),
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  ),
);

List<Widget> _items(_Scenario scenario) {
  if (scenario.longMenu) {
    return <Widget>[
      for (var index = 0; index < 28; index++)
        PullDownMenuItem(
          key: ValueKey<String>('long-$index'),
          title: 'Action $index',
          subtitle: index % 4 == 0 ? 'Details for action $index' : null,
          iconWidget: const SizedBox(
            width: 20,
            height: 20,
            child: ColoredBox(color: CupertinoColors.systemBlue),
          ),
          onTap: () {},
        ),
    ];
  }
  return <Widget>[
    const PullDownMenuHeader(
      key: ValueKey<String>('header'),
      title: 'Document',
      subtitle: 'Updated today',
      leading: ColoredBox(color: CupertinoColors.systemGreen),
    ),
    const PullDownMenuTitle(
      key: ValueKey<String>('title'),
      title: Text('Options'),
      subtitle: Text('Choose an action'),
    ),
    PullDownMenuItem.selectable(
      key: const ValueKey<String>('primary'),
      title: 'Favorite',
      subtitle: 'Keep this document nearby',
      selected: true,
      iconWidget: const SizedBox(
        width: 19,
        height: 25,
        child: ColoredBox(color: CupertinoColors.systemYellow),
      ),
      onTap: () {},
    ),
    PullDownMenuItem(
      key: const ValueKey<String>('secondary'),
      title: 'Share',
      trailing: const Text('Cmd S'),
      iconWidget: const SizedBox(
        width: 32,
        height: 16,
        child: ColoredBox(color: CupertinoColors.systemBlue),
      ),
      iconAlignment:
          scenario.customized ? PullDownMenuItemIconAlignment.leading : null,
      iconBackgroundColor:
          scenario.customized ? CupertinoColors.systemGrey5 : null,
      iconPadding: scenario.customized ? const EdgeInsets.all(4) : null,
      onTap: () {},
    ),
    const PullDownMenuDivider(),
    PullDownMenuItem(
      key: const ValueKey<String>('disabled'),
      title: 'Delete',
      enabled: false,
      isDestructive: true,
      onTap: () {},
    ),
    PullDownMenuItem.custom(
      key: const ValueKey<String>('custom'),
      child: const SizedBox(
        height: 21,
        child: ColoredBox(color: CupertinoColors.systemPurple),
      ),
      onTap: () {},
    ),
    PullDownMenuActionsRow.small(
      key: const ValueKey<String>('actions-small'),
      items: <PullDownMenuItem>[
        for (var index = 0; index < 4; index++)
          PullDownMenuItem(
            title: 'Small $index',
            iconWidget: const SizedBox(
              width: 22,
              height: 18,
              child: ColoredBox(color: CupertinoColors.systemOrange),
            ),
            onTap: () {},
          ),
      ],
    ),
    PullDownMenuActionsRow.medium(
      key: const ValueKey<String>('actions-medium'),
      items: <PullDownMenuItem>[
        for (var index = 0; index < 3; index++)
          PullDownMenuItem(
            title: 'Item $index',
            iconWidget: const SizedBox(
              width: 20,
              height: 28,
              child: ColoredBox(color: CupertinoColors.systemRed),
            ),
            onTap: () {},
          ),
      ],
    ),
  ];
}

const _customTheme = PullDownButtonTheme(
  routeTheme: PullDownMenuRouteTheme(
    width: 300,
    backgroundColor: Color(0xbbe8efff),
    borderRadius: BorderRadius.all(Radius.circular(21)),
    border: Border.fromBorderSide(
      BorderSide(color: CupertinoColors.systemBlue, width: 1.5),
    ),
    padding: EdgeInsets.all(5),
    margin: EdgeInsets.all(3),
    boxShadow: <BoxShadow>[
      BoxShadow(
        color: Color(0x55000066),
        blurRadius: 15,
        spreadRadius: 2,
        offset: Offset(3, 7),
      ),
    ],
    backdropBlurSigma: 12,
  ),
  itemTheme: PullDownMenuItemTheme(
    titleColor: Color(0xff28427d),
    subtitleColor: Color(0xff62799d),
    padding: EdgeInsetsDirectional.fromSTEB(14, 12, 17, 12),
    titleSubtitleGap: 4,
    iconSpacing: 10,
    itemBorderRadius: BorderRadius.all(Radius.circular(8)),
  ),
  titleTheme: PullDownMenuTitleTheme(
    color: Color(0xff41629d),
    titleSubtitleGap: 3,
  ),
);

const _scenarios = <_Scenario>[
  _Scenario('light'),
  _Scenario('dark', brightness: Brightness.dark),
  _Scenario('rtl', direction: TextDirection.rtl),
  _Scenario('accessibility', textScale: 1.5),
  _Scenario('customized', customized: true),
  _Scenario('customized_rtl', customized: true, direction: TextDirection.rtl),
  _Scenario(
    'upward_automatic',
    alignment: Alignment.bottomRight,
    automaticOrder: true,
  ),
  _Scenario('over_start_anchor', alignment: Alignment.topLeft, over: true),
  _Scenario('long_scroll', longMenu: true),
];

class _Scenario {
  const _Scenario(
    this.name, {
    this.brightness = Brightness.light,
    this.direction = TextDirection.ltr,
    this.textScale = 1,
    this.customized = false,
    this.alignment = Alignment.topRight,
    this.automaticOrder = false,
    this.over = false,
    this.longMenu = false,
    this.opaque = false,
    this.noBlur = false,
  });

  final String name;
  final Brightness brightness;
  final TextDirection direction;
  final double textScale;
  final bool customized;
  final Alignment alignment;
  final bool automaticOrder;
  final bool over;
  final bool longMenu;
  final bool opaque;
  final bool noBlur;
}

class _BackdropPainter extends CustomPainter {
  const _BackdropPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    for (var y = 0; y < size.height; y += 31) {
      for (var x = 0; x < size.width; x += 37) {
        paint.color =
            (x ~/ 37 + y ~/ 31).isEven
                ? const Color(0xffc6dbf4)
                : const Color(0xfff4d1c6);
        canvas.drawRect(
          Rect.fromLTWH(x.toDouble(), y.toDouble(), 37, 31),
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(_BackdropPainter oldDelegate) => false;
}

class _CountingPainter extends CustomPainter {
  const _CountingPainter(this.counts, this.index);

  final List<int> counts;
  final int index;

  @override
  void paint(Canvas canvas, Size size) {
    counts[index]++;
    canvas.drawRect(
      Offset.zero & size,
      Paint()..color = CupertinoColors.systemBlue,
    );
  }

  @override
  bool shouldRepaint(_CountingPainter oldDelegate) => false;
}

class _ChangingBackdropPainter extends CustomPainter {
  const _ChangingBackdropPainter(this.frame);

  final int frame;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
      Offset.zero & size,
      Paint()
        ..color =
            frame.isEven
                ? CupertinoColors.systemBlue
                : CupertinoColors.systemOrange,
    );
  }

  @override
  bool shouldRepaint(_ChangingBackdropPainter oldDelegate) =>
      oldDelegate.frame != frame;
}
