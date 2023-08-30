import 'package:flutter/material.dart';
import 'package:infinite_scroll_view/infinite_scroll_view.dart';

import 'jump_to_page_panel.dart';
import 'primary_button.dart';

void main() {
  runApp(
    const MaterialApp(
      home: MyApp(),
      debugShowCheckedModeBanner: false,
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final InfinitePageController controller = InfinitePageController(
    keepPage: true,
    initialPage: 10,
  );

  final GlobalKey<JumpToPagePanelState> _jumpToPageKey = GlobalKey();

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  void _onPageChanged(int index) => _jumpToPageKey.currentState?.pageChanged(index);

  void _changePage(bool isNext) => isNext
      ? controller.nextPage(
          duration: const Duration(milliseconds: 200),
          curve: Curves.ease,
        )
      : controller.previousPage(
          duration: const Duration(milliseconds: 200),
          curve: Curves.ease,
        );

  Future<void> _goToPage(int page, bool shouldAnimate) async {
    if (shouldAnimate) {
      return controller.animateToPage(
        page,
        duration: const Duration(seconds: 2),
        curve: Curves.ease,
      );
    }

    return controller.jumpToPage(page);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          InfinitePageView(
            controller: controller,
            onPageChanged: _onPageChanged,
            itemBuilder: (context, index) {
              return _Page(index: index);
            },
          ),
          Positioned(
            bottom: 24,
            right: 24,
            child: PrimaryButton(
              onTap: () => _changePage(true),
              text: "Next Page",
              borderRadius: 8.0,
              suffixIcon: Icons.navigate_next,
            ),
          ),
          Positioned(
            bottom: 24,
            left: 24,
            child: PrimaryButton(
              onTap: () => _changePage(false),
              text: "Prev Page",
              borderRadius: 8.0,
              prefixIcon: Icons.navigate_before,
            ),
          ),
          Positioned(
            bottom: 80.0,
            left: 0.0,
            right: 0.0,
            child: JumpToPagePanel(
              key: _jumpToPageKey,
              onPageIndexSelected: _goToPage,
            ),
          ),
        ],
      ),
    );
  }
}

class _Page extends StatelessWidget {
  final int index;

  const _Page({
    Key? key,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "Page $index",
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.orange,
          fontWeight: FontWeight.bold,
          fontSize: 18.0,
        ),
      ),
    );
  }
}
