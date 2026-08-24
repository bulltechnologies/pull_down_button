/// @docImport '/pull_down_button.dart';
/// @docImport '/src/items/divider.dart';
library;

import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

import '_dynamic_color.dart';
import 'theme.dart';

/// Defines the visual properties of the dividers in pull-down menus.
///
/// Is used by [PullDownMenuDivider] and [PullDownMenuSeparator].
///
/// Typically a [PullDownMenuDividerTheme] is specified as part of the overall
/// [PullDownButtonTheme] with [PullDownButtonTheme.dividerTheme].
///
/// All [PullDownMenuDividerTheme] properties are `null` by default. When null,
/// defined earlier use cases will use the values from [PullDownButtonTheme]
/// if they exist, otherwise it will use iOS 18 defaults specified in
/// [PullDownMenuDividerTheme.defaults].
@immutable
final class PullDownMenuDividerTheme with Diagnosticable {
  /// Creates the set of properties used to configure
  /// [PullDownMenuDividerTheme].
  const PullDownMenuDividerTheme({
    this.dividerColor,
    this.largeDividerColor,
    this.color,
    this.separatorThickness,
    this.dividerThickness,
    this.separatorHeight,
    this.dividerHeight,
    this.indent,
    this.endIndent,
    this.margin,
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
  const factory PullDownMenuDividerTheme.defaults(BuildContext context) =
      _Defaults;

  /// The color of the [PullDownMenuSeparator].
  final Color? dividerColor;

  /// The color of the [PullDownMenuDivider].
  final Color? largeDividerColor;

  /// General color override for dividers.
  final Color? color;

  /// Thickness of [PullDownMenuSeparator] lines.
  ///
  /// Defaults to `0.5`.
  final double? separatorThickness;

  /// Thickness (height) of [PullDownMenuDivider].
  ///
  /// Defaults to `8`.
  final double? dividerThickness;

  /// Layout height of [PullDownMenuSeparator].
  ///
  /// Defaults to [separatorThickness].
  final double? separatorHeight;

  /// Layout height of [PullDownMenuDivider].
  ///
  /// Defaults to [dividerThickness].
  final double? dividerHeight;

  /// The leading spacing for [PullDownMenuDivider].
  final double? indent;

  /// The trailing spacing for [PullDownMenuDivider].
  final double? endIndent;

  /// Outer margin surrounding the divider.
  final EdgeInsetsGeometry? margin;

  /// Creates a copy of this object with the given fields replaced with the
  /// new values.
  PullDownMenuDividerTheme copyWith({
    Color? dividerColor,
    Color? largeDividerColor,
    Color? color,
    double? separatorThickness,
    double? dividerThickness,
    double? separatorHeight,
    double? dividerHeight,
    double? indent,
    double? endIndent,
    EdgeInsetsGeometry? margin,
  }) => PullDownMenuDividerTheme(
    dividerColor: dividerColor ?? this.dividerColor,
    largeDividerColor: largeDividerColor ?? this.largeDividerColor,
    color: color ?? this.color,
    separatorThickness: separatorThickness ?? this.separatorThickness,
    dividerThickness: dividerThickness ?? this.dividerThickness,
    separatorHeight: separatorHeight ?? this.separatorHeight,
    dividerHeight: dividerHeight ?? this.dividerHeight,
    indent: indent ?? this.indent,
    endIndent: endIndent ?? this.endIndent,
    margin: margin ?? this.margin,
  );

  /// Linearly interpolate between two themes.
  static PullDownMenuDividerTheme lerp(
    PullDownMenuDividerTheme? a,
    PullDownMenuDividerTheme? b,
    double t,
  ) {
    if (identical(a, b) && a != null) {
      return a;
    }

    return PullDownMenuDividerTheme(
      dividerColor: Color.lerp(a?.dividerColor, b?.dividerColor, t),
      largeDividerColor: Color.lerp(
        a?.largeDividerColor,
        b?.largeDividerColor,
        t,
      ),
      color: Color.lerp(a?.color, b?.color, t),
      separatorThickness: ui.lerpDouble(
        a?.separatorThickness,
        b?.separatorThickness,
        t,
      ),
      dividerThickness: ui.lerpDouble(
        a?.dividerThickness,
        b?.dividerThickness,
        t,
      ),
      separatorHeight: ui.lerpDouble(
        a?.separatorHeight,
        b?.separatorHeight,
        t,
      ),
      dividerHeight: ui.lerpDouble(a?.dividerHeight, b?.dividerHeight, t),
      indent: ui.lerpDouble(a?.indent, b?.indent, t),
      endIndent: ui.lerpDouble(a?.endIndent, b?.endIndent, t),
      margin: EdgeInsetsGeometry.lerp(a?.margin, b?.margin, t),
    );
  }

  @override
  int get hashCode => Object.hashAll([
    dividerColor,
    largeDividerColor,
    color,
    separatorThickness,
    dividerThickness,
    separatorHeight,
    dividerHeight,
    indent,
    endIndent,
    margin,
  ]);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    return other is PullDownMenuDividerTheme &&
        other.dividerColor == dividerColor &&
        other.largeDividerColor == largeDividerColor &&
        other.color == color &&
        other.separatorThickness == separatorThickness &&
        other.dividerThickness == dividerThickness &&
        other.separatorHeight == separatorHeight &&
        other.dividerHeight == dividerHeight &&
        other.indent == indent &&
        other.endIndent == endIndent &&
        other.margin == margin;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(ColorProperty('dividerColor', dividerColor, defaultValue: null))
      ..add(
        ColorProperty(
          'largeDividerColor',
          largeDividerColor,
          defaultValue: null,
        ),
      )
      ..add(ColorProperty('color', color, defaultValue: null))
      ..add(
        DoubleProperty(
          'separatorThickness',
          separatorThickness,
          defaultValue: null,
        ),
      )
      ..add(
        DoubleProperty(
          'dividerThickness',
          dividerThickness,
          defaultValue: null,
        ),
      )
      ..add(
        DoubleProperty(
          'separatorHeight',
          separatorHeight,
          defaultValue: null,
        ),
      )
      ..add(DoubleProperty('dividerHeight', dividerHeight, defaultValue: null))
      ..add(DoubleProperty('indent', indent, defaultValue: null))
      ..add(DoubleProperty('endIndent', endIndent, defaultValue: null))
      ..add(DiagnosticsProperty('margin', margin, defaultValue: null));
  }
}

/// A set of default values for [PullDownMenuDividerTheme].
@immutable
final class _Defaults extends PullDownMenuDividerTheme {
  /// Creates [_Defaults].
  const _Defaults(this.context);

  /// A build context used to resolve [SimpleDynamicColor]s defined in this
  /// theme.
  final BuildContext context;

  /// The light and dark colors of the [PullDownMenuSeparator].
  static const kDividerColor = SimpleDynamicColor(
    color: Color.fromRGBO(128, 128, 128, 0.55),
    darkColor: Color.fromRGBO(128, 128, 128, 0.7),
  );

  /// The light and dark colors of the [PullDownMenuDivider].
  static const kLargeDividerColor = SimpleDynamicColor(
    color: Color.fromRGBO(0, 0, 0, 0.08),
    darkColor: Color.fromRGBO(0, 0, 0, 0.16),
  );

  @override
  Color get dividerColor => kDividerColor.resolveFrom(context);

  @override
  Color get largeDividerColor => kLargeDividerColor.resolveFrom(context);

  @override
  double get separatorThickness => 0.5;

  @override
  double get dividerThickness => 8;

  @override
  double get separatorHeight => separatorThickness;

  @override
  double get dividerHeight => dividerThickness;
}
