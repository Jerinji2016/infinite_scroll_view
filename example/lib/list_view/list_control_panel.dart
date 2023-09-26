import 'package:example/primary_button.dart';
import 'package:flutter/material.dart';

class ListControlPanel extends StatefulWidget {
  const ListControlPanel({Key? key}) : super(key: key);

  @override
  State<ListControlPanel> createState() => _ListControlPanelState();
}

class _ListControlPanelState extends State<ListControlPanel> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      elevation: 10.0,
      borderRadius: const BorderRadius.all(
        Radius.circular(8.0),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Column(
          children: [
            PrimaryButton(
              text: "Goto Center",
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
