import 'package:flutter/material.dart';
import 'package:infinite_scroll_view/infinite_scroll_view.dart';

class TestPageView extends StatefulWidget {
  final InfinitePageController? controller;

  const TestPageView({
    Key? key,
    this.controller,
  }) : super(key: key);

  @override
  State<TestPageView> createState() => _TestPageViewState();
}

class _TestPageViewState extends State<TestPageView> {
  late final InfinitePageController controller = widget.controller ?? InfinitePageController();

  @override
  Widget build(BuildContext context) {
    return InfinitePageView(
      controller: widget.controller,
      itemBuilder: (context, index) {
        return Text("Page $index");
      },
    );
  }
}
