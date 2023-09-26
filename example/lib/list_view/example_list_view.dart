import 'package:flutter/material.dart';
import 'package:infinite_scroll_view/infinite_scroll_view.dart';

import 'list_control_panel.dart';

class ExampleListView extends StatefulWidget {
  const ExampleListView({Key? key}) : super(key: key);

  @override
  State<ExampleListView> createState() => _ExampleListViewState();
}

class _ExampleListViewState extends State<ExampleListView> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        InfiniteListView(
          itemBuilder: (BuildContext context, int index) {
            Color color = Colors.primaries[index % Colors.primaries.length];

            return Material(
              color: color,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Center(
                  child: Text("Item - $index"),
                ),
              ),
            );
          },
        ),
        const Positioned(
          bottom: 16.0,
          left: 16.0,
          right: 16.0,
          child: ListControlPanel(),
        ),
      ],
    );
  }
}
