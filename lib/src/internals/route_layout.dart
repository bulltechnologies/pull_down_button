part of 'route.dart';

/// Positioning and size of the menu on the screen.
@immutable
class _PopupMenuRouteLayout extends SingleChildLayoutDelegate {
  const _PopupMenuRouteLayout({
    required this.padding,
    required this.avoidBounds,
    required this.buttonRect,
    required this.menuPosition,
    required this.menuOffset,
    required this.screenPadding,
  });

  final EdgeInsets padding;
  final Set<Rect> avoidBounds;
  final Rect buttonRect;
  final PullDownMenuPosition menuPosition;
  final double menuOffset;
  final double screenPadding;

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    final Size biggest = constraints.biggest;

    final double constraintsHeight = biggest.height;

    final bool check = buttonRect.center.dy >= constraintsHeight / 2;

    final double height = switch (menuPosition) {
      PullDownMenuPosition.over when check => buttonRect.bottom - padding.top,
      PullDownMenuPosition.over =>
        constraintsHeight - buttonRect.top - padding.bottom,
      PullDownMenuPosition.automatic when check => buttonRect.top - padding.top,
      PullDownMenuPosition.automatic =>
        constraintsHeight - buttonRect.bottom - padding.bottom,
    };

    return BoxConstraints.loose(
      Size(biggest.width, height),
    ).deflate(
      EdgeInsets.symmetric(horizontal: screenPadding),
    );
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    final double childWidth = childSize.width;

    final _MenuHorizontalPosition horizontalPosition =
        _MenuHorizontalPosition.get(size, buttonRect);

    final double x = switch (horizontalPosition) {
      _MenuHorizontalPosition.right =>
        buttonRect.right - childWidth + menuOffset,
      _MenuHorizontalPosition.left => buttonRect.left - menuOffset,
      _MenuHorizontalPosition.center =>
        buttonRect.left + buttonRect.width / 2 - childWidth / 2,
    };

    final Rect rect = Offset.zero & size;
    // Most screens have no hinge or other obstructing display feature. Avoid
    // creating and searching a sub-screen list on each size-animation layout.
    final Rect subScreen =
        avoidBounds.isEmpty
            ? rect
            : _PositionUtils.closestScreen(
              DisplayFeatureSubScreen.subScreensInBounds(rect, avoidBounds),
              buttonRect.center,
            );

    final double dx = _PositionUtils.fitX(
      x,
      subScreen,
      childWidth,
      padding,
      screenPadding,
    );
    final double dy = _PositionUtils.fitY(
      buttonRect,
      subScreen,
      childSize.height,
      padding,
      menuPosition,
    );

    return Offset(dx, dy);
  }

  @override
  bool shouldRelayout(_PopupMenuRouteLayout oldDelegate) =>
      padding != oldDelegate.padding ||
      !setEquals(avoidBounds, oldDelegate.avoidBounds) ||
      buttonRect != oldDelegate.buttonRect ||
      menuPosition != oldDelegate.menuPosition ||
      menuOffset != oldDelegate.menuOffset ||
      screenPadding != oldDelegate.screenPadding;
}

/// A set of utils to help calculating menu's position on screen.
@immutable
abstract class _PositionUtils {
  const _PositionUtils._();

  /// Returns closest screen for specific [point].
  static Rect closestScreen(Iterable<Rect> screens, Offset point) {
    final Iterator<Rect> iterator = screens.iterator;
    if (!iterator.moveNext()) {
      throw StateError('No element');
    }

    Rect closest = iterator.current;
    double closestDistance = (closest.center - point).distanceSquared;
    while (iterator.moveNext()) {
      final Rect screen = iterator.current;
      final double distance = (screen.center - point).distanceSquared;
      if (distance < closestDistance) {
        closest = screen;
        closestDistance = distance;
      }
    }

    return closest;
  }

  /// Returns the `y` a top left offset point for menu's container.
  static double fitY(
    Rect buttonRect,
    Rect screen,
    double childHeight,
    EdgeInsets padding,
    PullDownMenuPosition menuPosition,
  ) {
    double y = buttonRect.top;
    final double buttonHeight = buttonRect.height;

    final bool isInBottomHalf = y + buttonHeight / 2 >= screen.height / 2;

    switch (menuPosition) {
      case PullDownMenuPosition.over:
        if (isInBottomHalf) {
          y -= childHeight - buttonHeight;
        }
      case PullDownMenuPosition.automatic:
        // Native variant applies additional 5px of padding to menu if
        // [buttonHeight] is smaller than 44px.
        final padding =
            buttonHeight < kMinInteractiveDimensionCupertino ? 5 : 0;

        isInBottomHalf
            ? y -= childHeight + padding
            : y += buttonHeight + padding;
    }

    return y;
  }

  /// Returns the `x` a top left offset point for menu's container.
  static double fitX(
    double wantedX,
    Rect screen,
    double childWidth,
    EdgeInsets padding,
    double screenPadding,
  ) {
    final double leftSafeArea = screen.left + screenPadding + padding.left;
    final double rightSafeArea = screen.right - screenPadding - padding.right;

    if (wantedX < leftSafeArea) {
      return leftSafeArea;
    } else if (wantedX + childWidth > rightSafeArea) {
      return rightSafeArea - childWidth;
    }

    return wantedX;
  }
}
