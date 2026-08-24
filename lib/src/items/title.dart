import 'package:flutter/cupertino.dart';

import '../../pull_down_button.dart';
import '../internals/content_size_category.dart';
import '../internals/element_size.dart';
import '../internals/item_layout.dart';
import '../internals/menu_config.dart';

/// Used to configure how [PullDownMenuTitle.title] is aligned.
enum PullDownMenuTitleAlignment {
  /// [PullDownMenuTitle]'s title widget is aligned at the start edge
  /// (with applied padding).
  start,

  /// [PullDownMenuTitle]'s title widget is aligned at the center.
  center,
}

/// The optional title of the pull-down menu that is usually displayed at the
/// top of the pull-down menu.
@immutable
class PullDownMenuTitle extends StatelessWidget {
  /// Creates a title for a pull-down menu.
  const PullDownMenuTitle({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.alignment = PullDownMenuTitleAlignment.start,
    this.titleStyle,
    this.subtitleStyle,
    this.padding,
    this.margin,
    this.titleSubtitleGap,
    this.titleTheme,
  });

  /// Typically a [Text] widget with short one/two words content.
  final Widget title;

  /// Optional subtitle widget for the title entry.
  final Widget? subtitle;

  /// Optional leading widget for the title entry.
  final Widget? leading;

  /// Optional trailing widget for the title entry.
  final Widget? trailing;

  /// The alignment of [title].
  ///
  /// Defaults to [PullDownMenuTitleAlignment.start].
  final PullDownMenuTitleAlignment alignment;

  /// The text style of the title.
  ///
  /// If this property is null, then the value from the ambient
  /// [PullDownMenuTitleTheme] is used.
  final TextStyle? titleStyle;

  /// The text style of the subtitle.
  final TextStyle? subtitleStyle;

  /// Custom padding for this title entry.
  final EdgeInsetsDirectional? padding;

  /// Custom margin for this title entry.
  final EdgeInsetsGeometry? margin;

  /// Gap between title and subtitle.
  final double? titleSubtitleGap;

  /// An optional per-title theme override.
  final PullDownMenuTitleTheme? titleTheme;

  @override
  Widget build(BuildContext context) {
    final PullDownMenuTitleTheme theme =
        titleTheme ?? MenuConfig.ambientThemeOf(context).titleTheme;
    final bool hasLeading = MenuConfig.hasLeadingOf(context);
    final ContentSizeCategory contentSize = MenuConfig.contentSizeCategoryOf(
      context,
    );

    final TextStyle resolvedStyle = theme.style!.merge(titleStyle);
    final double minHeight = ElementSize.title.resolve(contentSize);
    final bool isAlignedToStart =
        alignment == PullDownMenuTitleAlignment.start;
    final bool isAlignedToLeading =
        hasLeading && isAlignedToStart && leading == null;
    final PullDownMenuItemTheme itemTheme =
        MenuConfig.ambientThemeOf(context).itemTheme;

    Widget resolvedChild = title;

    if (subtitle != null) {
      final TextStyle resolvedSubtitleStyle =
          itemTheme.subtitleStyle!.merge(subtitleStyle);
      final double gap = titleSubtitleGap ?? theme.titleSubtitleGap ?? 0;

      resolvedChild = Column(
        crossAxisAlignment:
            isAlignedToStart
                ? CrossAxisAlignment.start
                : CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          resolvedChild,
          if (gap > 0) SizedBox(height: gap),
          DefaultTextStyle(
            style: resolvedSubtitleStyle,
            child: subtitle!,
          ),
        ],
      );
    }

    if (leading != null || trailing != null || isAlignedToLeading) {
      resolvedChild = Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          if (isAlignedToLeading)
            LeadingWidgetBox(
              width: itemTheme.leadingWidth!,
              endSpacing: itemTheme.leadingSpacing!,
            )
          else if (leading != null) ...[
            leading!,
            const SizedBox(width: 8),
          ],
          Expanded(child: resolvedChild),
          if (trailing != null) ...[
            const SizedBox(width: 8),
            trailing!,
          ],
        ],
      );
    }

    final EdgeInsetsDirectional titlePadding =
        padding ??
        theme.padding ??
        EdgeInsetsDirectional.only(
          start:
              isAlignedToLeading
                  ? theme.startPaddingWithLeading!
                  : theme.startPadding!,
          top: theme.verticalPadding!,
          bottom: theme.verticalPadding!,
          end: theme.endPadding!,
        );

    final EdgeInsetsGeometry? titleMargin = margin ?? theme.margin;

    return AnimatedMenuContainer(
      constraints: BoxConstraints(minHeight: minHeight),
      padding: titlePadding,
      margin: titleMargin,
      alignment:
          isAlignedToStart
              ? AlignmentDirectional.centerStart
              : AlignmentDirectional.center,
      child: DefaultTextStyle(
        style: resolvedStyle,
        textAlign: isAlignedToStart ? TextAlign.start : TextAlign.center,
        child: resolvedChild,
      ),
    );
  }
}
