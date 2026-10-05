import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pull_down_button/pull_down_button.dart';
import 'package:pull_down_button/src/internals/button.dart';
import 'package:pull_down_button/src/internals/continuous_swipe.dart';

void main() {
  testWidgets('swiping rebuilds only items whose pressed state changes', (
    tester,
  ) async {
    const itemCount = 40;
    final builds = List<int>.filled(itemCount, 0);
    var trackBuilds = false;
    final RebuildDirtyWidgetCallback? previousCallback =
        debugOnRebuildDirtyWidget;
    debugOnRebuildDirtyWidget = (element, builtOnce) {
      previousCallback?.call(element, builtOnce);
      if (trackBuilds && element.widget is MenuActionButton) {
        final key = element.widget.key! as ValueKey<int>;
        builds[key.value]++;
      }
    };
    addTearDown(() => debugOnRebuildDirtyWidget = previousCallback);

    await tester.pumpWidget(
      _testRegion(
        children: List<Widget>.generate(
          itemCount,
          (index) => _button(
            key: ValueKey<int>(index),
            onTap: () {},
            height: 10,
          ),
        ),
      ),
    );
    trackBuilds = true;

    final GestureDetector detector = _regionDetector(tester);
    final Offset first = tester.getCenter(find.byKey(const ValueKey<int>(0)));
    detector.onPanUpdate!(DragUpdateDetails(globalPosition: first));
    await tester.pump();

    expect(builds[0], 1);
    expect(builds.skip(1), everyElement(0));

    for (var index = 0; index < 20; index++) {
      detector.onPanUpdate!(
        DragUpdateDetails(globalPosition: first + Offset(index / 10, 0)),
      );
      await tester.pump();
    }

    expect(builds.fold<int>(0, (sum, count) => sum + count), 1);

    detector.onPanUpdate!(
      DragUpdateDetails(
        globalPosition: tester.getCenter(find.byKey(const ValueKey<int>(1))),
      ),
    );
    await tester.pump();

    expect(builds[0], 2);
    expect(builds[1], 1);
    expect(builds.skip(2), everyElement(0));
  });

  testWidgets('pointer updates are coalesced with one selection haptic', (
    tester,
  ) async {
    final haptics = <MethodCall>[];
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
      SystemChannels.platform,
      (call) async {
        if (call.method == 'HapticFeedback.vibrate') {
          haptics.add(call);
        }
        return null;
      },
    );
    addTearDown(
      () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.platform,
        null,
      ),
    );
    final actions = <int>[];
    await tester.pumpWidget(
      _testRegion(
        children: <Widget>[
          _button(key: const ValueKey<int>(0), onTap: () => actions.add(0)),
          _button(key: const ValueKey<int>(1), onTap: () => actions.add(1)),
        ],
      ),
    );

    final GestureDetector detector = _regionDetector(tester);
    for (var index = 0; index < 2; index++) {
      detector.onPanUpdate!(
        DragUpdateDetails(
          globalPosition: tester.getCenter(find.byKey(ValueKey<int>(index))),
        ),
      );
    }
    await tester.pump();

    expect(_buttonState(tester, const ValueKey<int>(0)).isPressed, isFalse);
    expect(_buttonState(tester, const ValueKey<int>(1)).isPressed, isTrue);
    expect(haptics.map((call) => call.arguments), <String>[
      'HapticFeedbackType.selectionClick',
    ]);

    detector.onPanEnd!(DragEndDetails());
    await tester.pump();

    expect(actions, <int>[1]);
    expect(_buttonState(tester, const ValueKey<int>(1)).isPressed, isFalse);

    detector.onPanUpdate!(
      DragUpdateDetails(
        globalPosition: tester.getCenter(find.byKey(const ValueKey<int>(0))),
      ),
    );
    await tester.pump();
    detector.onPanUpdate!(
      DragUpdateDetails(
        globalPosition: tester.getCenter(find.byKey(const ValueKey<int>(1))),
      ),
    );
    detector.onPanEnd!(DragEndDetails());
    await tester.pump();

    // Completion retains the last rendered selection when the new pointer
    // position and release arrive before another frame, as before.
    expect(actions, <int>[1, 0]);
  });

  testWidgets('swiping outside items clears selection without activating', (
    tester,
  ) async {
    var actions = 0;
    await tester.pumpWidget(
      _testRegion(
        children: <Widget>[
          _button(key: const ValueKey<int>(0), onTap: () => actions++),
          _button(key: const ValueKey<int>(1), onTap: null),
        ],
      ),
    );
    final GestureDetector detector = _regionDetector(tester);
    detector.onPanUpdate!(
      DragUpdateDetails(
        globalPosition: tester.getCenter(find.byKey(const ValueKey<int>(0))),
      ),
    );
    await tester.pump();
    expect(_buttonState(tester, const ValueKey<int>(0)).isPressed, isTrue);

    final Rect rect = tester.getRect(find.byKey(const ValueKey<int>(0)));
    detector.onPanUpdate!(
      DragUpdateDetails(globalPosition: Offset(rect.right, rect.center.dy)),
    );
    await tester.pump();
    expect(_buttonState(tester, const ValueKey<int>(0)).isPressed, isFalse);

    detector.onPanUpdate!(
      DragUpdateDetails(
        globalPosition: tester.getCenter(find.byKey(const ValueKey<int>(1))),
      ),
    );
    await tester.pump();
    detector.onPanEnd!(DragEndDetails());
    await tester.pump();
    expect(_buttonState(tester, const ValueKey<int>(1)).isPressed, isFalse);
    expect(actions, 0);
  });

  testWidgets('real drag highlights its destination and activates on release', (
    tester,
  ) async {
    final actions = <int>[];
    await tester.pumpWidget(
      _testRegion(
        children: <Widget>[
          _button(key: const ValueKey<int>(0), onTap: () => actions.add(0)),
          _button(key: const ValueKey<int>(1), onTap: () => actions.add(1)),
        ],
      ),
    );

    final TestGesture gesture = await tester.startGesture(
      tester.getCenter(find.byKey(const ValueKey<int>(0))),
    );
    await gesture.moveBy(const Offset(0, 25));
    await tester.pump();
    await gesture.moveTo(
      tester.getCenter(find.byKey(const ValueKey<int>(1))),
    );
    await tester.pump();

    expect(_buttonState(tester, const ValueKey<int>(0)).isPressed, isFalse);
    expect(_buttonState(tester, const ValueKey<int>(1)).isPressed, isTrue);
    expect(actions, isEmpty);

    await gesture.up();
    await tester.pump();
    expect(actions, <int>[1]);
    expect(_buttonState(tester, const ValueKey<int>(1)).isPressed, isFalse);
  });

  testWidgets('public menu drag preserves builder states and route callbacks', (
    tester,
  ) async {
    final actions = <int>[];
    final states = <PullDownMenuItemState>[];
    var cancellations = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: Center(
          child: PullDownButton(
            onCanceled: () => cancellations++,
            buttonBuilder:
                (context, showMenu) => TextButton(
                  onPressed: showMenu,
                  child: const Text('Open menu'),
                ),
            itemBuilder:
                (context) => <Widget>[
                  PullDownMenuItem(onTap: () => actions.add(0), title: 'First'),
                  PullDownMenuItem.builder(
                    onTap: () => actions.add(1),
                    builder: (context, state) {
                      states.add(state);
                      return const SizedBox(
                        height: 44,
                        child: Text('Custom destination'),
                      );
                    },
                  ),
                ],
          ),
        ),
      ),
    );
    await tester.tap(find.text('Open menu'));
    await tester.pumpAndSettle();

    expect(states.last.isPressed, isFalse);
    expect(states.last.isHovered, isFalse);
    expect(states.last.enabled, isTrue);
    final TestGesture gesture = await tester.startGesture(
      tester.getCenter(find.text('First')),
    );
    await gesture.moveBy(const Offset(0, 25));
    await tester.pump();
    await gesture.moveTo(tester.getCenter(find.text('Custom destination')));
    await tester.pump();

    expect(states.last.isPressed, isTrue);
    expect(states.last.isHovered, isFalse);
    expect(actions, isEmpty);
    expect(cancellations, 0);

    await gesture.up();
    await tester.pumpAndSettle();

    expect(actions, <int>[1]);
    expect(cancellations, 0);
    expect(find.text('Custom destination'), findsNothing);

    await tester.tap(find.text('Open menu'));
    await tester.pumpAndSettle();
    await tester.tapAt(const Offset(1, 1));
    await tester.pumpAndSettle();

    expect(actions, <int>[1]);
    expect(cancellations, 1);
    expect(find.text('Custom destination'), findsNothing);
  });

  testWidgets('new buttons can mount while a continuous swipe is active', (
    tester,
  ) async {
    var addItem = false;
    late StateSetter update;
    await tester.pumpWidget(
      MaterialApp(
        home: StatefulBuilder(
          builder: (context, setState) {
            update = setState;
            return Center(
              child: SwipeRegion(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    _button(key: const ValueKey<int>(0), onTap: () {}),
                    if (addItem)
                      _button(key: const ValueKey<int>(1), onTap: () {}),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
    final GestureDetector detector = _regionDetector(tester);
    detector.onPanUpdate!(
      DragUpdateDetails(
        globalPosition: tester.getCenter(find.byKey(const ValueKey<int>(0))),
      ),
    );
    await tester.pump();

    update(() => addItem = true);
    await tester.pump();
    expect(tester.takeException(), isNull);

    detector.onPanUpdate!(
      DragUpdateDetails(
        globalPosition: tester.getCenter(find.byKey(const ValueKey<int>(1))),
      ),
    );
    await tester.pump();
    expect(_buttonState(tester, const ValueKey<int>(0)).isPressed, isFalse);
    expect(_buttonState(tester, const ValueKey<int>(1)).isPressed, isTrue);
  });

  testWidgets('buttons reconnect to their new swipe region when reparented', (
    tester,
  ) async {
    var moveButton = false;
    var actions = 0;
    final key = GlobalKey<State<StatefulWidget>>();
    late StateSetter update;
    await tester.pumpWidget(
      MaterialApp(
        home: StatefulBuilder(
          builder: (context, setState) {
            update = setState;
            return Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  for (var index = 0; index < 2; index++)
                    SwipeRegion(
                      child: SizedBox(
                        width: 200,
                        height: 40,
                        child:
                            (index == 1) == moveButton
                                ? _button(key: key, onTap: () => actions++)
                                : null,
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
    final GestureDetector first = tester.widget<GestureDetector>(
      find
          .descendant(
            of: find.byType(SwipeRegion).first,
            matching: find.byType(GestureDetector),
          )
          .first,
    );
    final GestureDetector second = tester.widget<GestureDetector>(
      find
          .descendant(
            of: find.byType(SwipeRegion).last,
            matching: find.byType(GestureDetector),
          )
          .first,
    );
    first.onPanUpdate!(
      DragUpdateDetails(globalPosition: tester.getCenter(find.byKey(key))),
    );
    await tester.pump();
    expect(_buttonState(tester, key).isPressed, isTrue);

    update(() => moveButton = true);
    await tester.pump();
    first.onPanEnd!(DragEndDetails());
    await tester.pump();
    expect(actions, 0);

    second.onPanUpdate!(
      DragUpdateDetails(globalPosition: tester.getCenter(find.byKey(key))),
    );
    await tester.pump();
    expect(_buttonState(tester, key).isPressed, isTrue);
    second.onPanEnd!(DragEndDetails());
    await tester.pump();
    expect(actions, 1);
  });

  testWidgets('hover and press still expose states and customized colors', (
    tester,
  ) async {
    var actions = 0;
    await tester.pumpWidget(
      _testRegion(
        children: <Widget>[
          _button(key: const ValueKey<int>(0), onTap: () => actions++),
        ],
      ),
    );
    final Finder button = find.byKey(const ValueKey<int>(0));
    final TestGesture mouse = await tester.createGesture(
      kind: PointerDeviceKind.mouse,
    );
    await mouse.addPointer(location: Offset.zero);
    await mouse.moveTo(tester.getCenter(button));
    await tester.pump();

    expect(_buttonState(tester, const ValueKey<int>(0)).isHovered, isTrue);
    expect(_buttonColor(tester, button), Colors.green);

    final GestureDetector detector = tester.widget<GestureDetector>(
      find.descendant(of: button, matching: find.byType(GestureDetector)),
    );
    detector.onTapDown!(TapDownDetails());
    await tester.pump();
    expect(_buttonState(tester, const ValueKey<int>(0)).isPressed, isTrue);
    expect(_buttonState(tester, const ValueKey<int>(0)).isHovered, isFalse);
    expect(_buttonColor(tester, button), Colors.red);

    detector.onTapCancel!();
    await tester.pump();
    expect(_buttonState(tester, const ValueKey<int>(0)).isPressed, isFalse);
    expect(_buttonState(tester, const ValueKey<int>(0)).isHovered, isTrue);
    expect(_buttonColor(tester, button), Colors.green);

    await mouse.removePointer();
    await tester.pump();
    expect(_buttonState(tester, const ValueKey<int>(0)).isHovered, isFalse);
    expect(_buttonColor(tester, button), Colors.blue);
    expect(actions, 0);
  });

  testWidgets('mounted buttons honor enabled changes and clear highlights', (
    tester,
  ) async {
    var actions = 0;
    var enabled = true;
    late StateSetter update;
    await tester.pumpWidget(
      MaterialApp(
        home: StatefulBuilder(
          builder: (context, setState) {
            update = setState;
            return SwipeRegion(
              child: Center(
                child: _button(
                  key: const ValueKey<int>(0),
                  onTap: enabled ? () => actions++ : null,
                ),
              ),
            );
          },
        ),
      ),
    );
    final GestureDetector regionDetector = _regionDetector(tester);
    regionDetector.onPanUpdate!(
      DragUpdateDetails(
        globalPosition: tester.getCenter(find.byKey(const ValueKey<int>(0))),
      ),
    );
    await tester.pump();
    expect(_buttonState(tester, const ValueKey<int>(0)).isPressed, isTrue);

    update(() => enabled = false);
    await tester.pump();
    expect(_buttonState(tester, const ValueKey<int>(0)).isPressed, isFalse);

    regionDetector.onPanEnd!(DragEndDetails());
    await tester.pump();
    await tester.tap(find.byKey(const ValueKey<int>(0)));
    await tester.pump();
    expect(actions, 0);

    update(() => enabled = true);
    await tester.pump();
    await tester.tap(find.byKey(const ValueKey<int>(0)));
    await tester.pump();
    expect(actions, 1);
  });

  testWidgets('disposing a region cancels pending swipe notifications', (
    tester,
  ) async {
    var actions = 0;
    var showRegion = true;
    late StateSetter update;
    late GestureDetector detector;
    await tester.pumpWidget(
      MaterialApp(
        home: StatefulBuilder(
          builder: (context, setState) {
            update = setState;
            if (!showRegion) {
              detector.onPanEnd!(DragEndDetails());
              return const SizedBox();
            }
            return Center(
              child: SwipeRegion(
                child: _button(
                  key: const ValueKey<int>(0),
                  onTap: () => actions++,
                ),
              ),
            );
          },
        ),
      ),
    );
    detector = _regionDetector(tester);
    detector.onPanUpdate!(
      DragUpdateDetails(
        globalPosition: tester.getCenter(find.byKey(const ValueKey<int>(0))),
      ),
    );
    await tester.pump();
    update(() => showRegion = false);
    await tester.pump();
    await tester.pump();

    expect(tester.takeException(), isNull);
    expect(actions, 0);
  });
}

Widget _testRegion({required List<Widget> children}) => MaterialApp(
  home: Center(
    child: SwipeRegion(
      child: Column(mainAxisSize: MainAxisSize.min, children: children),
    ),
  ),
);

Widget _button({
  required Key key,
  required VoidCallback? onTap,
  double height = 40,
}) => MenuActionButton(
  key: key,
  onTap: onTap,
  pressedColor: Colors.red,
  hoverColor: Colors.green,
  backgroundColor: Colors.blue,
  child: SizedBox(width: 200, height: height),
);

GestureDetector _regionDetector(WidgetTester tester) =>
    tester.widget<GestureDetector>(
      find
          .descendant(
            of: find.byType(SwipeRegion),
            matching: find.byType(GestureDetector),
          )
          .first,
    );

MenuActionButtonState _buttonState(WidgetTester tester, Key key) =>
    tester.widget<MenuActionButtonState>(
      find.descendant(
        of: find.byKey(key),
        matching: find.byType(MenuActionButtonState),
      ),
    );

Color? _buttonColor(WidgetTester tester, Finder button) =>
    (tester
                .widget<DecoratedBox>(
                  find.descendant(
                    of: button,
                    matching: find.byType(DecoratedBox),
                  ),
                )
                .decoration
            as ShapeDecoration)
        .color;
