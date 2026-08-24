/// @docImport '/pull_down_button.dart';
library;

import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

import '_dynamic_color.dart';
import '_fonts.dart';

/// Placement of the optional [PullDownMenuItem] icon relative to the title.
enum PullDownMenuItemIconAlignment {
  /// Icon is placed on the trailing side (default iOS layout).
  trailing,

  /// Icon is placed after any leading widget (checkmark) and before the title.
  leading,
}

/// Defines the visual properties of the items in pull-down menus.
///
/// Is used by [PullDownMenuItem], [PullDownMenuItem.selectable] and
/// [PullDownMenuHeader].
///
/// Typically a [PullDownMenuItemTheme] is specified as part of the overall
/// [PullDownMenuItemTheme] with [PullDownButtonTheme.itemTheme].
///
/// All [PullDownMenuItemTheme] properties are `null` by default. When null,
/// defined earlier use cases will use the values from [PullDownButtonTheme]
/// if they exist, otherwise it will use iOS 18 defaults specified in
/// [PullDownMenuItemTheme.defaults].
@immutable
class PullDownMenuItemTheme with Diagnosticable {
  /// Creates the set of properties used to configure [PullDownMenuItemTheme].
  const PullDownMenuItemTheme({
    this.destructiveColor,
    this.checkmark,
    this.textStyle,
    this.subtitleStyle,
    this.iconActionTextStyle,
    this.trailingTextStyle,
    this.trailingColor,
    this.backgroundColor,
    this.onHoverBackgroundColor,
    this.onPressedBackgroundColor,
    this.onHoverTextColor,
    this.onPressedTextColor,
    this.titleColor,
    this.subtitleColor,
    this.iconColor,
    this.iconBackgroundColor,
    this.iconBorderRadius,
    this.iconPadding,
    this.iconSize,
    this.iconAlignment,
    this.disabledOpacity,
    this.itemBorderRadius,
    this.border,
    this.margin,
    this.padding,
    this.headerPadding,
    this.actionsRowPadding,
    this.titleSubtitleGap,
    this.iconSpacing,
    this.leadingWidth,
    this.leadingSpacing,
    this.checkmarkSize,
    this.showLeading,
    this.mouseCursor,
    this.minHeight,
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
  const factory PullDownMenuItemTheme.defaults(BuildContext context) =
      _Defaults;

  /// The destructive color of items in the pull-down menu.
  ///
  /// [destructiveColor] will be applied to [textStyle] and
  /// [iconActionTextStyle].
  final Color? destructiveColor;

  /// The selection icon for selected [PullDownMenuItem.selectable].
  ///
  /// These value is ignored for [PullDownMenuItem].
  final IconData? checkmark;

  /// The text style of item's titles in the pull-down menu.
  ///
  /// These value is ignored for [PullDownMenuItem]s inside
  /// [PullDownMenuActionsRow].
  final TextStyle? textStyle;

  /// The text style of item's subtitles in the pull-down menu.
  ///
  /// These value is ignored for [PullDownMenuItem]s inside
  /// [PullDownMenuActionsRow].
  final TextStyle? subtitleStyle;

  /// The text style of [PullDownMenuItem] items inside
  /// [PullDownMenuActionsRow] in the pull-down menu.
  ///
  /// These value is ignored for any other [PullDownMenuItem] and
  /// [PullDownMenuItem.selectable].
  final TextStyle? iconActionTextStyle;

  /// The text style for trailing text or shortcut hints in menu items.
  final TextStyle? trailingTextStyle;

  /// The color of trailing text or shortcut hints in menu items.
  ///
  /// Merged into [trailingTextStyle] when resolved.
  final Color? trailingColor;

  /// The default idle background color of [PullDownMenuItem].
  final Color? backgroundColor;

  /// The background color of [PullDownMenuItem] during hover interaction.
  final Color? onHoverBackgroundColor;

  /// The background color of [PullDownMenuItem] during press interaction.
  final Color? onPressedBackgroundColor;

  /// The text color of [PullDownMenuItem] during hover interaction.
  ///
  /// [onHoverTextColor] will be applied to [textStyle] and
  /// [iconActionTextStyle].
  final Color? onHoverTextColor;

  /// The text color of [PullDownMenuItem] during press interaction.
  ///
  /// If null, [textStyle] color is used.
  final Color? onPressedTextColor;

  /// The default color of item titles.
  ///
  /// Merged into [textStyle] when resolved.
  final Color? titleColor;

  /// The default color of item subtitles.
  ///
  /// Merged into [subtitleStyle] when resolved.
  final Color? subtitleColor;

  /// The default color of item icons when [PullDownMenuItem.iconColor] is null.
  final Color? iconColor;

  /// Optional background color for the icon's container.
  final Color? iconBackgroundColor;

  /// Optional border radius for the icon's container.
  final BorderRadius? iconBorderRadius;

  /// Optional inner padding for the icon's container.
  final EdgeInsetsGeometry? iconPadding;

  /// Custom icon size for menu items.
  final double? iconSize;

  /// Placement of the optional item icon for large [PullDownMenuItem]s.
  ///
  /// Defaults to [PullDownMenuItemIconAlignment.trailing].
  final PullDownMenuItemIconAlignment? iconAlignment;

  /// Opacity applied to disabled menu items.
  ///
  /// If null, a platform brightness–aware default is used.
  final double? disabledOpacity;

  /// Border radius of individual menu item highlight backgrounds.
  final BorderRadius? itemBorderRadius;

  /// Optional border for individual menu items.
  final BoxBorder? border;

  /// Outer margin surrounding each menu item inside the menu body.
  final EdgeInsetsGeometry? margin;

  /// Padding of large [PullDownMenuItem]s and [PullDownMenuItem.selectable]s.
  final EdgeInsetsDirectional? padding;

  /// Padding of [PullDownMenuHeader].
  final EdgeInsetsDirectional? headerPadding;

  /// Padding of icon-only and icon+title items in [PullDownMenuActionsRow].
  final EdgeInsetsGeometry? actionsRowPadding;

  /// Vertical gap between title and subtitle in large items and headers.
  final double? titleSubtitleGap;

  /// Horizontal gap between the icon and title in large items and headers.
  final double? iconSpacing;

  /// Width of the leading checkmark column.
  final double? leadingWidth;

  /// Spacing after the leading checkmark column.
  final double? leadingSpacing;

  /// Font size of the selection checkmark.
  final double? checkmarkSize;

  /// Whether to reserve and display the leading checkmark column on items.
  ///
  /// If explicitly set to `false`, non-selectable items will not reserve blank
  /// leading space even if sibling items in the menu are selectable.
  final bool? showLeading;

  /// The mouse cursor for interactive menu items.
  final MouseCursor? mouseCursor;

  /// Minimum height constraint for large menu items.
  final double? minHeight;

  /// Creates a copy of this object with the given fields replaced with the
  /// new values.
  PullDownMenuItemTheme copyWith({
    Color? destructiveColor,
    IconData? checkmark,
    TextStyle? textStyle,
    TextStyle? subtitleStyle,
    TextStyle? iconActionTextStyle,
    TextStyle? trailingTextStyle,
    Color? trailingColor,
    Color? backgroundColor,
    Color? onHoverBackgroundColor,
    Color? onPressedBackgroundColor,
    Color? onHoverTextColor,
    Color? onPressedTextColor,
    Color? titleColor,
    Color? subtitleColor,
    Color? iconColor,
    Color? iconBackgroundColor,
    BorderRadius? iconBorderRadius,
    EdgeInsetsGeometry? iconPadding,
    double? iconSize,
    PullDownMenuItemIconAlignment? iconAlignment,
    double? disabledOpacity,
    BorderRadius? itemBorderRadius,
    BoxBorder? border,
    EdgeInsetsGeometry? margin,
    EdgeInsetsDirectional? padding,
    EdgeInsetsDirectional? headerPadding,
    EdgeInsetsGeometry? actionsRowPadding,
    double? titleSubtitleGap,
    double? iconSpacing,
    double? leadingWidth,
    double? leadingSpacing,
    double? checkmarkSize,
    bool? showLeading,
    MouseCursor? mouseCursor,
    double? minHeight,
  }) => PullDownMenuItemTheme(
    destructiveColor: destructiveColor ?? this.destructiveColor,
    checkmark: checkmark ?? this.checkmark,
    textStyle: textStyle ?? this.textStyle,
    subtitleStyle: subtitleStyle ?? this.subtitleStyle,
    iconActionTextStyle: iconActionTextStyle ?? this.iconActionTextStyle,
    trailingTextStyle: trailingTextStyle ?? this.trailingTextStyle,
    trailingColor: trailingColor ?? this.trailingColor,
    backgroundColor: backgroundColor ?? this.backgroundColor,
    onHoverBackgroundColor:
        onHoverBackgroundColor ?? this.onHoverBackgroundColor,
    onPressedBackgroundColor:
        onPressedBackgroundColor ?? this.onPressedBackgroundColor,
    onHoverTextColor: onHoverTextColor ?? this.onHoverTextColor,
    onPressedTextColor: onPressedTextColor ?? this.onPressedTextColor,
    titleColor: titleColor ?? this.titleColor,
    subtitleColor: subtitleColor ?? this.subtitleColor,
    iconColor: iconColor ?? this.iconColor,
    iconBackgroundColor: iconBackgroundColor ?? this.iconBackgroundColor,
    iconBorderRadius: iconBorderRadius ?? this.iconBorderRadius,
    iconPadding: iconPadding ?? this.iconPadding,
    iconSize: iconSize ?? this.iconSize,
    iconAlignment: iconAlignment ?? this.iconAlignment,
    disabledOpacity: disabledOpacity ?? this.disabledOpacity,
    itemBorderRadius: itemBorderRadius ?? this.itemBorderRadius,
    border: border ?? this.border,
    margin: margin ?? this.margin,
    padding: padding ?? this.padding,
    headerPadding: headerPadding ?? this.headerPadding,
    actionsRowPadding: actionsRowPadding ?? this.actionsRowPadding,
    titleSubtitleGap: titleSubtitleGap ?? this.titleSubtitleGap,
    iconSpacing: iconSpacing ?? this.iconSpacing,
    leadingWidth: leadingWidth ?? this.leadingWidth,
    leadingSpacing: leadingSpacing ?? this.leadingSpacing,
    checkmarkSize: checkmarkSize ?? this.checkmarkSize,
    showLeading: showLeading ?? this.showLeading,
    mouseCursor: mouseCursor ?? this.mouseCursor,
    minHeight: minHeight ?? this.minHeight,
  );

  /// Linearly interpolate between two themes.
  static PullDownMenuItemTheme lerp(
    PullDownMenuItemTheme? a,
    PullDownMenuItemTheme? b,
    double t,
  ) {
    if (identical(a, b) && a != null) {
      return a;
    }

    return PullDownMenuItemTheme(
      destructiveColor: Color.lerp(a?.destructiveColor, b?.destructiveColor, t),
      checkmark: _lerpIconData(a?.checkmark, b?.checkmark, t),
      textStyle: TextStyle.lerp(a?.textStyle, b?.textStyle, t),
      subtitleStyle: TextStyle.lerp(a?.subtitleStyle, b?.subtitleStyle, t),
      iconActionTextStyle: TextStyle.lerp(
        a?.iconActionTextStyle,
        b?.iconActionTextStyle,
        t,
      ),
      trailingTextStyle: TextStyle.lerp(
        a?.trailingTextStyle,
        b?.trailingTextStyle,
        t,
      ),
      trailingColor: Color.lerp(a?.trailingColor, b?.trailingColor, t),
      backgroundColor: Color.lerp(a?.backgroundColor, b?.backgroundColor, t),
      onHoverBackgroundColor: Color.lerp(
        a?.onHoverBackgroundColor,
        b?.onHoverBackgroundColor,
        t,
      ),
      onPressedBackgroundColor: Color.lerp(
        a?.onPressedBackgroundColor,
        b?.onPressedBackgroundColor,
        t,
      ),
      onHoverTextColor: Color.lerp(a?.onHoverTextColor, b?.onHoverTextColor, t),
      onPressedTextColor: Color.lerp(
        a?.onPressedTextColor,
        b?.onPressedTextColor,
        t,
      ),
      titleColor: Color.lerp(a?.titleColor, b?.titleColor, t),
      subtitleColor: Color.lerp(a?.subtitleColor, b?.subtitleColor, t),
      iconColor: Color.lerp(a?.iconColor, b?.iconColor, t),
      iconBackgroundColor: Color.lerp(
        a?.iconBackgroundColor,
        b?.iconBackgroundColor,
        t,
      ),
      iconBorderRadius: BorderRadius.lerp(
        a?.iconBorderRadius,
        b?.iconBorderRadius,
        t,
      ),
      iconPadding: EdgeInsetsGeometry.lerp(
        a?.iconPadding,
        b?.iconPadding,
        t,
      ),
      iconSize: ui.lerpDouble(a?.iconSize, b?.iconSize, t),
      iconAlignment: t < 0.5 ? a?.iconAlignment : b?.iconAlignment,
      disabledOpacity: ui.lerpDouble(a?.disabledOpacity, b?.disabledOpacity, t),
      itemBorderRadius: BorderRadius.lerp(
        a?.itemBorderRadius,
        b?.itemBorderRadius,
        t,
      ),
      border: BoxBorder.lerp(a?.border, b?.border, t),
      margin: EdgeInsetsGeometry.lerp(a?.margin, b?.margin, t),
      padding: _lerpEdgeInsetsDirectional(a?.padding, b?.padding, t),
      headerPadding: _lerpEdgeInsetsDirectional(
        a?.headerPadding,
        b?.headerPadding,
        t,
      ),
      actionsRowPadding: EdgeInsetsGeometry.lerp(
        a?.actionsRowPadding,
        b?.actionsRowPadding,
        t,
      ),
      titleSubtitleGap: ui.lerpDouble(
        a?.titleSubtitleGap,
        b?.titleSubtitleGap,
        t,
      ),
      iconSpacing: ui.lerpDouble(a?.iconSpacing, b?.iconSpacing, t),
      leadingWidth: ui.lerpDouble(a?.leadingWidth, b?.leadingWidth, t),
      leadingSpacing: ui.lerpDouble(a?.leadingSpacing, b?.leadingSpacing, t),
      checkmarkSize: ui.lerpDouble(a?.checkmarkSize, b?.checkmarkSize, t),
      showLeading: t < 0.5 ? a?.showLeading : b?.showLeading,
      mouseCursor: t < 0.5 ? a?.mouseCursor : b?.mouseCursor,
      minHeight: ui.lerpDouble(a?.minHeight, b?.minHeight, t),
    );
  }

  @override
  int get hashCode => Object.hashAll([
    destructiveColor,
    checkmark,
    textStyle,
    subtitleStyle,
    iconActionTextStyle,
    trailingTextStyle,
    trailingColor,
    backgroundColor,
    onHoverBackgroundColor,
    onPressedBackgroundColor,
    onHoverTextColor,
    onPressedTextColor,
    titleColor,
    subtitleColor,
    iconColor,
    iconBackgroundColor,
    iconBorderRadius,
    iconPadding,
    iconSize,
    iconAlignment,
    disabledOpacity,
    itemBorderRadius,
    border,
    margin,
    padding,
    headerPadding,
    actionsRowPadding,
    titleSubtitleGap,
    iconSpacing,
    leadingWidth,
    leadingSpacing,
    checkmarkSize,
    showLeading,
    mouseCursor,
    minHeight,
  ]);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    return other is PullDownMenuItemTheme &&
        other.destructiveColor == destructiveColor &&
        other.checkmark == checkmark &&
        other.textStyle == textStyle &&
        other.subtitleStyle == subtitleStyle &&
        other.iconActionTextStyle == iconActionTextStyle &&
        other.trailingTextStyle == trailingTextStyle &&
        other.trailingColor == trailingColor &&
        other.backgroundColor == backgroundColor &&
        other.onHoverBackgroundColor == onHoverBackgroundColor &&
        other.onPressedBackgroundColor == onPressedBackgroundColor &&
        other.onHoverTextColor == onHoverTextColor &&
        other.onPressedTextColor == onPressedTextColor &&
        other.titleColor == titleColor &&
        other.subtitleColor == subtitleColor &&
        other.iconColor == iconColor &&
        other.iconBackgroundColor == iconBackgroundColor &&
        other.iconBorderRadius == iconBorderRadius &&
        other.iconPadding == iconPadding &&
        other.iconSize == iconSize &&
        other.iconAlignment == iconAlignment &&
        other.disabledOpacity == disabledOpacity &&
        other.itemBorderRadius == itemBorderRadius &&
        other.border == border &&
        other.margin == margin &&
        other.padding == padding &&
        other.headerPadding == headerPadding &&
        other.actionsRowPadding == actionsRowPadding &&
        other.titleSubtitleGap == titleSubtitleGap &&
        other.iconSpacing == iconSpacing &&
        other.leadingWidth == leadingWidth &&
        other.leadingSpacing == leadingSpacing &&
        other.checkmarkSize == checkmarkSize &&
        other.showLeading == showLeading &&
        other.mouseCursor == mouseCursor &&
        other.minHeight == minHeight;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(
        ColorProperty(
          'destructiveColor',
          destructiveColor,
          defaultValue: destructiveColor,
        ),
      )
      ..add(
        DiagnosticsProperty('checkmark', checkmark, defaultValue: null),
      )
      ..add(
        DiagnosticsProperty('textStyle', textStyle, defaultValue: null),
      )
      ..add(
        DiagnosticsProperty('subtitleStyle', subtitleStyle, defaultValue: null),
      )
      ..add(
        DiagnosticsProperty(
          'iconActionTextStyle',
          iconActionTextStyle,
          defaultValue: null,
        ),
      )
      ..add(
        DiagnosticsProperty(
          'trailingTextStyle',
          trailingTextStyle,
          defaultValue: null,
        ),
      )
      ..add(ColorProperty('trailingColor', trailingColor, defaultValue: null))
      ..add(
        ColorProperty('backgroundColor', backgroundColor, defaultValue: null),
      )
      ..add(
        ColorProperty(
          'onHoverBackgroundColor',
          onHoverBackgroundColor,
          defaultValue: null,
        ),
      )
      ..add(
        ColorProperty(
          'onPressedBackgroundColor',
          onPressedBackgroundColor,
          defaultValue: null,
        ),
      )
      ..add(
        ColorProperty('onHoverTextColor', onHoverTextColor, defaultValue: null),
      )
      ..add(
        ColorProperty(
          'onPressedTextColor',
          onPressedTextColor,
          defaultValue: null,
        ),
      )
      ..add(ColorProperty('titleColor', titleColor, defaultValue: null))
      ..add(ColorProperty('subtitleColor', subtitleColor, defaultValue: null))
      ..add(ColorProperty('iconColor', iconColor, defaultValue: null))
      ..add(
        ColorProperty(
          'iconBackgroundColor',
          iconBackgroundColor,
          defaultValue: null,
        ),
      )
      ..add(
        DiagnosticsProperty(
          'iconBorderRadius',
          iconBorderRadius,
          defaultValue: null,
        ),
      )
      ..add(
        DiagnosticsProperty('iconPadding', iconPadding, defaultValue: null),
      )
      ..add(DoubleProperty('iconSize', iconSize, defaultValue: null))
      ..add(
        EnumProperty(
          'iconAlignment',
          iconAlignment,
          defaultValue: null,
        ),
      )
      ..add(
        DoubleProperty('disabledOpacity', disabledOpacity, defaultValue: null),
      )
      ..add(
        DiagnosticsProperty(
          'itemBorderRadius',
          itemBorderRadius,
          defaultValue: null,
        ),
      )
      ..add(DiagnosticsProperty('border', border, defaultValue: null))
      ..add(DiagnosticsProperty('margin', margin, defaultValue: null))
      ..add(DiagnosticsProperty('padding', padding, defaultValue: null))
      ..add(
        DiagnosticsProperty('headerPadding', headerPadding, defaultValue: null),
      )
      ..add(
        DiagnosticsProperty(
          'actionsRowPadding',
          actionsRowPadding,
          defaultValue: null,
        ),
      )
      ..add(
        DoubleProperty(
          'titleSubtitleGap',
          titleSubtitleGap,
          defaultValue: null,
        ),
      )
      ..add(DoubleProperty('iconSpacing', iconSpacing, defaultValue: null))
      ..add(DoubleProperty('leadingWidth', leadingWidth, defaultValue: null))
      ..add(
        DoubleProperty('leadingSpacing', leadingSpacing, defaultValue: null),
      )
      ..add(
        DoubleProperty('checkmarkSize', checkmarkSize, defaultValue: null),
      )
      ..add(
        DiagnosticsProperty('showLeading', showLeading, defaultValue: null),
      )
      ..add(
        DiagnosticsProperty<MouseCursor>(
          'mouseCursor',
          mouseCursor,
          defaultValue: null,
        ),
      )
      ..add(DoubleProperty('minHeight', minHeight, defaultValue: null));
  }
}

IconData? _lerpIconData(IconData? a, IconData? b, double t) => t < 0.5 ? a : b;

EdgeInsetsDirectional? _lerpEdgeInsetsDirectional(
  EdgeInsetsDirectional? a,
  EdgeInsetsDirectional? b,
  double t,
) => EdgeInsetsDirectional.lerp(a, b, t);

/// A set of default values for [PullDownMenuItemTheme].
@immutable
class _Defaults extends PullDownMenuItemTheme {
  /// Creates [_Defaults].
  const _Defaults(this.context)
    : super(
        checkmark: CupertinoIcons.checkmark,
      );

  /// A build context used to resolve [CupertinoDynamicColor]s defined in this
  /// theme.
  final BuildContext context;

  @override
  Color get destructiveColor => CupertinoColors.systemRed.resolveFrom(context);

  Color get _labelColor => CupertinoColors.label.resolveFrom(context);

  /// The [PullDownMenuItemTheme.textStyle] before applying
  /// [CupertinoColors.label].
  static const kTextStyle = TextStyle(
    inherit: false,
    fontFamily: kPullDownMenuEntryFontFamily,
    fontFamilyFallback: kPullDownMenuEntryFontFallbacks,
    fontSize: 17,
    height: 22 / 17,
    fontWeight: FontWeight.w400,
    textBaseline: TextBaseline.alphabetic,
    letterSpacing: -0.43,
    fontStyle: FontStyle.normal,
    decoration: TextDecoration.none,
  );

  @override
  TextStyle get textStyle => kTextStyle.copyWith(color: _labelColor);

  /// The [PullDownMenuItemTheme.subtitleStyle] before applying
  /// [CupertinoColors.label].
  static const kSubtitleStyle = TextStyle(
    inherit: false,
    fontFamily: kPullDownMenuEntryFontFamily,
    fontFamilyFallback: kPullDownMenuEntryFontFallbacks,
    fontSize: 15,
    height: 20 / 15,
    fontWeight: FontWeight.w400,
    textBaseline: TextBaseline.alphabetic,
    letterSpacing: -0.43,
  );

  /// The light and dark colors of [PullDownMenuItem.subtitle].
  static const kSubtitleColor = SimpleDynamicColor(
    color: Color.fromRGBO(60, 60, 67, 0.6),
    darkColor: Color.fromRGBO(235, 235, 245, 0.6),
  );

  @override
  TextStyle get subtitleStyle => kSubtitleStyle.copyWith(
    color: kSubtitleColor.resolveFrom(context),
  );

  /// The [PullDownMenuItemTheme.iconActionTextStyle] before applying
  /// [CupertinoColors.label].
  static const kIconActionTextStyle = TextStyle(
    inherit: false,
    fontFamily: kPullDownMenuEntryFontFamily,
    fontFamilyFallback: kPullDownMenuEntryFontFallbacks,
    fontSize: 13,
    height: 18 / 13,
    fontWeight: FontWeight.w400,
    textBaseline: TextBaseline.alphabetic,
    letterSpacing: -0.43,
  );

  @override
  TextStyle get iconActionTextStyle =>
      kIconActionTextStyle.copyWith(color: _labelColor);

  /// The [PullDownMenuItemTheme.trailingTextStyle] before applying color.
  static const kTrailingTextStyle = TextStyle(
    inherit: false,
    fontFamily: kPullDownMenuEntryFontFamily,
    fontFamilyFallback: kPullDownMenuEntryFontFallbacks,
    fontSize: 17,
    height: 22 / 17,
    fontWeight: FontWeight.w400,
    textBaseline: TextBaseline.alphabetic,
    letterSpacing: -0.43,
  );

  @override
  TextStyle get trailingTextStyle => kTrailingTextStyle.copyWith(
    color: kSubtitleColor.resolveFrom(context),
  );

  @override
  Color get trailingColor => kSubtitleColor.resolveFrom(context);

  /// The light and dark on pressed/on hover colors of [PullDownMenuItem].
  static const kOnPressedColor = SimpleDynamicColor(
    color: Color.fromRGBO(0, 0, 0, 0.08),
    darkColor: Color.fromRGBO(255, 255, 255, 0.135),
  );

  @override
  Color get onPressedBackgroundColor => kOnPressedColor.resolveFrom(context);

  @override
  Color get onHoverBackgroundColor => kOnPressedColor.resolveFrom(context);

  @override
  Color get onHoverTextColor => _labelColor;

  @override
  Color get onPressedTextColor => _labelColor;

  @override
  Color get titleColor => _labelColor;

  @override
  Color get subtitleColor => kSubtitleColor.resolveFrom(context);

  @override
  Color get iconColor => _labelColor;

  @override
  PullDownMenuItemIconAlignment get iconAlignment =>
      PullDownMenuItemIconAlignment.trailing;

  @override
  BorderRadius get itemBorderRadius => BorderRadius.zero;

  @override
  EdgeInsetsDirectional get padding => const EdgeInsetsDirectional.only(
    start: 16,
    end: 16,
    top: 11,
    bottom: 11,
  );

  @override
  EdgeInsetsDirectional get headerPadding => const EdgeInsetsDirectional.only(
    start: 16,
    end: 12,
    top: 10,
    bottom: 10,
  );

  @override
  EdgeInsetsGeometry get actionsRowPadding =>
      const EdgeInsetsDirectional.all(10);

  @override
  double get titleSubtitleGap => 0;

  @override
  double get iconSpacing => 8;

  @override
  double get leadingWidth => 20;

  @override
  double get leadingSpacing => 4;

  @override
  double get checkmarkSize => 17;
}
