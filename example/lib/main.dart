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

class PrimaryButton extends StatelessWidget {
  final VoidCallback onTap;
  final Color color, suffixIconColor, prefixIconColor;
  final String text;
  final IconData? suffixIcon, prefixIcon;
  final TextStyle textStyle;
  final double? borderRadius;

  const PrimaryButton({
    Key? key,
    required this.text,
    required this.onTap,
    this.prefixIcon,
    this.prefixIconColor = Colors.white,
    this.suffixIcon,
    this.suffixIconColor = Colors.white,
    this.borderRadius,
    this.color = Colors.orange,
    TextStyle? textStyle,
  })  : textStyle = textStyle ??
            const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      borderRadius: borderRadius != null ? BorderRadius.circular(borderRadius!) : null,
      child: InkWell(
        onTap: onTap,
        borderRadius: borderRadius != null ? BorderRadius.circular(borderRadius!) : null,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            children: [
              if (prefixIcon != null) ...[
                Icon(
                  prefixIcon,
                  color: prefixIconColor,
                ),
                const SizedBox(width: 4.0),
              ],
              Text(
                text,
                style: textStyle,
              ),
              if (suffixIcon != null) ...[
                const SizedBox(width: 4.0),
                Icon(
                  suffixIcon,
                  color: suffixIconColor,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
