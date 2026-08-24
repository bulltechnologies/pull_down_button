/// @docImport '/src/theme/theme.dart';
/// @docImport 'actions_row.dart';
/// @docImport 'header.dart';
library;

import 'package:flutter/cupertino.dart';

import '/src/internals/actions_row_size_config.dart';
import '/src/internals/brightness.dart';
import '/src/internals/button.dart';
import '/src/internals/content_size_category.dart';
import '/src/internals/element_size.dart';
import '/src/internals/item_layout.dart';
import '/src/internals/menu_config.dart';
import '/src/internals/route.dart';
import '/src/theme/item_theme.dart';
import '/src/theme/theme.dart';

EdgeInsetsDirectional _itemPadding({
  required PullDownMenuItemTheme theme,
  required EdgeInsetsDirectional? itemPadding,
  required bool hasLeading,
}) {
  if (itemPadding != null) {
    return itemPadding;
  }

  final EdgeInsetsDirectional padding = theme.padding!;
  if (!hasLeading) {
    return padding;
  }

  return padding.copyWith(start: 9);
}

/// Signature used by [PullDownMenuItem] to resolve how [onTap] callback is
/// used.
///
/// Default behavior is to pop the menu and call the [onTap].
///
/// Used by [PullDownMenuItem.tapHandler] and [PullDownMenuHeader.tapHandler].
///
/// See also:
///
/// * [PullDownMenuItem.defaultTapHandler], a default tap handler.
/// * [PullDownMenuItem.noPopTapHandler], a tap handler that immediately calls
/// [onTap] without popping the menu.
/// * [PullDownMenuItem.delayedTapHandler], a tap handler that pops the menu,
/// waits for an animation to end and calls the [onTap].
typedef PullDownMenuItemTapHandler =
    void Function(
      BuildContext context,
      VoidCallback? onTap,
    );

/// State exposed to [PullDownMenuItem.builder].
@immutable
class PullDownMenuItemState {
  /// Creates [PullDownMenuItemState].
  const PullDownMenuItemState({
    required this.isHovered,
    required this.isPressed,
    required this.enabled,
    required this.selected,
    this.onTap,
  });

  /// Whether the item is currently hovered.
  final bool isHovered;

  /// Whether the item is currently pressed.
  final bool isPressed;

  /// Whether the item is enabled.
  final bool enabled;

  /// Whether the item is selected (for selectable items).
  final bool? selected;

  /// Callback to execute the item's tap action.
  final VoidCallback? onTap;
}

/// Signature used by [PullDownMenuItem.builder] to create a fully customized
/// item based on its interactive state.
typedef PullDownMenuItemWidgetBuilder =
    Widget Function(
      BuildContext context,
      PullDownMenuItemState state,
    );

/// An item in a cupertino style pull-down menu.
///
/// To show a checkmark next to the pull-down menu item (an item with a
/// selection state), use [PullDownMenuItem.selectable].
///
/// To create a fully custom menu item, use [PullDownMenuItem.custom] or
/// [PullDownMenuItem.builder].
@immutable
class PullDownMenuItem extends StatelessWidget {
  /// Creates an item for a pull-down menu.
  ///
  /// By default, the item is [enabled].
  const PullDownMenuItem({
    super.key,
    required this.onTap,
    this.tapHandler = defaultTapHandler,
    this.enabled = true,
    required this.title,
    this.titleWidget,
    this.subtitle,
    this.subtitleWidget,
    this.itemTheme,
    this.icon,
    this.iconColor,
    this.iconWidget,
    this.iconSize,
    this.iconAlignment,
    this.iconBackgroundColor,
    this.iconBorderRadius,
    this.iconPadding,
    this.trailing,
    this.leading,
    this.isDestructive = false,
    this.backgroundColor,
    this.margin,
    this.border,
    this.padding,
    this.itemBorderRadius,
    this.mouseCursor,
    this.alignment,
    this.titleSubtitleGap,
    this.showLeading,
  }) : selected = null,
       builder = null,
       _isCustom = false,
       assert(
         icon == null || iconWidget == null,
         'Please provide either icon or iconWidget',
       );

  /// Creates a selectable item for a pull-down menu.
  ///
  /// By default, the item is [enabled].
  const PullDownMenuItem.selectable({
    super.key,
    required this.onTap,
    this.tapHandler = defaultTapHandler,
    this.enabled = true,
    required this.title,
    this.titleWidget,
    this.subtitle,
    this.subtitleWidget,
    this.itemTheme,
    this.icon,
    this.iconColor,
    this.iconWidget,
    this.iconSize,
    this.iconAlignment,
    this.iconBackgroundColor,
    this.iconBorderRadius,
    this.iconPadding,
    this.trailing,
    this.leading,
    this.isDestructive = false,
    this.selected = false,
    this.backgroundColor,
    this.margin,
    this.border,
    this.padding,
    this.itemBorderRadius,
    this.mouseCursor,
    this.alignment,
    this.titleSubtitleGap,
    this.showLeading,
  }) : builder = null,
       _isCustom = false,
       assert(
         icon == null || iconWidget == null,
         'Please provide either icon or iconWidget',
       );

  /// Creates a custom item for a pull-down menu with an arbitrary [child]
  /// widget.
  const PullDownMenuItem.custom({
    super.key,
    required Widget child,
    this.onTap,
    this.tapHandler = defaultTapHandler,
    this.enabled = true,
    this.itemTheme,
    this.backgroundColor,
    this.margin,
    this.border,
    this.padding,
    this.itemBorderRadius,
    this.mouseCursor,
    this.alignment,
  }) : title = '',
       titleWidget = child,
       subtitle = null,
       subtitleWidget = null,
       icon = null,
       iconColor = null,
       iconWidget = null,
       iconSize = null,
       iconAlignment = null,
       iconBackgroundColor = null,
       iconBorderRadius = null,
       iconPadding = null,
       trailing = null,
       leading = null,
       isDestructive = false,
       selected = null,
       builder = null,
       titleSubtitleGap = null,
       showLeading = null,
       _isCustom = true;

  /// Creates an item for a pull-down menu built using [builder] which reacts
  /// to hover and press states.
  const PullDownMenuItem.builder({
    super.key,
    required this.builder,
    this.onTap,
    this.tapHandler = defaultTapHandler,
    this.enabled = true,
    this.itemTheme,
    this.backgroundColor,
    this.margin,
    this.border,
    this.padding,
    this.itemBorderRadius,
    this.mouseCursor,
    this.alignment,
  }) : title = '',
       titleWidget = null,
       subtitle = null,
       subtitleWidget = null,
       icon = null,
       iconColor = null,
       iconWidget = null,
       iconSize = null,
       iconAlignment = null,
       iconBackgroundColor = null,
       iconBorderRadius = null,
       iconPadding = null,
       trailing = null,
       leading = null,
       isDestructive = false,
       selected = null,
       titleSubtitleGap = null,
       showLeading = null,
       _isCustom = true;

  final bool _isCustom;

  /// Builder for dynamic or morphing item states.
  final PullDownMenuItemWidgetBuilder? builder;

  /// The action this item represents.
  ///
  /// To specify how this action is resolved, [tapHandler] is used.
  ///
  /// See also:
  ///
  /// * [defaultTapHandler], a default tap handler.
  /// * [noPopTapHandler], a tap handler that immediately calls [onTap] without
  /// popping the menu.
  /// * [delayedTapHandler], a tap handler that pops the menu, waits for an
  /// animation to end and calls the [onTap].
  final VoidCallback? onTap;

  /// Handler that provides this item's [BuildContext] as well as [onTap] to
  /// resolve how [onTap] callback is used.
  final PullDownMenuItemTapHandler tapHandler;

  /// Whether the user is permitted to tap this item.
  ///
  /// Defaults to true. If this is false, the item will not react to touches,
  /// and item text styles and icon colors will be updated with a lower opacity
  /// to indicate a disabled state.
  final bool enabled;

  /// Title of this [PullDownMenuItem].
  final String title;

  /// Optional custom title widget.
  ///
  /// If provided, overrides the default [title] [Text] rendering.
  final Widget? titleWidget;

  /// Subtitle of this [PullDownMenuItem].
  final String? subtitle;

  /// Optional custom subtitle widget.
  ///
  /// If provided, overrides the default [subtitle] [Text] rendering.
  final Widget? subtitleWidget;

  /// Theme of this [PullDownMenuItem].
  ///
  /// If this property is null, then [PullDownMenuItemTheme] from
  /// [PullDownButtonTheme.itemTheme] is used.
  ///
  /// If that's null, then defaults from [PullDownMenuItemTheme.defaults] are
  /// used.
  final PullDownMenuItemTheme? itemTheme;

  /// Icon of this [PullDownMenuItem].
  ///
  /// If the [iconWidget] is used, this property must be null;
  ///
  /// If used in [PullDownMenuActionsRow], either this or [iconWidget] are
  /// required.
  final IconData? icon;

  /// Color for this [PullDownMenuItem]'s [icon].
  ///
  /// If not provided, `textStyle.color` from [itemTheme] will be used.
  ///
  /// If [PullDownMenuItem] `isDestructive`, then [iconColor] will be ignored.
  final Color? iconColor;

  /// Custom icon widget of this [PullDownMenuItem].
  ///
  /// If the [icon] is used, this property must be null;
  ///
  /// If used in [PullDownMenuActionsRow], either this or [icon] is required.
  final Widget? iconWidget;

  /// Custom icon size for this item.
  final double? iconSize;

  /// Placement of the icon relative to title.
  final PullDownMenuItemIconAlignment? iconAlignment;

  /// Background color for the icon's container.
  final Color? iconBackgroundColor;

  /// Border radius for the icon's container.
  final BorderRadius? iconBorderRadius;

  /// Padding for the icon's container.
  final EdgeInsetsGeometry? iconPadding;

  /// Optional trailing widget, such as a keyboard shortcut hint, badge, or
  /// accessory icon.
  final Widget? trailing;

  /// Optional custom leading widget.
  ///
  /// If provided on a selectable item, it replaces the default checkmark.
  final Widget? leading;

  /// Whether this item represents destructive action.
  ///
  /// If this is true, then `destructiveColor` from [itemTheme] is used.
  final bool isDestructive;

  /// Whether to display a checkmark next to the menu item.
  ///
  /// Defaults to `null`.
  ///
  /// If [PullDownMenuItem] is used inside [PullDownMenuActionsRow] this
  /// property will be ignored, and a checkmark will not be shown.
  ///
  /// When true, an [PullDownMenuItemTheme.checkmark] checkmark is displayed
  /// (from [itemTheme]).
  ///
  /// If itemTheme is null, then defaults from [PullDownMenuItemTheme.defaults]
  /// are used.
  final bool? selected;

  /// Default idle background color for this item container.
  final Color? backgroundColor;

  /// Outer margin surrounding this item inside the menu body.
  final EdgeInsetsGeometry? margin;

  /// Border around this item container.
  final BoxBorder? border;

  /// Custom padding for this menu item.
  final EdgeInsetsDirectional? padding;

  /// Custom border radius for this menu item's tap highlight.
  final BorderRadius? itemBorderRadius;

  /// Custom mouse cursor for this menu item.
  final MouseCursor? mouseCursor;

  /// Alignment of the item body.
  final AlignmentGeometry? alignment;

  /// Gap between title and subtitle.
  final double? titleSubtitleGap;

  /// Whether to show and reserve the leading checkmark column.
  final bool? showLeading;

  /// Default tap handler for [PullDownMenuItem].
  ///
  /// The behavior is to pop the menu and then call the [onTap].
  static void defaultTapHandler(BuildContext context, VoidCallback? onTap) {
    if (ModalRoute.of(context) is PullDownMenuRoute) {
      Navigator.pop(context, onTap);
    } else {
      noPopTapHandler(context, onTap);
    }
  }

  /// An additional, pre-made tap handler for [PullDownMenuItem].
  ///
  /// The behavior is to pop the menu, wait until the animation ends, and call
  /// the [onTap].
  ///
  /// This might be useful if [onTap] results in action involved with changing
  /// navigation stack (like opening a new screen or showing dialog) so there
  /// is a smoother transition between the pull-down menu and said navigation
  /// stack changing action.
  static void delayedTapHandler(
    BuildContext context,
    VoidCallback? onTap,
  ) {
    if (ModalRoute.of(context) is PullDownMenuRoute) {
      Future<void> future() async {
        final Duration duration =
            PullDownButtonTheme.ambientOf(
              context,
            ).routeTheme.closeDuration!;

        await Future<void>.delayed(duration);

        onTap?.call();
      }

      Navigator.pop(context, future);
    } else {
      noPopTapHandler(context, onTap);
    }
  }

  /// An additional, pre-made tap handler for [PullDownMenuItem].
  ///
  /// The behavior is to call the [onTap] without popping the menu.
  static void noPopTapHandler(
    BuildContext _,
    VoidCallback? onTap,
  ) => onTap?.call();

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
    final ElementSize size = ActionsRowSizeConfig.of(context);

    if (!_isCustom) {
      assert(
        switch (size) {
          ElementSize.small ||
          ElementSize.medium => icon != null || iconWidget != null,
          ElementSize.large => true,
          _ => throw UnsupportedError(''),
        },
        'Either icon or iconWidget should be provided',
      );
    }

    final PullDownMenuItemTheme theme = _resolveTheme(context);
    final bool isEnabled = enabled && onTap != null;

    final Widget child;

    if (builder != null) {
      child = Builder(
        builder: (context) {
          final buttonState = MenuActionButtonState.maybeOf(context);
          final state = PullDownMenuItemState(
            isHovered: buttonState?.isHovered ?? false,
            isPressed: buttonState?.isPressed ?? false,
            enabled: isEnabled,
            selected: selected,
            onTap: isEnabled ? () => tapHandler(context, onTap) : null,
          );
          final EdgeInsetsDirectional resolvedPadding =
              padding ?? theme.padding!;

          return AnimatedMenuContainer(
            alignment: alignment ?? AlignmentDirectional.centerStart,
            padding: resolvedPadding,
            child: builder!(context, state),
          );
        },
      );
    } else {
      child = switch (size) {
        ElementSize.small => _SmallItem(
          icon: iconWidget ?? Icon(icon),
          iconSize: iconSize ?? theme.iconSize,
          destructiveColor: theme.destructiveColor!,
          onHoverColor: theme.onHoverTextColor!,
          color:
              iconColor ?? theme.iconColor ?? theme.iconActionTextStyle!.color!,
          iconBackgroundColor: iconBackgroundColor ?? theme.iconBackgroundColor,
          iconBorderRadius: iconBorderRadius ?? theme.iconBorderRadius,
          iconPadding: iconPadding ?? theme.iconPadding,
          enabled: isEnabled,
          destructive: isDestructive,
        ),
        ElementSize.medium => _MediumItem(
          icon: iconWidget ?? Icon(icon),
          iconSize: iconSize ?? theme.iconSize,
          destructiveColor: theme.destructiveColor!,
          onHoverColor: theme.onHoverTextColor!,
          iconColor: iconColor ?? theme.iconColor,
          iconBackgroundColor: iconBackgroundColor ?? theme.iconBackgroundColor,
          iconBorderRadius: iconBorderRadius ?? theme.iconBorderRadius,
          iconPadding: iconPadding ?? theme.iconPadding,
          enabled: isEnabled,
          destructive: isDestructive,
          title: title,
          titleWidget: titleWidget,
          titleStyle: theme.iconActionTextStyle!,
          actionsRowPadding: theme.actionsRowPadding!,
        ),
        ElementSize.large || _ => _LargeItem(
          theme: theme,
          icon: icon,
          iconWidget: iconWidget,
          iconSize: iconSize ?? theme.iconSize,
          iconAlignment: iconAlignment ?? theme.iconAlignment,
          iconBackgroundColor: iconBackgroundColor ?? theme.iconBackgroundColor,
          iconBorderRadius: iconBorderRadius ?? theme.iconBorderRadius,
          iconPadding: iconPadding ?? theme.iconPadding,
          destructiveColor: theme.destructiveColor!,
          onHoverColor: theme.onHoverTextColor!,
          iconColor: iconColor ?? theme.iconColor,
          enabled: isEnabled,
          destructive: isDestructive,
          leading:
              leading ??
              ((showLeading ?? theme.showLeading ?? (selected != null || MenuConfig.hasLeadingOf(context)))
                  ? _CheckmarkIcon(
                    selected: selected ?? false,
                    checkmark: theme.checkmark!,
                    checkmarkSize: theme.checkmarkSize!,
                    leadingWidth: theme.leadingWidth!,
                    leadingSpacing: theme.leadingSpacing!,
                  )
                  : null),
          title: title,
          titleWidget: titleWidget,
          titleStyle: theme.textStyle!,
          subtitle: subtitle,
          subtitleWidget: subtitleWidget,
          subtitleStyle: theme.subtitleStyle!,
          titleSubtitleGap: titleSubtitleGap ?? theme.titleSubtitleGap,
          trailing: trailing,
          trailingStyle: theme.trailingTextStyle,
          itemPadding: padding,
          alignment: alignment,
          isCustom: _isCustom,
        ),
      };
    }

    final MouseCursor? effectiveMouseCursor =
        mouseCursor ?? theme.mouseCursor;

    return MergeSemantics(
      child: Semantics(
        enabled: enabled,
        button: true,
        selected: selected,
        child: MenuActionButton(
          onTap: enabled ? () => tapHandler(context, onTap) : null,
          backgroundColor: backgroundColor ?? theme.backgroundColor,
          pressedColor: theme.onPressedBackgroundColor!,
          hoverColor: theme.onHoverBackgroundColor!,
          borderRadius:
              itemBorderRadius ?? theme.itemBorderRadius ?? BorderRadius.zero,
          border: border ?? theme.border,
          margin: margin ?? theme.margin,
          mouseCursor: effectiveMouseCursor,
          child: child,
        ),
      ),
    );
  }
}

/// A [ElementSize.small] menu item.
@immutable
class _SmallItem extends StatelessWidget {
  const _SmallItem({
    required this.icon,
    this.iconSize,
    this.iconBackgroundColor,
    this.iconBorderRadius,
    this.iconPadding,
    required this.destructiveColor,
    required this.onHoverColor,
    required this.color,
    required this.enabled,
    required this.destructive,
  });

  final Widget icon;
  final double? iconSize;
  final Color? iconBackgroundColor;
  final BorderRadius? iconBorderRadius;
  final EdgeInsetsGeometry? iconPadding;
  final Color destructiveColor;
  final Color onHoverColor;
  final Color color;
  final bool enabled;
  final bool destructive;

  @override
  Widget build(BuildContext context) {
    final bool isHovered = MenuActionButtonHoverState.of(context);

    Color resolvedColor = color;
    if (destructive) {
      resolvedColor = destructiveColor;
    } else if (isHovered) {
      resolvedColor = onHoverColor;
    }

    if (!enabled) {
      final double disabledOpacity =
          MenuConfig.ambientThemeOf(context).itemTheme.disabledOpacity ??
          disabledOpacityOf(context);

      resolvedColor = resolvedColor.withValues(alpha: disabledOpacity);
    }

    return Center(
      child: IconBox(
        color: resolvedColor,
        size: iconSize,
        backgroundColor: iconBackgroundColor,
        borderRadius: iconBorderRadius,
        padding: iconPadding,
        child: icon,
      ),
    );
  }
}

/// A [ElementSize.medium] menu item.
@immutable
class _MediumItem extends StatelessWidget {
  const _MediumItem({
    required this.icon,
    this.iconSize,
    this.iconBackgroundColor,
    this.iconBorderRadius,
    this.iconPadding,
    required this.destructiveColor,
    required this.onHoverColor,
    required this.iconColor,
    required this.enabled,
    required this.destructive,
    required this.title,
    this.titleWidget,
    required this.titleStyle,
    required this.actionsRowPadding,
  });

  final Widget icon;
  final double? iconSize;
  final Color? iconBackgroundColor;
  final BorderRadius? iconBorderRadius;
  final EdgeInsetsGeometry? iconPadding;
  final Color destructiveColor;
  final Color onHoverColor;
  final Color? iconColor;
  final bool enabled;
  final bool destructive;
  final String title;
  final Widget? titleWidget;
  final TextStyle titleStyle;
  final EdgeInsetsGeometry actionsRowPadding;

  @override
  Widget build(BuildContext context) {
    final bool isHovered = MenuActionButtonHoverState.of(context);

    Color resolvedColor = iconColor ?? titleStyle.color!;
    TextStyle resolvedStyle = titleStyle;
    if (destructive) {
      resolvedColor = destructiveColor;
      resolvedStyle = resolvedStyle.copyWith(color: destructiveColor);
    } else if (isHovered) {
      resolvedColor = onHoverColor;
      resolvedStyle = resolvedStyle.copyWith(color: onHoverColor);
    }

    if (!enabled) {
      final double disabledOpacity =
          MenuConfig.ambientThemeOf(context).itemTheme.disabledOpacity ??
          disabledOpacityOf(context);

      resolvedColor = resolvedColor.withValues(alpha: disabledOpacity);
      resolvedStyle = resolvedStyle.copyWith(
        color: resolvedStyle.color!.withValues(alpha: disabledOpacity),
      );
    }

    final Widget textWidget =
        titleWidget ??
        Text(
          title,
          style: resolvedStyle,
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          softWrap: false,
        );

    return Padding(
      padding: actionsRowPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconBox.small(
            color: resolvedColor,
            size: iconSize,
            backgroundColor: iconBackgroundColor,
            borderRadius: iconBorderRadius,
            padding: iconPadding,
            child: icon,
          ),
          const SizedBox(height: 1),
          textWidget,
        ],
      ),
    );
  }
}

/// A [ElementSize.large] menu item.
@immutable
class _LargeItem extends StatelessWidget {
  const _LargeItem({
    required this.theme,
    required this.icon,
    required this.iconWidget,
    this.iconSize,
    this.iconAlignment,
    this.iconBackgroundColor,
    this.iconBorderRadius,
    this.iconPadding,
    required this.destructiveColor,
    required this.onHoverColor,
    required this.iconColor,
    required this.enabled,
    required this.destructive,
    required this.leading,
    required this.title,
    this.titleWidget,
    required this.titleStyle,
    required this.subtitle,
    this.subtitleWidget,
    required this.subtitleStyle,
    this.titleSubtitleGap,
    this.trailing,
    this.trailingStyle,
    this.itemPadding,
    this.alignment,
    this.isCustom = false,
  });

  final PullDownMenuItemTheme theme;
  final IconData? icon;
  final Widget? iconWidget;
  final double? iconSize;
  final PullDownMenuItemIconAlignment? iconAlignment;
  final Color? iconBackgroundColor;
  final BorderRadius? iconBorderRadius;
  final EdgeInsetsGeometry? iconPadding;
  final Color destructiveColor;
  final Color onHoverColor;
  final Color? iconColor;
  final bool enabled;
  final bool destructive;
  final Widget? leading;
  final String title;
  final Widget? titleWidget;
  final TextStyle titleStyle;
  final String? subtitle;
  final Widget? subtitleWidget;
  final TextStyle subtitleStyle;
  final double? titleSubtitleGap;
  final Widget? trailing;
  final TextStyle? trailingStyle;
  final EdgeInsetsDirectional? itemPadding;
  final AlignmentGeometry? alignment;
  final bool isCustom;

  @override
  Widget build(BuildContext context) {
    if (isCustom && titleWidget != null) {
      final EdgeInsetsDirectional resolvedPadding =
          itemPadding ?? theme.padding!;

      return AnimatedMenuContainer(
        alignment: alignment ?? AlignmentDirectional.centerStart,
        padding: resolvedPadding,
        child: titleWidget!,
      );
    }

    final bool isHovered = MenuActionButtonHoverState.of(context);

    final ContentSizeCategory contentSizeCategory =
        MenuConfig.contentSizeCategoryOf(context);

    final double calculatedMinHeight =
        subtitle != null || subtitleWidget != null
            ? ElementSize.extraLarge.resolve(contentSizeCategory)
            : ElementSize.large.resolve(contentSizeCategory);

    final double minHeight = theme.minHeight ?? calculatedMinHeight;

    final bool isInAccessibilityMode =
        ContentSizeCategory.isInAccessibilityMode(context);
    final int maxLines = isInAccessibilityMode ? 3 : 2;

    Color resolvedColor = iconColor ?? titleStyle.color!;
    TextStyle resolvedStyle = titleStyle;
    TextStyle resolvedSubtitleStyle = subtitleStyle;
    TextStyle? resolvedTrailingStyle = trailingStyle;

    if (destructive) {
      resolvedColor = destructiveColor;
      resolvedStyle = resolvedStyle.copyWith(color: destructiveColor);
    } else if (isHovered) {
      resolvedColor = onHoverColor;
      resolvedStyle = resolvedStyle.copyWith(color: onHoverColor);
    }

    if (!enabled) {
      final double disabledOpacity =
          theme.disabledOpacity ?? disabledOpacityOf(context);

      resolvedColor = resolvedColor.withValues(alpha: disabledOpacity);
      resolvedStyle = resolvedStyle.copyWith(
        color: resolvedStyle.color!.withValues(alpha: disabledOpacity),
      );
      resolvedSubtitleStyle = resolvedSubtitleStyle.copyWith(
        color: resolvedSubtitleStyle.color!.withValues(alpha: disabledOpacity),
      );
      if (resolvedTrailingStyle != null) {
        resolvedTrailingStyle = resolvedTrailingStyle.copyWith(
          color: resolvedTrailingStyle.color!.withValues(
            alpha: disabledOpacity,
          ),
        );
      }
    }

    Widget body =
        titleWidget ??
        Text(
          title,
          style: resolvedStyle,
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
            style: resolvedSubtitleStyle,
            textAlign: TextAlign.start,
            overflow: TextOverflow.ellipsis,
            softWrap: false,
            maxLines: maxLines,
          );

      final double gap = titleSubtitleGap ?? theme.titleSubtitleGap ?? 0;

      body = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          body,
          if (gap > 0) SizedBox(height: gap),
          subtitleContent,
        ],
      );
    }

    final bool hasIcon =
        !isInAccessibilityMode && (icon != null || iconWidget != null);

    final bool hasLeading = leading != null;
    final PullDownMenuItemIconAlignment alignmentChoice =
        iconAlignment ??
        theme.iconAlignment ??
        PullDownMenuItemIconAlignment.trailing;
    final bool iconOnLeading =
        alignmentChoice == PullDownMenuItemIconAlignment.leading;

    final Widget? menuIcon = hasIcon
        ? Padding(
          padding: EdgeInsetsDirectional.only(
            start: iconOnLeading ? 0 : theme.iconSpacing!,
            end: iconOnLeading ? theme.iconSpacing! : 0,
            top: 0,
            bottom: 0,
          ),
          child: IconBox(
            color: resolvedColor,
            size: iconSize,
            backgroundColor: iconBackgroundColor,
            borderRadius: iconBorderRadius,
            padding: iconPadding,
            child: iconWidget ?? Icon(icon),
          ),
        )
        : null;

    final Widget? trailingContent = trailing != null
        ? DefaultTextStyle(
          style: resolvedTrailingStyle ?? theme.subtitleStyle!,
          child: trailing!,
        )
        : null;

    body = Row(
      children: [
        if (hasLeading)
          DefaultTextStyle(
            style: TextStyle(color: resolvedStyle.color),
            child: leading!,
          ),
        if (menuIcon != null && iconOnLeading) menuIcon,
        Expanded(child: body),
        if (trailingContent != null) ...[
          const SizedBox(width: 8),
          trailingContent,
        ],
        if (menuIcon != null && !iconOnLeading) menuIcon,
      ],
    );

    final EdgeInsetsDirectional resolvedPadding = _itemPadding(
      theme: theme,
      itemPadding: itemPadding,
      hasLeading: hasLeading,
    );

    return AnimatedMenuContainer(
      alignment: alignment ?? AlignmentDirectional.centerStart,
      constraints: BoxConstraints(minHeight: minHeight),
      padding: resolvedPadding,
      child: body,
    );
  }
}

/// A checkmark widget.
@immutable
class _CheckmarkIcon extends StatelessWidget {
  const _CheckmarkIcon({
    required this.selected,
    required this.checkmark,
    required this.checkmarkSize,
    required this.leadingWidth,
    required this.leadingSpacing,
  });

  final IconData checkmark;
  final bool selected;
  final double checkmarkSize;
  final double leadingWidth;
  final double leadingSpacing;

  @override
  Widget build(BuildContext context) {
    final double height = checkmarkSize * 22 / 17;

    if (!selected) {
      return LeadingWidgetBox(
        height: height,
        width: leadingWidth,
        endSpacing: leadingSpacing,
      );
    }

    return LeadingWidgetBox(
      height: height,
      width: leadingWidth,
      endSpacing: leadingSpacing,
      child: Center(
        child: Text.rich(
          TextSpan(
            text: String.fromCharCode(checkmark.codePoint),
            style: TextStyle(
              fontSize: checkmarkSize,
              height: height / checkmarkSize,
              fontWeight: FontWeight.w600,
              fontFamily: checkmark.fontFamily,
              package: checkmark.fontPackage,
              textBaseline: TextBaseline.alphabetic,
            ),
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
