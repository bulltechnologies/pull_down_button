import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

import '/src/items/divider.dart';
import '/src/theme/route_theme.dart';
import 'blur.dart';

/// A widget used to create pull-down menu container.
@immutable
class MenuDecoration extends StatelessWidget {
  /// Creates [MenuDecoration].
  const MenuDecoration({
    super.key,
    required this.child,
    required this.backgroundColor,
    required this.borderRadius,
    required this.borderClipper,
    required this.backdropBlurSigma,
    this.showBackdropFilter = true,
    this.border,
    this.padding,
    this.margin,
    this.clipBehavior = Clip.antiAlias,
    this.containerBuilder,
  });

  /// A menu content widget.
  final Widget child;

  /// The background color of the pull-down menu.
  final Color backgroundColor;

  /// The border radius of the pull-down menu.
  final BorderRadius borderRadius;

  /// The border radius clipper of the pull-down menu.
  final PullDownMenuRouteBorderClipper borderClipper;

  /// Backdrop filter blur sigma for translucent backgrounds.
  final double backdropBlurSigma;

  /// Whether to show the backdrop filter blur.
  final bool showBackdropFilter;

  /// Optional border to draw around the menu container.
  final BoxBorder? border;

  /// Optional inner padding for the menu container.
  final EdgeInsetsGeometry? padding;

  /// Optional outer margin for the menu container.
  final EdgeInsetsGeometry? margin;

  /// Clipping behavior for the container.
  final Clip clipBehavior;

  /// Optional builder callback to morph or wrap the menu container.
  final PullDownMenuContainerBuilder? containerBuilder;

  @override
  Widget build(BuildContext context) {
    Widget box = child;

    if (padding != null) {
      box = Padding(padding: padding!, child: box);
    }

    box = ColoredBox(
      color: backgroundColor,
      child: box,
    );

    if (showBackdropFilter && BlurUtils.useBackdropFilter(backgroundColor)) {
      box = RepaintBoundary(
        child: BackdropFilter(
          filter: BlurUtils.menuBlur(context, sigma: backdropBlurSigma),
          child: box,
        ),
      );
    }

    if (border != null) {
      box = DecoratedBox(
        decoration: ShapeDecoration(
          shape: RoundedSuperellipseBorder(
            borderRadius: borderRadius,
            side: border is Border
                ? (border! as Border).top
                : BorderSide.none,
          ),
        ),
        position: DecorationPosition.foreground,
        child: box,
      );
    }

    Widget clipped = borderClipper(borderRadius, box);

    if (margin != null) {
      clipped = Padding(padding: margin!, child: clipped);
    }

    if (containerBuilder != null) {
      clipped = containerBuilder!(context, clipped);
    }

    return clipped;
  }
}

/// A widget used to create a scrollable body for pull-down menu items.
@immutable
class MenuBody extends StatefulWidget {
  /// Creates [MenuBody].
  const MenuBody({
    super.key,
    required this.items,
    required this.scrollController,
  });

  /// Items to show in the menu.
  final List<Widget> items;

  /// A scroll controller that can be used to control the scrolling of the
  /// [items] in the menu.
  final ScrollController? scrollController;

  @override
  State<MenuBody> createState() => _MenuBodyState();
}

class _MenuBodyState extends State<MenuBody> {
  late final ScrollController _scrollController;
  late final bool _ownsScrollController;

  @override
  void initState() {
    super.initState();
    _ownsScrollController = widget.scrollController == null;
    _scrollController = widget.scrollController ?? ScrollController();
  }

  @override
  void dispose() {
    if (_ownsScrollController) {
      _scrollController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Widget child = CupertinoScrollbar(
      controller: _scrollController,
      child: SingleChildScrollView(
        primary: false,
        clipBehavior: Clip.none,
        controller: _scrollController,
        child: ListBody(
          children: PullDownMenuSeparator.wrapVerticalList(widget.items),
        ),
      ),
    );

    return Semantics(
      scopesRoute: true,
      namesRoute: true,
      explicitChildNodes: true,
      label: 'Pull-Down menu',
      child: switch (defaultTargetPlatform) {
        TargetPlatform.android || TargetPlatform.iOS => child,
        _ => ScrollConfiguration(
          behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
          child: child,
        ),
      },
    );
  }
}
