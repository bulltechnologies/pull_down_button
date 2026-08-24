/// @docImport '/src/theme/divider_theme.dart';
/// @docImport 'actions_row.dart';
library;

import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import '/src/internals/menu_config.dart';
import '/src/theme/divider_theme.dart';

// Default values were taken from the Apple Design Resources iOS 18 Figma file.

/// A horizontal divider for a cupertino style pull-down menu.
///
/// Divider is 8px in height by default.
@immutable
class PullDownMenuDivider extends StatelessWidget {
  /// Creates a large horizontal divider for a pull-down menu.
  const PullDownMenuDivider({
    super.key,
    this.color,
    this.height,
    this.thickness,
    this.indent,
    this.endIndent,
    this.margin,
    this.dividerTheme,
  }) : child = null;

  /// Creates a custom divider with an arbitrary [child] widget.
  const PullDownMenuDivider.custom({
    super.key,
    required this.child,
    this.color,
    this.height,
    this.thickness,
    this.indent,
    this.endIndent,
    this.margin,
    this.dividerTheme,
  });

  /// The color of the divider.
  ///
  /// If this property is null, then the value from the ambient
  /// [PullDownMenuDividerTheme] is used.
  final Color? color;

  /// The height of the divider.
  ///
  /// If null, [PullDownMenuDividerTheme.dividerHeight] is used.
  final double? height;

  /// The thickness of the divider.
  ///
  /// If null, [PullDownMenuDividerTheme.dividerThickness] is used.
  final double? thickness;

  /// The leading spacing for the divider.
  ///
  /// If null, [PullDownMenuDividerTheme.indent] is used.
  final double? indent;

  /// The trailing spacing for the divider.
  ///
  /// If null, [PullDownMenuDividerTheme.endIndent] is used.
  final double? endIndent;

  /// Outer margin surrounding the divider.
  final EdgeInsetsGeometry? margin;

  /// Optional custom child widget to render as the divider.
  final Widget? child;

  /// An optional per-divider theme override.
  final PullDownMenuDividerTheme? dividerTheme;

  @override
  Widget build(BuildContext context) {
    final PullDownMenuDividerTheme theme =
        dividerTheme ?? MenuConfig.ambientThemeOf(context).dividerTheme;

    Widget result;

    if (child != null) {
      result = child!;
    } else {
      result = Divider(
        height: height ?? theme.dividerHeight,
        thickness: thickness ?? theme.dividerThickness,
        indent: indent ?? theme.indent,
        endIndent: endIndent ?? theme.endIndent,
        color: color ?? theme.color ?? theme.largeDividerColor!,
      );
    }

    final EdgeInsetsGeometry? effectiveMargin = margin ?? theme.margin;
    if (effectiveMargin != null) {
      result = Padding(
        padding: effectiveMargin,
        child: result,
      );
    }

    return result;
  }
}

/// A small divider for a cupertino style pull-down menu.
///
/// Divider is 0.5px in height by default.
@immutable
@internal
class PullDownMenuSeparator extends StatelessWidget {
  /// Creates a small divider for a pull-down menu.
  const PullDownMenuSeparator._({
    required this.axis,
  });

  /// The direction along which the divider is rendered.
  final Axis axis;

  /// Helper method that simplifies separation of pull-down menu items.
  static List<Widget> wrapVerticalList(
    List<Widget> items,
  ) {
    if (items.isEmpty || items.length == 1) {
      return items;
    }

    const PullDownMenuSeparator divider = PullDownMenuSeparator._(
      axis: Axis.horizontal,
    );
    final List<Widget> list = <Widget>[items.first];

    for (int i = 0; i < items.length - 1; i++) {
      final Widget next = items[i + 1];

      if (items[i] is PullDownMenuDivider || next is PullDownMenuDivider) {
        list.add(next);
      } else {
        list.addAll([divider, next]);
      }
    }

    return list;
  }

  /// Helper method that simplifies separation of side-by-side appearance row
  /// items for [PullDownMenuActionsRow].
  static List<Widget> wrapSideBySide(
    List<Widget> items,
  ) {
    if (items.isEmpty) {
      return items;
    } else if (items.length == 1) {
      return [Expanded(child: items.single)];
    }

    const PullDownMenuSeparator divider = PullDownMenuSeparator._(
      axis: Axis.vertical,
    );

    return [
      for (final Widget i in items.take(items.length - 1)) ...[
        Expanded(child: i),
        divider,
      ],
      Expanded(child: items.last),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final PullDownMenuDividerTheme theme =
        MenuConfig.ambientThemeOf(context).dividerTheme;
    final Color color = theme.color ?? theme.dividerColor!;

    return switch (axis) {
      Axis.horizontal => Divider(
        height: theme.separatorHeight,
        thickness: theme.separatorThickness,
        indent: theme.indent,
        endIndent: theme.endIndent,
        color: color,
      ),
      Axis.vertical => VerticalDivider(
        width: theme.separatorHeight,
        thickness: theme.separatorThickness,
        color: color,
      ),
    };
  }
}
