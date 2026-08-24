import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_down_button/pull_down_button.dart';

import 'example_scaffold.dart';

/// Custom theme created from [CupertinoColors.systemBlue].
///
/// [PullDownButtonTheme] parameters are assigned based on Material 3 colors for
/// [PopupMenuButton].
@immutable
class ThemingCustom extends StatelessWidget {
  const ThemingCustom({super.key});

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);

    final colorScheme = ColorScheme.fromSeed(
      seedColor: CupertinoColors.systemBlue.resolveFrom(context),
      brightness: themeData.brightness,
    );

    // For the sake of simplicity, define global theme override.
    return Theme(
      data: themeData.copyWith(
        extensions: [
          PullDownButtonTheme(
            routeTheme: PullDownMenuRouteTheme(
              backgroundColor: colorScheme.surfaceContainer,
              borderRadius: const BorderRadius.all(Radius.circular(16)),
              border: Border.all(
                color: colorScheme.outline.withValues(alpha: 0.2),
                width: 1,
              ),
              boxShadow: const [
                BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.12),
                  blurRadius: 16,
                  offset: Offset(0, 6),
                ),
              ],
              padding: const EdgeInsets.all(4),
              borderClipper:
                  (radius, child) => ClipRSuperellipse(
                    borderRadius: radius,
                    child: child,
                  ),
              width: 280,
            ),
            dividerTheme: PullDownMenuDividerTheme(
              dividerColor: colorScheme.outlineVariant,
              largeDividerColor: colorScheme.surfaceContainerHighest,
              indent: 12,
              endIndent: 12,
            ),
            itemTheme: PullDownMenuItemTheme(
              destructiveColor: colorScheme.error,
              textStyle: TextStyle(
                fontWeight: FontWeight.w500,
                color: colorScheme.onSurface,
              ),
              subtitleStyle: TextStyle(
                color: colorScheme.onSurfaceVariant,
              ),
              iconActionTextStyle: TextStyle(
                fontWeight: FontWeight.w500,
                color: colorScheme.onSurface,
              ),
              onHoverBackgroundColor: colorScheme.onSurface.withValues(
                alpha: 0.08,
              ),
              onHoverTextColor: colorScheme.onSurface,
              onPressedBackgroundColor: colorScheme.onSurface.withValues(
                alpha: 0.1,
              ),
              itemBorderRadius: const BorderRadius.all(Radius.circular(12)),
              mouseCursor: SystemMouseCursors.click,
            ),
          ),
        ],
      ),
      child: CupertinoPageScaffold(
        navigationBar: ExampleScaffoldNavigationBar(
          title: 'Custom theme',
        ),
        child: SafeArea(
          child: Center(
            child: PullDownMenu(
              items: ExampleScaffold.exampleItems(context),
            ),
          ),
        ),
      ),
    );
  }
}
