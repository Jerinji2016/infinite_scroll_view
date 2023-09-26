import 'package:example/list_view/example_list_view.dart';
import 'package:example/page_view/example_page_view.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_view/infinite_scroll_view.dart';

import 'page_view/jump_to_page_panel.dart';
import 'primary_button.dart';

void main() {
  runApp(
    const MaterialApp(
      home: ExampleApp(),
      debugShowCheckedModeBanner: false,
    ),
  );
}

class ExampleApp extends StatefulWidget {
  const ExampleApp({Key? key}) : super(key: key);

  @override
  State<ExampleApp> createState() => _ExampleAppState();
}

class _ExampleAppState extends State<ExampleApp> with TickerProviderStateMixin {
  late final TabController controller = TabController(length: 2, vsync: this);

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  Widget _getTabHeader(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Text(text),
    );
  }

  Widget _getTabBarView(int index) {
    switch (index) {
      case 0:
        return const ExamplePageView();
      case 1:
      default:
        return const ExampleListView();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            TabBar(
              controller: controller,
              automaticIndicatorColorAdjustment: true,
              labelStyle: const TextStyle(
                color: Colors.orange,
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
              indicatorColor: Colors.orange,
              labelColor: Colors.orange,
              unselectedLabelColor: Colors.grey[300]!,
              unselectedLabelStyle: const TextStyle(
                color: Colors.red,
                fontSize: 14.0,
              ),
              tabs: [
                _getTabHeader("Page"),
                _getTabHeader("List"),
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: controller,
                children: [
                  _getTabBarView(0),
                  _getTabBarView(1),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
