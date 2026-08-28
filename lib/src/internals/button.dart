/// @docImport '/src/items/header.dart';
/// @docImport '/src/items/item.dart';
library;

import 'dart:async' show unawaited;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'continuous_swipe.dart';
import 'extensions.dart';

/// Default menu gesture detector for applying on-pressed or on-hover colors,
/// and providing builder method that exposes the `isHovered` and `isPressed`
/// state to descendant widgets.
@immutable
class MenuActionButton extends StatefulWidget {
  /// Creates [MenuActionButton].
  const MenuActionButton({
    super.key,
    required this.onTap,
    required this.pressedColor,
    required this.hoverColor,
    this.backgroundColor,
    required this.child,
    this.borderRadius = BorderRadius.zero,
    this.border,
    this.margin,
    this.mouseCursor,
  });

  /// Called when the menu item is tapped.
  final GestureTapCallback? onTap;

  /// Color of container during a press event.
  final Color pressedColor;

  /// Color of container during a hover event.
  final Color hoverColor;

  /// Default idle color of container when neither hovered nor pressed.
  final Color? backgroundColor;

  /// The widget below this widget in the tree.
  final Widget child;

  /// Border radius of the pressed, hover, and idle container highlight.
  final BorderRadius borderRadius;

  /// Optional border around the container.
  final BoxBorder? border;

  /// Optional outer margin around the container.
  final EdgeInsetsGeometry? margin;

  /// Custom mouse cursor.
  final MouseCursor? mouseCursor;

  @override
  State<MenuActionButton> createState() => _MenuActionButtonState();
}

class _MenuActionButtonState extends State<MenuActionButton> {
  bool _isPressed = false;
  bool _isHovered = false;

  late final bool enabled = widget.onTap != null;

  Offset get _currentPosition =>
      context.currentRenderBox.localToGlobal(Offset.zero);

  Size get _currentSize => context.currentRenderBox.size;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final SwipeState? swipeState = SwipeState.maybeOf(context);

    if (swipeState != null) {
      swipeStateListener(swipeState);
    }
  }

  void swipeStateListener(SwipeState state) {
    if (state is SwipeInProcessState && enabled) {
      final bool isWithinMenuItem = state.isWithinMenuItem(
        itemPosition: _currentPosition,
        itemSize: _currentSize,
      );

      if (_isPressed != isWithinMenuItem) {
        if (isWithinMenuItem) {
          unawaited(HapticFeedback.selectionClick());
        }

        setState(() => _isPressed = isWithinMenuItem);
      }
    }

    if (state is SwipeCompleteState && _isPressed) {
      onTap();
    }
  }

  void onTap() {
    if (!enabled) {
      return;
    }

    widget.onTap!();

    if (mounted) {
      setState(() {
        _isPressed = false;
        _isHovered = false;
      });
    }
  }

  void onEnter(PointerEnterEvent _) {
    if (enabled && !_isHovered) {
      setState(() => _isHovered = true);
    }
  }

  void onExit(PointerExitEvent _) {
    if (_isHovered) {
      setState(() => _isHovered = false);
    }
  }

  void onTapDown(TapDownDetails _) {
    if (enabled && !_isPressed) {
      setState(() => _isPressed = true);
    }
  }

  void onTapUp(TapUpDetails _) {
    if (_isPressed) {
      setState(() => _isPressed = false);
    }
  }

  void onTapCancel() {
    if (_isPressed) {
      setState(() => _isPressed = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final MouseCursor effectiveCursor = widget.mouseCursor ??
        (enabled && kIsWeb ? SystemMouseCursors.click : MouseCursor.defer);

    final Color? effectiveColor = _isPressed
        ? widget.pressedColor
        : _isHovered
        ? widget.hoverColor
        : widget.backgroundColor;

    Widget result = MouseRegion(
      cursor: effectiveCursor,
      onEnter: onEnter,
      onExit: onExit,
      hitTestBehavior: HitTestBehavior.opaque,
      child: GestureDetector(
        onTap: onTap,
        onTapDown: onTapDown,
        onTapUp: onTapUp,
        onTapCancel: onTapCancel,
        behavior: HitTestBehavior.opaque,
        child: DecoratedBox(
          decoration: ShapeDecoration(
            color: effectiveColor,
            shape: RoundedSuperellipseBorder(
              borderRadius: widget.borderRadius,
              side: widget.border is Border
                  ? (widget.border! as Border).top
                  : BorderSide.none,
            ),
          ),
          child: MenuActionButtonState(
            isHovered: _isHovered && !_isPressed,
            isPressed: _isPressed,
            child: MenuActionButtonHoverState(
              isHovered: _isHovered && !_isPressed,
              child: widget.child,
            ),
          ),
        ),
      ),
    );

    if (widget.margin != null) {
      result = Padding(
        padding: widget.margin!,
        child: result,
      );
    }

    return result;
  }
}

/// An inherited widget providing full hover and press states for
/// [MenuActionButton] descendants.
@immutable
class MenuActionButtonState extends InheritedWidget {
  /// Creates [MenuActionButtonState].
  const MenuActionButtonState({
    super.key,
    required this.isHovered,
    required this.isPressed,
    required super.child,
  });

  /// Whether the button is currently hovered.
  final bool isHovered;

  /// Whether the button is currently pressed.
  final bool isPressed;

  /// Returns the current [MenuActionButtonState] from the closest ancestor.
  static MenuActionButtonState? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<MenuActionButtonState>();

  /// Returns whether the closest ancestor [MenuActionButton] is hovered.
  static bool isHoveredOf(BuildContext context) =>
      maybeOf(context)?.isHovered ?? false;

  /// Returns whether the closest ancestor [MenuActionButton] is pressed.
  static bool isPressedOf(BuildContext context) =>
      maybeOf(context)?.isPressed ?? false;

  @override
  bool updateShouldNotify(MenuActionButtonState oldWidget) =>
      isHovered != oldWidget.isHovered || isPressed != oldWidget.isPressed;
}

/// An inherited widget used to indicate if [PullDownMenuItem] is currently
/// hovered.
///
/// Is internally used by [MenuActionButton] to provide on-hover state to all
/// possible configurations of [PullDownMenuItem] and [PullDownMenuHeader].
@immutable
class MenuActionButtonHoverState extends InheritedWidget {
  /// Creates [MenuActionButtonHoverState].
  const MenuActionButtonHoverState({
    super.key,
    required this.isHovered,
    required super.child,
  });

  /// Whether a [PullDownMenuItem] is currently hovered.
  final bool isHovered;

  /// Returns the current hover state from the closest
  /// [MenuActionButtonHoverState] ancestor.
  static bool of(BuildContext context) =>
      context
          .dependOnInheritedWidgetOfExactType<MenuActionButtonHoverState>()!
          .isHovered;

  @override
  bool updateShouldNotify(MenuActionButtonHoverState oldWidget) =>
      isHovered != oldWidget.isHovered;
}
