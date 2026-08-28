/// @docImport '/src/pull_down_button.dart';
library;

import 'package:flutter/cupertino.dart';

import '/src/theme/route_theme.dart';
import 'animation.dart';
import 'content_size_category.dart';
import 'item_layout.dart';
import 'menu.dart';
import 'menu_config.dart';
import 'route.dart';

/// Pull-down menu displayed by [PullDownButton] or [showPullDownMenu].
@immutable
class RoutePullDownMenu extends StatelessWidget {
  /// Creates [RoutePullDownMenu].
  const RoutePullDownMenu({
    super.key,
    required this.items,
    required this.routeTheme,
    required this.alignment,
    required this.animation,
    required this.scrollController,
  });

  /// Items to show in the menu.
  final List<Widget> items;

  /// A per-menu custom theme.
  ///
  /// Final theme is resolved using [MenuConfig.ambientThemeOf].
  final PullDownMenuRouteTheme? routeTheme;

  /// An animation provided by [PullDownMenuRoute] for scale, fade, and size
  /// transitions.
  final Animation<double> animation;

  /// The point menu scales from.
  final Alignment alignment;

  /// Is used to define the initial scroll offset of menu's body.
  final ScrollController? scrollController;

  @override
  Widget build(BuildContext context) {
    final bool isInAccessibilityMode =
        ContentSizeCategory.isInAccessibilityMode(context);

    final PullDownMenuRouteTheme theme =
        MenuConfig.ambientThemeOf(context).routeTheme;

    final List<BoxShadow> shadows =
        theme.resolvedBoxShadow ??
        (theme.shadow != null ? [theme.shadow!] : const <BoxShadow>[]);

    final DecorationTween shadowTween = DecorationTween(
      begin: ShapeDecoration(
        shape: RoundedSuperellipseBorder(borderRadius: theme.borderRadius!),
        shadows: [
          for (final BoxShadow s in shadows)
            BoxShadow(
              color: s.color.withValues(alpha: 0),
              blurRadius: s.blurRadius,
              spreadRadius: s.spreadRadius,
              offset: s.offset,
            ),
        ],
      ),
      end: ShapeDecoration(
        shape: RoundedSuperellipseBorder(borderRadius: theme.borderRadius!),
        shadows: shadows,
      ),
    );

    final ClampedAnimation clampedAnimation = ClampedAnimation(animation);

    final BoxConstraints constraints =
        theme.constraints ??
        BoxConstraints(
          minWidth:
              theme.minWidth ??
              (isInAccessibilityMode
                  ? theme.accessibilityWidth!
                  : theme.width!),
          maxWidth:
              theme.maxWidth ??
              (isInAccessibilityMode
                  ? theme.accessibilityWidth!
                  : theme.width!),
          maxHeight: theme.maxHeight ?? double.infinity,
        );

    return ScaleTransition(
      scale: animation,
      alignment: alignment,
      child: DecoratedBoxTransition(
        decoration: AnimationUtils.shadowTween
            .animate(clampedAnimation)
            .drive(shadowTween),
        child: FadeTransition(
          opacity: clampedAnimation,
          child: MenuDecoration(
            backgroundColor: theme.backgroundColor!,
            borderRadius: theme.borderRadius!,
            borderClipper: theme.borderClipper!,
            backdropBlurSigma: theme.backdropBlurSigma!,
            showBackdropFilter: theme.showBackdropFilter ?? true,
            border: theme.border,
            padding: theme.padding,
            margin: theme.margin,
            clipBehavior: theme.clipBehavior ?? Clip.antiAlias,
            containerBuilder: theme.containerBuilder,
            child: FadeTransition(
              opacity: clampedAnimation,
              child: AnimatedMenuContainer(
                constraints: constraints,
                child: SizeTransition(
                  alignment: Alignment.topCenter,
                  sizeFactor: clampedAnimation,
                  child: MenuBody(
                    scrollController: scrollController,
                    items: items,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
