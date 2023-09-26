import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_view/common/types.dart';

class InfiniteListView extends StatelessWidget {
  final InfiniteItemBuilder itemBuilder;

  final ScrollController? controller;

  final ScrollPhysics? physics;

  final Axis scrollDirection;

  final bool shrinkWrap, reverse;

  final bool? primary;

  final double? cacheExtent;

  final ScrollViewKeyboardDismissBehavior keyboardDismissBehavior;

  final ScrollBehavior? scrollBehavior;

  final int? semanticChildCount;

  final String? restorationId;

  final Clip clipBehavior;

  final double anchor;

  final DragStartBehavior dragStartBehavior;

  const InfiniteListView({
    Key? key,
    this.controller,
    this.physics,
    required this.itemBuilder,
    this.scrollDirection = Axis.vertical,
    this.shrinkWrap = false,
    this.reverse = false,
    this.primary,
    this.cacheExtent,
    this.keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.manual,
    this.scrollBehavior,
    this.semanticChildCount,
    this.restorationId,
    this.clipBehavior = Clip.hardEdge,
    this.anchor = 0.0,
    this.dragStartBehavior = DragStartBehavior.start,
  }) : super(key: key);

  final Key _centerKey = const ValueKey('center-key');

  List<Widget> _buildSlivers() {
    SliverList past = SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          int actualIndex = (index + 1) * -1;
          return itemBuilder.call(context, actualIndex);
        },
      ),
    );

    SliverList future = SliverList(
      key: _centerKey,
      delegate: SliverChildBuilderDelegate(
        (context, index) => itemBuilder.call(context, index),
      ),
    );

    return [past, future];
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      center: _centerKey,
      controller: controller,
      physics: physics,
      scrollDirection: scrollDirection,
      shrinkWrap: shrinkWrap,
      reverse: reverse,
      primary: primary,
      cacheExtent: cacheExtent,
      keyboardDismissBehavior: keyboardDismissBehavior,
      scrollBehavior: scrollBehavior,
      semanticChildCount: semanticChildCount,
      restorationId: restorationId,
      clipBehavior: clipBehavior,
      anchor: anchor,
      dragStartBehavior: dragStartBehavior,
      slivers: _buildSlivers(),
    );
  }
}
