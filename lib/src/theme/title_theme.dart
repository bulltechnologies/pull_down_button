/// @docImport '/pull_down_button.dart';
/// @docImport '/src/items/title.dart';
library;

import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

import '_dynamic_color.dart';
import '_fonts.dart';

/// Defines the visual properties of the titles in pull-down menus.
///
/// Is used by [PullDownMenuTitle].
///
/// Typically a [PullDownMenuTitleTheme] is specified as part of the overall
/// [PullDownButtonTheme] with [PullDownButtonTheme.titleTheme].
///
/// All [PullDownMenuTitleTheme] properties are `null` by default. When null,
/// defined earlier use cases will use the values from [PullDownButtonTheme]
/// if they exist, otherwise it will use iOS 18 defaults specified in
/// [PullDownMenuTitleTheme.defaults].
@immutable
class PullDownMenuTitleTheme with Diagnosticable {
  /// Creates the set of properties used to configure [PullDownMenuTitleTheme].
  const PullDownMenuTitleTheme({
    this.style,
    this.color,
    this.padding,
    this.margin,
    this.startPaddingWithLeading,
    this.startPadding,
    this.verticalPadding,
    this.endPadding,
    this.titleSubtitleGap,
  });

  /// Creates default set of properties used to configure
  /// [PullDownMenuTitleTheme].
  ///
  /// Default properties were taken from the Apple Design Resources Sketch and
  /// Figma libraries for iOS 18 and iPadOS 18.
  ///
  /// See also:
  ///
  /// * Apple Design Resources Sketch and Figma [libraries](https://developer.apple.com/design/resources/)
  @internal
  const factory PullDownMenuTitleTheme.defaults(BuildContext context) =
      _Defaults;

  /// The text style of title in the pull-down menu.
  final TextStyle? style;

  /// The color of the title text.
  ///
  /// Merged into [style] when resolved.
  final Color? color;

  /// Padding of [PullDownMenuTitle].
  ///
  /// If null, [startPadding], [verticalPadding], and [endPadding] are used.
  final EdgeInsetsDirectional? padding;

  /// Margin of [PullDownMenuTitle].
  final EdgeInsetsGeometry? margin;

  /// Start padding when the menu has selectable leading items.
  final double? startPaddingWithLeading;

  /// Start padding when the menu has no leading items.
  final double? startPadding;

  /// Top and bottom padding of [PullDownMenuTitle].
  final double? verticalPadding;

  /// End padding of [PullDownMenuTitle].
  final double? endPadding;

  /// Gap between title and subtitle if subtitle is present.
  final double? titleSubtitleGap;

  /// Creates a copy of this object with the given fields replaced with the
  /// new values.
  PullDownMenuTitleTheme copyWith({
    TextStyle? style,
    Color? color,
    EdgeInsetsDirectional? padding,
    EdgeInsetsGeometry? margin,
    double? startPaddingWithLeading,
    double? startPadding,
    double? verticalPadding,
    double? endPadding,
    double? titleSubtitleGap,
  }) => PullDownMenuTitleTheme(
    style: style ?? this.style,
    color: color ?? this.color,
    padding: padding ?? this.padding,
    margin: margin ?? this.margin,
    startPaddingWithLeading:
        startPaddingWithLeading ?? this.startPaddingWithLeading,
    startPadding: startPadding ?? this.startPadding,
    verticalPadding: verticalPadding ?? this.verticalPadding,
    endPadding: endPadding ?? this.endPadding,
    titleSubtitleGap: titleSubtitleGap ?? this.titleSubtitleGap,
  );

  /// Linearly interpolate between two themes.
  static PullDownMenuTitleTheme lerp(
    PullDownMenuTitleTheme? a,
    PullDownMenuTitleTheme? b,
    double t,
  ) {
    if (identical(a, b) && a != null) {
      return a;
    }

    return PullDownMenuTitleTheme(
      style: TextStyle.lerp(a?.style, b?.style, t),
      color: Color.lerp(a?.color, b?.color, t),
      padding: EdgeInsetsDirectional.lerp(a?.padding, b?.padding, t),
      margin: EdgeInsetsGeometry.lerp(a?.margin, b?.margin, t),
      startPaddingWithLeading: ui.lerpDouble(
        a?.startPaddingWithLeading,
        b?.startPaddingWithLeading,
        t,
      ),
      startPadding: ui.lerpDouble(a?.startPadding, b?.startPadding, t),
      verticalPadding: ui.lerpDouble(a?.verticalPadding, b?.verticalPadding, t),
      endPadding: ui.lerpDouble(a?.endPadding, b?.endPadding, t),
      titleSubtitleGap: ui.lerpDouble(
        a?.titleSubtitleGap,
        b?.titleSubtitleGap,
        t,
      ),
    );
  }

  @override
  int get hashCode => Object.hashAll([
    style,
    color,
    padding,
    margin,
    startPaddingWithLeading,
    startPadding,
    verticalPadding,
    endPadding,
    titleSubtitleGap,
  ]);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    return other is PullDownMenuTitleTheme &&
        other.style == style &&
        other.color == color &&
        other.padding == padding &&
        other.margin == margin &&
        other.startPaddingWithLeading == startPaddingWithLeading &&
        other.startPadding == startPadding &&
        other.verticalPadding == verticalPadding &&
        other.endPadding == endPadding &&
        other.titleSubtitleGap == titleSubtitleGap;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('style', style, defaultValue: null))
      ..add(ColorProperty('color', color, defaultValue: null))
      ..add(DiagnosticsProperty('padding', padding, defaultValue: null))
      ..add(DiagnosticsProperty('margin', margin, defaultValue: null))
      ..add(
        DoubleProperty(
          'startPaddingWithLeading',
          startPaddingWithLeading,
          defaultValue: null,
        ),
      )
      ..add(DoubleProperty('startPadding', startPadding, defaultValue: null))
      ..add(
        DoubleProperty('verticalPadding', verticalPadding, defaultValue: null),
      )
      ..add(DoubleProperty('endPadding', endPadding, defaultValue: null))
      ..add(
        DoubleProperty('titleSubtitleGap', titleSubtitleGap, defaultValue: null),
      );
  }
}

/// A set of default values for [PullDownMenuTitleTheme].
@immutable
class _Defaults extends PullDownMenuTitleTheme {
  /// Creates [_Defaults].
  const _Defaults(this.context);

  /// A build context used to resolve [SimpleDynamicColor]s defined in this
  /// theme.
  final BuildContext context;

  /// The light and dark colors of [PullDownMenuTitleTheme.style].
  static const kTitleColor = SimpleDynamicColor(
    color: Color.fromRGBO(60, 60, 67, 0.6),
    darkColor: Color.fromRGBO(235, 235, 245, 0.6),
  );

  /// The [PullDownMenuTitleTheme.style] before applying [kTitleColor].
  static const kStyle = TextStyle(
    inherit: false,
    fontFamily: kPullDownMenuEntryFontFamily,
    fontFamilyFallback: kPullDownMenuEntryFontFallbacks,
    fontSize: 12,
    height: 16 / 12,
    fontWeight: FontWeight.w400,
    textBaseline: TextBaseline.alphabetic,
    letterSpacing: 1,
    fontStyle: FontStyle.normal,
    decoration: TextDecoration.none,
  );

  @override
  TextStyle get style => kStyle.copyWith(
    color: kTitleColor.resolveFrom(context),
  );

  @override
  Color get color => kTitleColor.resolveFrom(context);

  @override
  double get startPaddingWithLeading => 9;

  @override
  double get startPadding => 16;

  @override
  double get verticalPadding => 8;

  @override
  double get endPadding => 16;

  @override
  double get titleSubtitleGap => 0;
}
