/// @docImport '/pull_down_button.dart';
/// @docImport '/src/internals/content_size_category.dart';
library;

import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';

import '/src/internals/animation.dart';
import '/src/internals/blur.dart';
import '/src/internals/content_size_category.dart';
import '_dynamic_color.dart';
import 'theme.dart';

/// Signature for the callback invoked when pull-down menu's body is being
/// built.
///
/// The [borderRadius] is passed from [PullDownMenuRouteTheme.borderRadius].
///
/// Used by [PullDownMenuRouteTheme.borderClipper].
@experimental
typedef PullDownMenuRouteBorderClipper =
    SingleChildRenderObjectWidget Function(
      BorderRadius borderRadius,
      Widget child,
    );

/// Signature for the builder callback to morph or wrap the pull-down menu
/// container with a custom widget or transition.
///
/// Used by [PullDownMenuRouteTheme.containerBuilder].
typedef PullDownMenuContainerBuilder =
    Widget Function(
      BuildContext context,
      Widget child,
    );

/// Defines the visual properties of the pull-down menus.
///
/// Is used by the menu's container.
///
/// Typically a [PullDownMenuRouteTheme] is specified as part of the overall
/// [PullDownButtonTheme] with [PullDownButtonTheme.routeTheme].
///
/// All [PullDownMenuRouteTheme] properties are `null` by default. When null,
/// defined earlier use cases will use the values from [PullDownButtonTheme]
/// if they exist, otherwise it will use iOS 18 defaults specified in
/// [PullDownMenuRouteTheme.defaults].
@immutable
class PullDownMenuRouteTheme with Diagnosticable {
  /// Creates the set of properties used to configure [PullDownMenuRouteTheme].
  const PullDownMenuRouteTheme({
    this.backgroundColor,
    this.borderRadius,
    this.borderClipper,
    this.shadow,
    this.boxShadow,
    this.border,
    this.width,
    this.accessibilityWidth,
    this.minWidth,
    this.maxWidth,
    this.maxHeight,
    this.constraints,
    this.padding,
    this.margin,
    this.clipBehavior,
    this.containerBuilder,
    this.barrierColor,
    this.barrierDismissible,
    this.barrierLabel,
    this.backdropBlurSigma,
    this.showBackdropFilter,
    this.openDuration,
    this.closeDuration,
    this.sizeChangeDuration,
    this.openCurve,
    this.closeCurve,
    this.menuScreenPadding,
  });

  /// Creates default set of properties used to configure
  /// [PullDownMenuRouteTheme].
  ///
  /// Default properties were taken from the Apple Design Resources Sketch and
  /// Figma libraries for iOS 18 and iPadOS 18.
  ///
  /// See also:
  ///
  /// * Apple Design Resources Sketch and Figma [libraries](https://developer.apple.com/design/resources/)
  @internal
  const factory PullDownMenuRouteTheme.defaults(BuildContext context) =
      _Defaults;

  /// The background color of the pull-down menu.
  final Color? backgroundColor;

  /// The border radius of the pull-down menu.
  final BorderRadius? borderRadius;

  /// The border radius clipper of the pull-down menu.
  ///
  /// Can be set to [ClipRSuperellipse] on newer Flutter versions past 3.32.0
  /// with Impeller enabled.
  ///
  /// The *borderRadius* is passed from [PullDownMenuRouteTheme.borderRadius].
  ///
  /// If null, defaults to [ClipRRect].
  ///
  /// Example:
  ///
  /// ```dart
  /// PullDownMenuRouteTheme(
  ///   borderClipper: (borderRadius, child) =>
  ///     ClipRSuperellipse(
  ///       borderRadius: borderRadius,
  ///       child: child,
  ///     ),
  /// )
  /// ```
  @experimental
  final PullDownMenuRouteBorderClipper? borderClipper;

  /// The pull-down menu shadow.
  ///
  /// If [boxShadow] is also specified, [boxShadow] takes precedence.
  final BoxShadow? shadow;

  /// A list of shadows cast by the pull-down menu container.
  ///
  /// If non-null, overrides [shadow].
  final List<BoxShadow>? boxShadow;

  /// A border to draw around the pull-down menu container.
  final BoxBorder? border;

  /// The width of pull-down menu.
  final double? width;

  /// The accessibility width of pull-down menu.
  ///
  /// The width of pull-down menu when `MediaQuery.of(context).textScaleFactor`
  /// is bigger than [ContentSizeCategory.extraExtraExtraLarge]. At this text
  /// scale factor menu transitions to its bigger size "accessibility" mode.
  final double? accessibilityWidth;

  /// Minimum width of the pull-down menu container.
  final double? minWidth;

  /// Maximum width of the pull-down menu container.
  final double? maxWidth;

  /// Maximum height of the pull-down menu container.
  final double? maxHeight;

  /// Additional constraints to apply to the pull-down menu container.
  final BoxConstraints? constraints;

  /// Inner padding inside the pull-down menu container surrounding the items.
  final EdgeInsetsGeometry? padding;

  /// Outer margin around the pull-down menu container.
  final EdgeInsetsGeometry? margin;

  /// The clipping behavior for the pull-down menu container.
  final Clip? clipBehavior;

  /// An optional builder to wrap, morph, or transform the menu container into
  /// custom widgets, inner navigation shells, or animated surfaces.
  final PullDownMenuContainerBuilder? containerBuilder;

  /// The color of the modal barrier behind the pull-down menu.
  final Color? barrierColor;

  /// Whether tapping the modal barrier dismisses the pull-down menu.
  final bool? barrierDismissible;

  /// The accessibility label for the modal barrier.
  final String? barrierLabel;

  /// Backdrop filter blur strength (sigma) for translucent menu backgrounds.
  ///
  /// Defaults to [BlurUtils.defaultBlurSigma].
  final double? backdropBlurSigma;

  /// Whether to enable backdrop blur filter on translucent menu backgrounds.
  ///
  /// If false, backdrop blur is completely disabled regardless of sigma.
  final bool? showBackdropFilter;

  /// Duration of the menu open animation.
  ///
  /// Defaults to [AnimationUtils.kMenuDuration].
  final Duration? openDuration;

  /// Duration of the menu close animation.
  ///
  /// Defaults to [AnimationUtils.kMenuDuration].
  final Duration? closeDuration;

  /// Duration of layout animations (for example on text scale changes).
  ///
  /// Defaults to [openDuration].
  final Duration? sizeChangeDuration;

  /// Curve of the menu open animation.
  ///
  /// Defaults to [AnimationUtils.kCurve].
  final Curve? openCurve;

  /// Curve of the menu close animation.
  ///
  /// Defaults to [AnimationUtils.kCurveReverse].
  final Curve? closeCurve;

  /// Minimum horizontal padding from screen edges when positioning the menu.
  ///
  /// Defaults to `8`.
  final double? menuScreenPadding;

  /// Resolves the list of box shadows, using [boxShadow] if non-null, or
  /// wrapping [shadow] in a list if non-null.
  List<BoxShadow>? get resolvedBoxShadow =>
      boxShadow ?? (shadow != null ? [shadow!] : null);

  /// The helper method to quickly resolve [PullDownMenuRouteTheme]'s width from
  /// [PullDownButtonTheme.routeTheme] or [PullDownMenuRouteTheme.defaults].
  ///
  /// Usually used to offset the menu position in [PullDownButton.menuOffset].
  static double resolvedWidthOf(BuildContext context) {
    final PullDownMenuRouteTheme routeTheme =
        PullDownButtonTheme.ambientOf(context).routeTheme;

    return ContentSizeCategory.isInAccessibilityMode(context)
        ? routeTheme.accessibilityWidth!
        : routeTheme.width!;
  }

  /// Creates a copy of this object with the given fields replaced with the
  /// new values.
  PullDownMenuRouteTheme copyWith({
    Color? backgroundColor,
    BorderRadius? borderRadius,
    BoxShadow? shadow,
    List<BoxShadow>? boxShadow,
    BoxBorder? border,
    double? width,
    double? accessibilityWidth,
    double? minWidth,
    double? maxWidth,
    double? maxHeight,
    BoxConstraints? constraints,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Clip? clipBehavior,
    PullDownMenuContainerBuilder? containerBuilder,
    Color? barrierColor,
    bool? barrierDismissible,
    String? barrierLabel,
    PullDownMenuRouteBorderClipper? borderClipper,
    double? backdropBlurSigma,
    bool? showBackdropFilter,
    Duration? openDuration,
    Duration? closeDuration,
    Duration? sizeChangeDuration,
    Curve? openCurve,
    Curve? closeCurve,
    double? menuScreenPadding,
  }) => PullDownMenuRouteTheme(
    backgroundColor: backgroundColor ?? this.backgroundColor,
    borderRadius: borderRadius ?? this.borderRadius,
    shadow: shadow ?? this.shadow,
    boxShadow: boxShadow ?? this.boxShadow,
    border: border ?? this.border,
    width: width ?? this.width,
    accessibilityWidth: accessibilityWidth ?? this.accessibilityWidth,
    minWidth: minWidth ?? this.minWidth,
    maxWidth: maxWidth ?? this.maxWidth,
    maxHeight: maxHeight ?? this.maxHeight,
    constraints: constraints ?? this.constraints,
    padding: padding ?? this.padding,
    margin: margin ?? this.margin,
    clipBehavior: clipBehavior ?? this.clipBehavior,
    containerBuilder: containerBuilder ?? this.containerBuilder,
    barrierColor: barrierColor ?? this.barrierColor,
    barrierDismissible: barrierDismissible ?? this.barrierDismissible,
    barrierLabel: barrierLabel ?? this.barrierLabel,
    borderClipper: borderClipper ?? this.borderClipper,
    backdropBlurSigma: backdropBlurSigma ?? this.backdropBlurSigma,
    showBackdropFilter: showBackdropFilter ?? this.showBackdropFilter,
    openDuration: openDuration ?? this.openDuration,
    closeDuration: closeDuration ?? this.closeDuration,
    sizeChangeDuration: sizeChangeDuration ?? this.sizeChangeDuration,
    openCurve: openCurve ?? this.openCurve,
    closeCurve: closeCurve ?? this.closeCurve,
    menuScreenPadding: menuScreenPadding ?? this.menuScreenPadding,
  );

  /// Linearly interpolate between two themes.
  static PullDownMenuRouteTheme lerp(
    PullDownMenuRouteTheme? a,
    PullDownMenuRouteTheme? b,
    double t,
  ) {
    if (identical(a, b) && a != null) {
      return a;
    }

    return PullDownMenuRouteTheme(
      backgroundColor: Color.lerp(a?.backgroundColor, b?.backgroundColor, t),
      borderRadius: BorderRadius.lerp(a?.borderRadius, b?.borderRadius, t),
      shadow: BoxShadow.lerp(a?.shadow, b?.shadow, t),
      boxShadow: BoxShadow.lerpList(a?.boxShadow, b?.boxShadow, t),
      border: BoxBorder.lerp(a?.border, b?.border, t),
      width: ui.lerpDouble(a?.width, b?.width, t),
      accessibilityWidth: ui.lerpDouble(
        a?.accessibilityWidth,
        b?.accessibilityWidth,
        t,
      ),
      minWidth: ui.lerpDouble(a?.minWidth, b?.minWidth, t),
      maxWidth: ui.lerpDouble(a?.maxWidth, b?.maxWidth, t),
      maxHeight: ui.lerpDouble(a?.maxHeight, b?.maxHeight, t),
      constraints: BoxConstraints.lerp(a?.constraints, b?.constraints, t),
      padding: EdgeInsetsGeometry.lerp(a?.padding, b?.padding, t),
      margin: EdgeInsetsGeometry.lerp(a?.margin, b?.margin, t),
      clipBehavior: t < 0.5 ? a?.clipBehavior : b?.clipBehavior,
      containerBuilder: t < 0.5 ? a?.containerBuilder : b?.containerBuilder,
      barrierColor: Color.lerp(a?.barrierColor, b?.barrierColor, t),
      barrierDismissible:
          t < 0.5 ? a?.barrierDismissible : b?.barrierDismissible,
      barrierLabel: t < 0.5 ? a?.barrierLabel : b?.barrierLabel,
      borderClipper: t < 0.5 ? a?.borderClipper : b?.borderClipper,
      backdropBlurSigma: ui.lerpDouble(
        a?.backdropBlurSigma,
        b?.backdropBlurSigma,
        t,
      ),
      showBackdropFilter:
          t < 0.5 ? a?.showBackdropFilter : b?.showBackdropFilter,
      openDuration: _lerpDuration(a?.openDuration, b?.openDuration, t),
      closeDuration: _lerpDuration(a?.closeDuration, b?.closeDuration, t),
      sizeChangeDuration: _lerpDuration(
        a?.sizeChangeDuration,
        b?.sizeChangeDuration,
        t,
      ),
      openCurve: t < 0.5 ? a?.openCurve : b?.openCurve,
      closeCurve: t < 0.5 ? a?.closeCurve : b?.closeCurve,
      menuScreenPadding: ui.lerpDouble(
        a?.menuScreenPadding,
        b?.menuScreenPadding,
        t,
      ),
    );
  }

  @override
  int get hashCode => Object.hashAll([
    backgroundColor,
    borderRadius,
    shadow,
    if (boxShadow != null) Object.hashAll(boxShadow!),
    border,
    width,
    accessibilityWidth,
    minWidth,
    maxWidth,
    maxHeight,
    constraints,
    padding,
    margin,
    clipBehavior,
    containerBuilder,
    barrierColor,
    barrierDismissible,
    barrierLabel,
    borderClipper,
    backdropBlurSigma,
    showBackdropFilter,
    openDuration,
    closeDuration,
    sizeChangeDuration,
    openCurve,
    closeCurve,
    menuScreenPadding,
  ]);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    return other is PullDownMenuRouteTheme &&
        other.backgroundColor == backgroundColor &&
        other.borderRadius == borderRadius &&
        other.shadow == shadow &&
        listEquals(other.boxShadow, boxShadow) &&
        other.border == border &&
        other.width == width &&
        other.accessibilityWidth == accessibilityWidth &&
        other.minWidth == minWidth &&
        other.maxWidth == maxWidth &&
        other.maxHeight == maxHeight &&
        other.constraints == constraints &&
        other.padding == padding &&
        other.margin == margin &&
        other.clipBehavior == clipBehavior &&
        other.containerBuilder == containerBuilder &&
        other.barrierColor == barrierColor &&
        other.barrierDismissible == barrierDismissible &&
        other.barrierLabel == barrierLabel &&
        other.borderClipper == borderClipper &&
        other.backdropBlurSigma == backdropBlurSigma &&
        other.showBackdropFilter == showBackdropFilter &&
        other.openDuration == openDuration &&
        other.closeDuration == closeDuration &&
        other.sizeChangeDuration == sizeChangeDuration &&
        other.openCurve == openCurve &&
        other.closeCurve == closeCurve &&
        other.menuScreenPadding == menuScreenPadding;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(
        ColorProperty('backgroundColor', backgroundColor, defaultValue: null),
      )
      ..add(
        DiagnosticsProperty('borderRadius', borderRadius, defaultValue: null),
      )
      ..add(DiagnosticsProperty('shadow', shadow, defaultValue: null))
      ..add(IterableProperty('boxShadow', boxShadow, defaultValue: null))
      ..add(DiagnosticsProperty('border', border, defaultValue: null))
      ..add(DoubleProperty('width', width, defaultValue: null))
      ..add(
        DoubleProperty(
          'accessibilityWidth',
          accessibilityWidth,
          defaultValue: null,
        ),
      )
      ..add(DoubleProperty('minWidth', minWidth, defaultValue: null))
      ..add(DoubleProperty('maxWidth', maxWidth, defaultValue: null))
      ..add(DoubleProperty('maxHeight', maxHeight, defaultValue: null))
      ..add(
        DiagnosticsProperty('constraints', constraints, defaultValue: null),
      )
      ..add(DiagnosticsProperty('padding', padding, defaultValue: null))
      ..add(DiagnosticsProperty('margin', margin, defaultValue: null))
      ..add(
        EnumProperty<Clip>('clipBehavior', clipBehavior, defaultValue: null),
      )
      ..add(
        ObjectFlagProperty<PullDownMenuContainerBuilder>.has(
          'containerBuilder',
          containerBuilder,
        ),
      )
      ..add(ColorProperty('barrierColor', barrierColor, defaultValue: null))
      ..add(
        DiagnosticsProperty(
          'barrierDismissible',
          barrierDismissible,
          defaultValue: null,
        ),
      )
      ..add(StringProperty('barrierLabel', barrierLabel, defaultValue: null))
      ..add(
        DiagnosticsProperty('borderClipper', borderClipper, defaultValue: null),
      )
      ..add(
        DoubleProperty(
          'backdropBlurSigma',
          backdropBlurSigma,
          defaultValue: null,
        ),
      )
      ..add(
        DiagnosticsProperty(
          'showBackdropFilter',
          showBackdropFilter,
          defaultValue: null,
        ),
      )
      ..add(
        DiagnosticsProperty('openDuration', openDuration, defaultValue: null),
      )
      ..add(
        DiagnosticsProperty('closeDuration', closeDuration, defaultValue: null),
      )
      ..add(
        DiagnosticsProperty(
          'sizeChangeDuration',
          sizeChangeDuration,
          defaultValue: null,
        ),
      )
      ..add(DiagnosticsProperty('openCurve', openCurve, defaultValue: null))
      ..add(DiagnosticsProperty('closeCurve', closeCurve, defaultValue: null))
      ..add(
        DoubleProperty(
          'menuScreenPadding',
          menuScreenPadding,
          defaultValue: null,
        ),
      );
  }
}

Duration? _lerpDuration(Duration? a, Duration? b, double t) {
  if (a == null && b == null) {
    return null;
  }
  return Duration(
    microseconds: ui.lerpDouble(
      (a ?? b)!.inMicroseconds.toDouble(),
      (b ?? a)!.inMicroseconds.toDouble(),
      t,
    )!.round(),
  );
}

/// A set of default values for [PullDownMenuRouteTheme].
@immutable
class _Defaults extends PullDownMenuRouteTheme {
  /// Creates [_Defaults].
  const _Defaults(this.context)
    : super(
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        borderClipper: _defaultBorderClipper,
        width: 250,
        accessibilityWidth: 370,
        shadow: const BoxShadow(
          color: Color.fromRGBO(0, 0, 0, 0.2),
          blurRadius: 32,
        ),
      );

  static ClipRRect _defaultBorderClipper(
    BorderRadius borderRadius,
    Widget child,
  ) => ClipRRect(
    borderRadius: borderRadius,
    child: child,
  );

  /// A build context used to resolve [CupertinoDynamicColor]s defined in this
  /// theme.
  final BuildContext context;

  /// The light and dark color of the menu's background.
  static const kBackgroundColor = SimpleDynamicColor(
    color: Color.fromRGBO(247, 247, 247, 0.8),
    darkColor: Color.fromRGBO(36, 36, 36, 0.75),
  );

  @override
  Color get backgroundColor => kBackgroundColor.resolveFrom(context);

  @override
  double get backdropBlurSigma => BlurUtils.defaultBlurSigma;

  @override
  bool get showBackdropFilter => true;

  @override
  Duration get openDuration => AnimationUtils.kMenuDuration;

  @override
  Duration get closeDuration => AnimationUtils.kMenuDuration;

  @override
  Duration get sizeChangeDuration => AnimationUtils.kMenuDuration;

  @override
  Curve get openCurve => AnimationUtils.kCurve;

  @override
  Curve get closeCurve => AnimationUtils.kCurveReverse;

  @override
  double get menuScreenPadding => 8;
}
