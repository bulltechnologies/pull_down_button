import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'button.dart';

/// A widget that tracks an [SwipeState] of current global "pan" offset.
///
/// [SwipeRegion] is used to track and provide said [SwipeState] to all
/// descendants in [child] widget.
///
/// Changes are coalesced once per frame. Descendants can listen directly to
/// the notifier without rebuilding for positions that leave their state
/// unchanged, or use [SwipeState.maybeOf] to rebuild on every update.
///
/// Descendants listen to [SwipeState] changes using [SwipeState.maybeOf].
@immutable
class SwipeRegion extends StatefulWidget {
  /// Creates [SwipeRegion].
  const SwipeRegion({
    super.key,
    required this.child,
  });

  /// The widget below this widget in the tree.
  final Widget child;

  @override
  State<SwipeRegion> createState() => _SwipeRegionState();
}

class _SwipeRegionState extends State<SwipeRegion> {
  _SwipeNotifier? _state;

  @override
  void initState() {
    super.initState();
    _state = _SwipeNotifier();
  }

  @override
  void dispose() {
    _state?.dispose();
    _state = null;
    super.dispose();
  }

  void _onPanUpdate(DragUpdateDetails details) {
    _state?.value = SwipeInProcessState._(
      offset: details.globalPosition,
    );
  }

  void _onPanEnd(DragEndDetails _) {
    _state?.value = const SwipeCompleteState._();
  }

  @override
  Widget build(BuildContext context) => GestureDetector(
    onPanUpdate: _onPanUpdate,
    onPanEnd: _onPanEnd,
    child: _SwipeNotifierScope(
      notifier: _state,
      child: _SwipeState(
        notifier: _state,
        child: widget.child,
      ),
    ),
  );
}

/// Publishes the latest pointer state at the start of the next frame, matching
/// the frame coalescing previously provided by [InheritedNotifier].
class _SwipeNotifier extends ChangeNotifier
    implements ValueListenable<SwipeState> {
  SwipeState _value = const SwipeInitState._();
  int? _callbackId;

  @override
  SwipeState get value => _value;

  set value(SwipeState value) {
    if (_value == value) {
      return;
    }

    _value = value;
    _callbackId ??= SchedulerBinding.instance.scheduleFrameCallback((_) {
      _callbackId = null;
      notifyListeners();
    });
  }

  @override
  void dispose() {
    if (_callbackId != null) {
      SchedulerBinding.instance.cancelFrameCallbackWithId(_callbackId!);
    }
    super.dispose();
  }
}

/// Depends only on the identity of the region's notifier, rather than each
/// pointer position, so buttons can rebuild only when their highlight changes.
@immutable
class _SwipeNotifierScope extends InheritedWidget {
  const _SwipeNotifierScope({
    required this.notifier,
    required super.child,
  });

  final ValueListenable<SwipeState>? notifier;

  @override
  bool updateShouldNotify(_SwipeNotifierScope oldWidget) =>
      notifier != oldWidget.notifier;
}

/// An inherited widget used by descendants that rebuild for each [SwipeState].
/// [MenuActionButton] listens through [_SwipeNotifierScope] so its build is
/// independent of pointer updates that keep the same item selected.
@immutable
class _SwipeState extends InheritedNotifier<_SwipeNotifier> {
  const _SwipeState({
    required super.notifier,
    required super.child,
  });

  /// The closest nullable instance of this class that encloses the given
  /// context.
  static SwipeState? maybeOf(BuildContext context) =>
      context
          .dependOnInheritedWidgetOfExactType<_SwipeState>()
          ?.notifier
          ?.value;
}

/// Basic continuous swipe state class.
@immutable
sealed class SwipeState {
  /// Returns the current swipe state from the closest [_SwipeState] ancestor.
  ///
  /// If there is no ancestor, it returns `null`.
  static SwipeState? maybeOf(BuildContext context) =>
      _SwipeState.maybeOf(context);

  /// Returns the region's notifier without subscribing to every pointer state
  /// through inherited-widget rebuilds. A dependency is retained on the region
  /// itself so listeners can reconnect when their region changes.
  static ValueListenable<SwipeState>? notifierOf(BuildContext context) =>
      context
          .dependOnInheritedWidgetOfExactType<_SwipeNotifierScope>()
          ?.notifier;
}

/// Initial continuous swipe state, the user has not yet initiated the movement.
@immutable
class SwipeInitState implements SwipeState {
  const SwipeInitState._();
}

/// The coordinates of the movement are transmitted, the user in the process of
/// selecting the menu item.
@immutable
class SwipeInProcessState implements SwipeState {
  const SwipeInProcessState._({
    required this.offset,
  });

  /// The offset of the current global "pan".
  final Offset offset;

  /// Determines whether a menu item is selected based on the current finger
  /// position ([offset]), menu [itemSize] and [itemPosition].
  bool isWithinMenuItem({
    required Offset itemPosition,
    required Size itemSize,
  }) {
    final double dy = offset.dy;
    final double dx = offset.dx;

    final double itemDY = itemPosition.dy;
    final double itemDX = itemPosition.dx;

    return (dy >= itemDY && (itemDY + itemSize.height) > dy) &&
        (dx >= itemDX && (itemDX + itemSize.width) > dx);
  }
}

/// The state of the completed continuous swipe, the user has selected the item.
@immutable
class SwipeCompleteState implements SwipeState {
  const SwipeCompleteState._();
}
