import 'package:flutter/material.dart';
import 'package:infinite_scroll_view/infinite_scroll_view.dart';

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
  final InfinitePageController controller = InfinitePageController();

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  void _onPageChanged(int index) {
    debugPrint("_MyAppState._onPageChanged: in param: $index");
  }

  void _changePage(bool isNext) {
    debugPrint("_MyAppState._changePage: is next: $isNext");
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
              text: "Next",
              borderRadius: 8.0,
              suffixIcon: Icons.navigate_next,
            ),
          ),
          Positioned(
            bottom: 24,
            left: 24,
            child: PrimaryButton(
              onTap: () => _changePage(false),
              text: "Prev",
              borderRadius: 8.0,
              prefixIcon: Icons.navigate_before,
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
