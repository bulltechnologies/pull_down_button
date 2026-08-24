/// @docImport '/src/theme/theme.dart';
/// @docImport 'actions_row.dart';
library;

import 'package:flutter/cupertino.dart';

import '/src/internals/button.dart';
import '/src/internals/content_size_category.dart';
import '/src/internals/element_size.dart';
import '/src/internals/item_layout.dart';
import '/src/internals/menu_config.dart';
import '/src/theme/item_theme.dart';
import '/src/theme/route_theme.dart';
import 'item.dart';

const double _kHeaderEndPadding = 12;

/// The default size of a leading widget in [PullDownMenuHeader].
const BoxConstraints _kLeadingSize = BoxConstraints.tightFor(
  height: kMinInteractiveDimensionCupertino,
  width: kMinInteractiveDimensionCupertino,
);

/// Signature used by [PullDownMenuHeader] to build custom leading widget.
///
/// Additionally provides a default constraints for the leading widget.
///
/// Used by [PullDownMenuHeader.leadingBuilder].
typedef PullDownMenuHeaderLeadingBuilder =
    Widget Function(
      BuildContext context,
      BoxConstraints constraints,
    );

/// The (optional) header of the pull-down menu that is usually displayed at the
/// top of the pull-down menu.
///
/// To indicate that [PullDownMenuHeader] has an action consider providing
/// [icon] or [iconWidget].
///
/// See also:
///
/// * [UIKit documentation, UIDocumentProperties](https://developer.apple.com/documentation/uikit/uidocumentproperties)
@immutable
class PullDownMenuHeader extends StatelessWidget {
  /// Creates a header for pull-down menu.
  const PullDownMenuHeader({
    super.key,
    this.onTap,
    this.tapHandler = PullDownMenuItem.defaultTapHandler,
    this.leading,
    this.leadingBuilder,
    required this.title,
    this.titleWidget,
    this.subtitle,
    this.subtitleWidget,
    this.trailing,
    this.itemTheme,
    this.icon,
    this.iconWidget,
    this.iconColor,
    this.iconSize,
    this.backgroundColor,
    this.margin,
    this.border,
    this.padding,
    this.itemBorderRadius,
    this.mouseCursor,
    this.titleSubtitleGap,
  }) : assert(
         icon == null || iconWidget == null,
         'Please provide either icon or iconWidget',
       ),
       assert(
         leading == null || leadingBuilder == null,
         'Please provide either leading or leadingBuilder',
       );

  /// The action this header represents.
  ///
  /// If [onTap] is not `null` consider providing either [icon] or [iconWidget]
  /// to indicate to user that this header has an action.
  ///
  /// To specify how this action is resolved, [tapHandler] is used.
  ///
  /// See also:
  ///
  /// * [PullDownMenuItem.defaultTapHandler], a default tap handler.
  /// * [PullDownMenuItem.noPopTapHandler], a tap handler that immediately calls
  /// [onTap] without popping the menu.
  /// * [PullDownMenuItem.delayedTapHandler], a tap handler that pops the menu,
  ///  waits for an animation to end and calls the [onTap].
  final VoidCallback? onTap;

  /// Handler that provides this item's [BuildContext] as well as [onTap] to
  /// resolve how [onTap] callback is used.
  final PullDownMenuItemTapHandler tapHandler;

  /// The leading widget of [PullDownMenuHeader].
  ///
  /// Typically an [Image] widget.
  ///
  /// By default, a [PullDownMenuHeader.leading] is in a square box with
  /// [kMinInteractiveDimensionCupertino] pixels height/width. To create a
  /// custom, non-default, leading widget - use [leadingBuilder].
  ///
  /// If the [leadingBuilder] is used, this property must be null;
  final Widget? leading;

  /// Custom leading widget of [PullDownMenuHeader].
  ///
  /// If the [leading] is used, this property must be null;
  final PullDownMenuHeaderLeadingBuilder? leadingBuilder;

  /// Title of this [PullDownMenuHeader].
  final String title;

  /// Optional custom title widget.
  final Widget? titleWidget;

  /// Subtitle of this [PullDownMenuHeader].
  final String? subtitle;

  /// Optional custom subtitle widget.
  final Widget? subtitleWidget;

  /// Optional trailing widget.
  final Widget? trailing;

  /// Theme of this [PullDownMenuHeader].
  ///
  /// If this property is null, then [PullDownMenuItemTheme] from
  /// [PullDownButtonTheme.itemTheme] is used.
  ///
  /// If that's null, then defaults from [PullDownMenuItemTheme.defaults] are
  /// used.
  final PullDownMenuItemTheme? itemTheme;

  /// Icon of this [PullDownMenuHeader].
  ///
  /// If the [iconWidget] is used, this property must be null;
  final IconData? icon;

  /// Custom icon widget of this [PullDownMenuHeader].
  ///
  /// If the [icon] is used, this property must be null;
  ///
  /// If used in [PullDownMenuActionsRow], either this or [icon] is required.
  final Widget? iconWidget;

  /// Custom icon color for this header.
  final Color? iconColor;

  /// Custom icon size for this header.
  final double? iconSize;

  /// Default idle background color for this header container.
  final Color? backgroundColor;

  /// Outer margin surrounding this header inside the menu body.
  final EdgeInsetsGeometry? margin;

  /// Border around this header container.
  final BoxBorder? border;

  /// Custom padding for this header item.
  final EdgeInsetsDirectional? padding;

  /// Custom border radius for this header item.
  final BorderRadius? itemBorderRadius;

  /// Custom mouse cursor for this header item.
  final MouseCursor? mouseCursor;

  /// Gap between title and subtitle.
  final double? titleSubtitleGap;

  PullDownMenuItemTheme _resolveTheme(BuildContext context) {
    final PullDownMenuItemTheme ambient =
        MenuConfig.ambientThemeOf(context).itemTheme;

    if (itemTheme == null) {
      return ambient;
    }

    return ambient.copyWith(
      destructiveColor: itemTheme!.destructiveColor,
      checkmark: itemTheme!.checkmark,
      textStyle: itemTheme!.textStyle,
      subtitleStyle: itemTheme!.subtitleStyle,
      iconActionTextStyle: itemTheme!.iconActionTextStyle,
      trailingTextStyle: itemTheme!.trailingTextStyle,
      trailingColor: itemTheme!.trailingColor,
      backgroundColor: itemTheme!.backgroundColor,
      onHoverBackgroundColor: itemTheme!.onHoverBackgroundColor,
      onPressedBackgroundColor: itemTheme!.onPressedBackgroundColor,
      onHoverTextColor: itemTheme!.onHoverTextColor,
      onPressedTextColor: itemTheme!.onPressedTextColor,
      titleColor: itemTheme!.titleColor,
      subtitleColor: itemTheme!.subtitleColor,
      iconColor: itemTheme!.iconColor,
      iconBackgroundColor: itemTheme!.iconBackgroundColor,
      iconBorderRadius: itemTheme!.iconBorderRadius,
      iconPadding: itemTheme!.iconPadding,
      iconSize: itemTheme!.iconSize,
      iconAlignment: itemTheme!.iconAlignment,
      disabledOpacity: itemTheme!.disabledOpacity,
      itemBorderRadius: itemTheme!.itemBorderRadius,
      border: itemTheme!.border,
      margin: itemTheme!.margin,
      padding: itemTheme!.padding,
      headerPadding: itemTheme!.headerPadding,
      actionsRowPadding: itemTheme!.actionsRowPadding,
      titleSubtitleGap: itemTheme!.titleSubtitleGap,
      iconSpacing: itemTheme!.iconSpacing,
      leadingWidth: itemTheme!.leadingWidth,
      leadingSpacing: itemTheme!.leadingSpacing,
      checkmarkSize: itemTheme!.checkmarkSize,
      showLeading: itemTheme!.showLeading,
      mouseCursor: itemTheme!.mouseCursor,
      minHeight: itemTheme!.minHeight,
    );
  }

  @override
  Widget build(BuildContext context) {
    final PullDownMenuItemTheme theme = _resolveTheme(context);

    final Widget resolvedLeading =
        leadingBuilder?.call(context, _kLeadingSize) ??
        (leading != null ? _Leading(child: leading!) : const SizedBox.shrink());

    return MergeSemantics(
      child: Semantics(
        button: onTap != null,
        child: MenuActionButton(
          onTap: onTap != null ? () => tapHandler(context, onTap) : null,
          backgroundColor: backgroundColor ?? theme.backgroundColor,
          hoverColor: theme.onHoverBackgroundColor!,
          pressedColor: theme.onPressedBackgroundColor!,
          borderRadius:
              itemBorderRadius ?? theme.itemBorderRadius ?? BorderRadius.zero,
          border: border ?? theme.border,
          margin: margin ?? theme.margin,
          mouseCursor: mouseCursor ?? theme.mouseCursor,
          child: _HeaderBody(
            theme: theme,
            leading: resolvedLeading,
            title: title,
            titleWidget: titleWidget,
            titleStyle: theme.textStyle!,
            subtitle: subtitle,
            subtitleWidget: subtitleWidget,
            subtitleStyle: theme.subtitleStyle!,
            titleSubtitleGap: titleSubtitleGap ?? theme.titleSubtitleGap,
            trailing: trailing,
            icon: icon,
            iconWidget: iconWidget,
            iconColor: iconColor,
            iconSize: iconSize,
            onHoverTextColor: theme.onHoverTextColor!,
            padding: padding ?? theme.headerPadding!,
          ),
        ),
      ),
    );
  }
}

/// An a header menu item.
@immutable
class _HeaderBody extends StatelessWidget {
  /// Creates [_HeaderBody].
  const _HeaderBody({
    required this.theme,
    required this.leading,
    required this.title,
    this.titleWidget,
    required this.titleStyle,
    required this.subtitle,
    this.subtitleWidget,
    required this.subtitleStyle,
    this.titleSubtitleGap,
    this.trailing,
    required this.icon,
    required this.iconWidget,
    this.iconColor,
    this.iconSize,
    required this.onHoverTextColor,
    required this.padding,
  });

  final PullDownMenuItemTheme theme;
  final Widget leading;
  final String title;
  final Widget? titleWidget;
  final TextStyle titleStyle;
  final String? subtitle;
  final Widget? subtitleWidget;
  final TextStyle subtitleStyle;
  final double? titleSubtitleGap;
  final Widget? trailing;
  final IconData? icon;
  final Widget? iconWidget;
  final Color? iconColor;
  final double? iconSize;
  final Color onHoverTextColor;
  final EdgeInsetsDirectional padding;

  @override
  Widget build(BuildContext context) {
    final bool isHovered = MenuActionButtonHoverState.of(context);

    final double minHeight = ElementSize.extraLarge.resolve(
      MenuConfig.contentSizeCategoryOf(context),
    );

    final bool isInAccessibilityMode =
        ContentSizeCategory.isInAccessibilityMode(context);
    final int maxLines = isInAccessibilityMode ? 3 : 2;

    Widget body =
        titleWidget ??
        Text(
          title,
          style: titleStyle.copyWith(
            color: isHovered ? onHoverTextColor : null,
          ),
          textAlign: TextAlign.start,
          overflow: TextOverflow.ellipsis,
          softWrap: false,
          maxLines: maxLines,
        );

    if (subtitleWidget != null || subtitle != null) {
      final Widget subtitleContent =
          subtitleWidget ??
          Text(
            subtitle!,
            style: subtitleStyle,
            textAlign: TextAlign.start,
            overflow: TextOverflow.ellipsis,
            softWrap: false,
            maxLines: maxLines,
          );

      final double gap = titleSubtitleGap ?? theme.titleSubtitleGap ?? 0;

      body = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          body,
          if (gap > 0) SizedBox(height: gap),
          subtitleContent,
        ],
      );
    }

    final bool hasIcon =
        !isInAccessibilityMode && (icon != null || iconWidget != null);

    body = Row(
      children: [
        Padding(
          padding: const EdgeInsetsDirectional.only(end: _kHeaderEndPadding),
          child: leading,
        ),
        Expanded(child: body),
        if (trailing != null) ...[
          const SizedBox(width: 8),
          DefaultTextStyle(
            style: theme.trailingTextStyle ?? subtitleStyle,
            child: trailing!,
          ),
        ],
        if (hasIcon)
          Padding(
            padding: EdgeInsetsDirectional.only(start: theme.iconSpacing!),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: (isHovered ? onHoverTextColor : subtitleStyle.color!)
                    .withValues(alpha: 0.18),
                shape: BoxShape.circle,
              ),
              child: IconActionBox(
                color:
                    iconColor ??
                    (isHovered ? onHoverTextColor : titleStyle.color!),
                size: iconSize,
                child: iconWidget ?? Icon(icon),
              ),
            ),
          ),
      ],
    );

    return AnimatedMenuContainer(
      alignment: AlignmentDirectional.centerStart,
      constraints: BoxConstraints(minHeight: minHeight),
      padding: padding,
      child: body,
    );
  }
}

/// A leading widget for [PullDownMenuHeader].
@immutable
class _Leading extends StatelessWidget {
  /// Creates [_Leading].
  const _Leading({
    required this.child,
  });

  /// The widget below this widget in the tree.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final PullDownMenuRouteTheme theme =
        MenuConfig.ambientThemeOf(context).routeTheme;

    final Color shadowColor =
        theme.resolvedBoxShadow?.firstOrNull?.color ??
        const Color.fromRGBO(0, 0, 0, 0.2);

    final Widget resolvedChild = ConstrainedBox(
      constraints: _kLeadingSize,
      child: DecoratedBox(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: shadowColor,
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: child,
      ),
    );

    return theme.borderClipper!.call(
      const BorderRadius.all(Radius.circular(4)),
      resolvedChild,
    );
  }
}
