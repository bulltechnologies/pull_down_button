import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';

import 'animation.dart';
import 'menu_config.dart';

/// An [AnimatedContainer] with theme-defined [duration] and [curve].
///
/// Is used to animate a container on text scale factor change.
@immutable
final class AnimatedMenuContainer extends StatelessWidget {
  /// Creates [AnimatedMenuContainer].
  const AnimatedMenuContainer({
    super.key,
    this.constraints,
    this.alignment,
    this.padding,
    this.margin,
    this.decoration,
    this.clipBehavior = Clip.none,
    required this.child,
  });

  final BoxConstraints? constraints;
  final AlignmentGeometry? alignment;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Decoration? decoration;
  final Clip clipBehavior;
  final Widget child;

  @override
  Widget build(BuildContext context) => AnimatedContainer(
    constraints: constraints,
    alignment: alignment,
    padding: padding,
    margin: margin,
    decoration: decoration,
    clipBehavior: clipBehavior,
    duration:
        MenuConfig.ambientThemeOf(context).routeTheme.sizeChangeDuration!,
    curve: AnimationUtils.kOnSizeChangeCurve,
    child: child,
  );
}

/// A widget used to create a leading widget for pull-down menu items while
/// complying with layouts defined in the Apple Design Resources Sketch file.
///
/// See also:
///
/// * Apple Design Resources Sketch and Figma [libraries](https://developer.apple.com/design/resources/)
@immutable
class LeadingWidgetBox extends StatelessWidget {
  /// Creates [LeadingWidgetBox].
  const LeadingWidgetBox({
    super.key,
    this.child,
    this.height,
    this.width = 20,
    this.endSpacing = 4,
  });

  /// The widget below this widget in the tree.
  final Widget? child;

  /// If non-null, requires the child to have exactly this height.
  final double? height;

  /// The width of [LeadingWidgetBox].
  final double width;

  /// Spacing after the leading widget.
  final double endSpacing;

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsetsDirectional.only(end: endSpacing),
    child: _TextScaledSizedBox(
      width: width,
      height: height,
      child: child,
    ),
  );
}

/// A widget used to create an icon widget for pull-down menu items while
/// complying with layouts defined in the Apple Design Resources Sketch file.
///
/// See also:
///
/// * Apple Design Resources Sketch and Figma [libraries](https://developer.apple.com/design/resources/)
@immutable
class IconBox extends StatelessWidget {
  /// Creates [IconBox].
  const IconBox({
    super.key,
    this.color,
    this.size,
    this.backgroundColor,
    this.borderRadius,
    this.padding,
    required this.child,
  }) : _config = const (height: 22, width: 20, size: 22);

  /// Creates [IconBox.small].
  const IconBox.small({
    super.key,
    this.color,
    this.size,
    this.backgroundColor,
    this.borderRadius,
    this.padding,
    required this.child,
  }) : _config = const (height: 18, width: 18, size: 17);

  /// The widget below this widget in the tree.
  final Widget child;

  /// The color of icon widget.
  final Color? color;

  /// Custom size for the icon.
  final double? size;

  /// Optional background color for the icon box container.
  final Color? backgroundColor;

  /// Optional border radius for the icon box container.
  final BorderRadius? borderRadius;

  /// Optional padding inside the icon box container.
  final EdgeInsetsGeometry? padding;

  /// The icons dimensions.
  final ({double height, double width, double size}) _config;

  @override
  Widget build(BuildContext context) {
    final double textScaleFactor = MediaQuery.textScalerOf(context).scale(1);
    final double resolvedSize = (size ?? _config.size) * textScaleFactor;
    final double resolvedWidth = size ?? _config.width;
    final double resolvedHeight = size ?? _config.height;

    Widget iconWidget = _TextScaledSizedBox(
      height: resolvedHeight,
      width: resolvedWidth,
      child: IconTheme.merge(
        data: IconThemeData(
          color: color,
          size: resolvedSize,
        ),
        child: child,
      ),
    );

    if (backgroundColor != null || borderRadius != null || padding != null) {
      iconWidget = Container(
        padding: padding,
        decoration: ShapeDecoration(
          color: backgroundColor,
          shape: RoundedSuperellipseBorder(
            borderRadius: borderRadius ?? BorderRadius.zero,
          ),
        ),
        child: iconWidget,
      );
    }

    return iconWidget;
  }
}

/// A widget used to create a icon widget for pull-down header items while
/// complying with layouts defined in the Apple Design Resources Sketch file.
///
/// See also:
///
/// * Apple Design Resources Sketch and Figma [libraries](https://developer.apple.com/design/resources/)
@immutable
class IconActionBox extends StatelessWidget {
  /// Creates [IconActionBox].
  const IconActionBox({
    super.key,
    required this.child,
    required this.color,
    this.size,
  });

  /// The widget below this widget in the tree.
  final Widget child;

  /// The color of icon.
  final Color? color;

  /// Custom size for the icon action box.
  final double? size;

  /// The size of [IconActionBox].
  static const double _kSize = 28;

  /// The size of icon at the default text scale factor.
  static const double _kIconSize = 17;

  @override
  Widget build(BuildContext context) {
    final double textScaleFactor = MediaQuery.textScalerOf(context).scale(1);
    final double boxSize = size ?? _kSize;
    final double iconSize =
        (size != null ? size! * (_kIconSize / _kSize) : _kIconSize) *
        textScaleFactor;

    return _TextScaledSizedBox(
      height: boxSize,
      width: boxSize,
      child: IconTheme.merge(
        data: IconThemeData(
          color: color,
          size: iconSize,
        ),
        child: child,
      ),
    );
  }
}

/// Rework of [SizedBox] with text scale factor applied internally.
@immutable
class _TextScaledSizedBox extends SingleChildRenderObjectWidget {
  /// Creates [_TextScaledSizedBox].
  const _TextScaledSizedBox({
    this.width,
    this.height,
    super.child,
  });

  /// If non-null, requires the child to have exactly this width.
  final double? width;

  /// If non-null, requires the child to have exactly this height.
  final double? height;

  BoxConstraints _additionalConstraints(BuildContext context) {
    final double textScaleFactor = MediaQuery.textScalerOf(context).scale(1);

    return BoxConstraints.tightFor(
      width: width != null ? width! * textScaleFactor : null,
      height: height != null ? height! * textScaleFactor : null,
    );
  }

  @override
  RenderConstrainedBox createRenderObject(BuildContext context) =>
      RenderConstrainedBox(
        additionalConstraints: _additionalConstraints(context),
      );

  @override
  void updateRenderObject(
    BuildContext context,
    RenderConstrainedBox renderObject,
  ) => renderObject.additionalConstraints = _additionalConstraints(context);
}
