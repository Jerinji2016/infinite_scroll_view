library infinite_page_view;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../common/types.dart';

part '_infinite_page_provider.dart';
part 'infinite_page_controller.dart';

/// # InfinitePageView
///
/// Widget that works similar to [PageView] but can scroll infinitely in either sides
///
/// ***
///
/// __Under the hood:__ [InfinitePageView] uses Nested PageViews to achieve the desired working
///
/// __Warning:__ Unlike PageView this widget doesn't support viewport fraction.
///
/// ***
///
/// Found any issues?
/// Feel free to report on: https://github.com/Jerinji2016/infinite_scroll_view/issues
class InfinitePageView extends StatefulWidget {
  /// Controller to take control over [InfinitePageView]
  final InfinitePageController? controller;

  /// Each page will be build with this function
  final InfinitePageBuilder itemBuilder;

  /// Callback on page changed
  final OnPageChanged? onPageChanged;

  /// Disable page snapping, enabled by default
  final bool pageSnapping;

  /// Drag start behaviour, this value is directly passed to PageViews used in this widget
  final DragStartBehavior dragStartBehavior;

  /// ScrollBehaviour, this value is directly passed to PageViews used in this widget
  final ScrollBehavior? scrollBehavior;

  /// Axis in which the view is supposed to scroll
  final Axis scrollDirection;

  const InfinitePageView({
    Key? key,
    required this.itemBuilder,
    this.controller,
    this.onPageChanged,
    this.pageSnapping = true,
    this.scrollBehavior,
    this.scrollDirection = Axis.horizontal,
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
              scrollDirection: widget.scrollDirection,
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
                  scrollDirection: widget.scrollDirection,
                  dragStartBehavior: widget.dragStartBehavior,
                ),
                _NestedPageView(
                  key: _futurePageViewKey,
                  controller: provider.futurePageController,
                  builder: widget.itemBuilder,
                  pageSnapping: widget.pageSnapping,
                  scrollBehavior: widget.scrollBehavior,
                  scrollDirection: widget.scrollDirection,
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
  final Axis scrollDirection;

  const _NestedPageView({
    Key? key,
    required this.controller,
    required this.builder,
    this.reverse = false,
    required this.scrollDirection,
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
      scrollDirection: widget.scrollDirection,
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
