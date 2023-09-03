library infinite_page_view;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../common/types.dart';

part '_infinite_page_provider.dart';

part 'infinite_page_controller.dart';

class InfinitePageView extends StatefulWidget {
  final InfinitePageController? controller;
  final InfinitePageBuilder itemBuilder;
  final OnPageChanged? onPageChanged;
  final bool pageSnapping;
  final DragStartBehavior dragStartBehavior;
  final ScrollBehavior? scrollBehavior;

  const InfinitePageView({
    Key? key,
    required this.itemBuilder,
    this.controller,
    this.onPageChanged,
    this.pageSnapping = true,
    this.scrollBehavior,
    this.dragStartBehavior = DragStartBehavior.start,
  }) : super(key: key);

  @override
  State<InfinitePageView> createState() => _InfinitePageViewState();
}

class _InfinitePageViewState extends State<InfinitePageView> {
  late final InfinitePageController controller = widget.controller ?? InfinitePageController();

  final ValueKey _pastPageViewKey = const ValueKey("past-page-view"),
      _futurePageViewKey = const ValueKey("future-page-view");

  void _onPageChanged(int index) {
    int actualIndex = index == 0 ? -1 : 0;
    widget.onPageChanged?.call(actualIndex);
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => _InfinitePageProvider._(this, controller),
      builder: (context, child) => Consumer<_InfinitePageProvider>(
        builder: (context, provider, child) {
          controller._registerProviders(provider);

          bool canPageSnap = provider._isPageSnapDisabled && widget.pageSnapping;

          return GestureDetector(
            onPanStart: provider.onPanStart,
            onPanUpdate: provider.onPanUpdate,
            onPanEnd: provider.onPanEnd,
            child: PageView(
              pageSnapping: canPageSnap,
              controller: provider.parentPageController,
              scrollBehavior: widget.scrollBehavior,
              physics: const NeverScrollableScrollPhysics(),
              onPageChanged: _onPageChanged,
              dragStartBehavior: widget.dragStartBehavior,
              children: [
                _NestedPageView(
                  key: _pastPageViewKey,
                  controller: provider.pastPageController,
                  reverse: true,
                  builder: widget.itemBuilder,
                  pageSnapping: widget.pageSnapping,
                  scrollBehavior: widget.scrollBehavior,
                  dragStartBehavior: widget.dragStartBehavior,
                ),
                _NestedPageView(
                  key: _futurePageViewKey,
                  controller: provider.futurePageController,
                  builder: widget.itemBuilder,
                  pageSnapping: widget.pageSnapping,
                  scrollBehavior: widget.scrollBehavior,
                  dragStartBehavior: widget.dragStartBehavior,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _NestedPageView extends StatefulWidget {
  final PageController controller;
  final bool reverse;
  final InfinitePageBuilder builder;
  final bool pageSnapping;
  final ScrollBehavior? scrollBehavior;
  final DragStartBehavior dragStartBehavior;

  const _NestedPageView({
    Key? key,
    required this.controller,
    required this.builder,
    this.reverse = false,
    required this.pageSnapping,
    required this.scrollBehavior,
    required this.dragStartBehavior,
  }) : super(key: key);

  @override
  State<_NestedPageView> createState() => _NestedPageViewState();
}

class _NestedPageViewState extends State<_NestedPageView> with AutomaticKeepAliveClientMixin {
  int _getOriginalIndex(int index) => widget.reverse ? (index + 1) * -1 : index;

  void _onPageChanged(BuildContext context, int index) {
    final int originalIndex = _getOriginalIndex(index);

    _InfinitePageViewState? state = context.findAncestorStateOfType<_InfinitePageViewState>();
    if (state == null) return;

    state.widget.onPageChanged?.call(originalIndex);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    _InfinitePageProvider infinitePageProvider = Provider.of<_InfinitePageProvider>(context);

    bool canPageSnap = infinitePageProvider._isPageSnapDisabled && widget.pageSnapping;

    return PageView.builder(
      controller: widget.controller,
      reverse: widget.reverse,
      onPageChanged: (index) => _onPageChanged(context, index),
      pageSnapping: canPageSnap,
      scrollBehavior: widget.scrollBehavior,
      dragStartBehavior: widget.dragStartBehavior,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        int originalIndex = _getOriginalIndex(index);
        return widget.builder.call(context, originalIndex);
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
