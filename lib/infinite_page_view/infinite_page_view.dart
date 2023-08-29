library infinite_page_view;

import 'package:flutter/material.dart';
import 'package:infinite_scroll_view/common/types.dart';
import 'package:provider/provider.dart';

part '_infinite_page_provider.dart';
part 'infinite_page_controller.dart';

class InfinitePageView extends StatefulWidget {
  final InfinitePageController? controller;
  final InfinitePageBuilder itemBuilder;
  final OnPageChanged? onPageChanged;

  const InfinitePageView({
    Key? key,
    required this.itemBuilder,
    this.controller,
    this.onPageChanged,
  }) : super(key: key);

  @override
  State<InfinitePageView> createState() => _InfinitePageViewState();
}

class _InfinitePageViewState extends State<InfinitePageView> {
  late final InfinitePageController controller = widget.controller ?? InfinitePageController();
  late _InfinitePageProvider _provider;

  void _onPageChanged(int index) {
    int actualIndex = index == 0 ? -1 : 0;
    _provider.onPageChanged(actualIndex);

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
      create: (context) => _InfinitePageProvider._(controller),
      builder: (context, child) => Consumer<_InfinitePageProvider>(
        builder: (context, provider, child) {
          _provider = provider;
          controller._registerProviders(provider);

          return GestureDetector(
            onPanStart: provider.onPanStart,
            onPanUpdate: provider.onPanUpdate,
            onPanEnd: provider.onPanEnd,
            child: PageView(
              pageSnapping: provider._canPageSnap,
              controller: provider.parentPageController,
              scrollBehavior: const MaterialScrollBehavior(),
              physics: const NeverScrollableScrollPhysics(),
              onPageChanged: _onPageChanged,
              children: [
                _NestedPageView(
                  controller: provider.pastPageController,
                  reverse: true,
                  builder: widget.itemBuilder,
                ),
                _NestedPageView(
                  controller: provider.futurePageController,
                  builder: widget.itemBuilder,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _NestedPageView extends StatelessWidget {
  final PageController controller;
  final bool reverse;
  final InfinitePageBuilder builder;

  const _NestedPageView({
    Key? key,
    required this.controller,
    required this.builder,
    this.reverse = false,
  }) : super(key: key);

  int _getOriginalIndex(int index) => reverse ? (index + 1) * -1 : index;

  void _onPageChanged(BuildContext context, int index) {
    final int originalIndex = _getOriginalIndex(index);

    Provider.of<_InfinitePageProvider>(context, listen: false).onPageChanged(originalIndex);

    _InfinitePageViewState? state = context.findAncestorStateOfType<_InfinitePageViewState>();
    if (state == null) return;

    state.widget.onPageChanged?.call(originalIndex);
  }

  @override
  Widget build(BuildContext context) {
    _InfinitePageProvider infinitePageProvider = Provider.of<_InfinitePageProvider>(context);

    return PageView.builder(
      controller: controller,
      reverse: reverse,
      onPageChanged: (index) => _onPageChanged(context, index),
      pageSnapping: infinitePageProvider._canPageSnap,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        int originalIndex = _getOriginalIndex(index);
        return builder.call(context, originalIndex);
      },
    );
  }
}
