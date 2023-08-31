import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:infinite_scroll_view/infinite_page_view/infinite_page_view.dart';

import 'widgets/test_page_view.dart';

void main() {
  group("Widget Tests", () {
    testWidgets('Default widget test', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: TestPageView(),
        ),
      );

      expect(find.text('Page 0'), findsOneWidget);
    });

    testWidgets("Swipe between pages", (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: TestPageView(),
        ),
      );

      expect(
        find.text('Page 0'),
        findsOneWidget,
        reason: "Failed to initialize with -ve page value",
      );

      await tester.drag(
        find.byType(InfinitePageView),
        const Offset(-200, 100),
      );
      await tester.pump();
      expect(find.text('Page 1'), findsOneWidget);

      await tester.drag(
        find.byType(InfinitePageView),
        const Offset(200, 100),
      );
      await tester.pump();

      await tester.drag(
        find.byType(InfinitePageView),
        const Offset(200, 100),
      );
      await tester.pump();
      expect(find.text('Page -1'), findsOneWidget);
    });
  });

  group("Controller Tests", () {
    test('Default controller test', () async {
      InfinitePageController controller = InfinitePageController();
      expect(controller.page, 0);
    });

    test('Controller with initial page', () async {
      InfinitePageController controller = InfinitePageController(initialPage: 8);
      expect(
        controller.page,
        8,
        reason: "Error initialising page in controller",
      );
    });
  });

  group("Integration Tests", () {
    group("Default controller integration tests", () {
      testWidgets("+ve value", (WidgetTester tester) async {
        InfinitePageController controller = InfinitePageController(initialPage: 8);
        await tester.pumpWidget(
          MaterialApp(
            home: TestPageView(
              controller: controller,
            ),
          ),
        );

        expect(
          find.text('Page 8'),
          findsOneWidget,
          reason: "Failed to initialize with -ve page value",
        );
      });

      testWidgets("-ve value", (WidgetTester tester) async {
        InfinitePageController controller2 = InfinitePageController(initialPage: -5);
        await tester.pumpWidget(
          MaterialApp(
            home: TestPageView(
              controller: controller2,
            ),
          ),
        );

        expect(
          find.text('Page -5'),
          findsOneWidget,
          reason: "Failed to initialize with -ve page value",
        );
      });
    });

    testWidgets("Jump to page", (WidgetTester tester) async {
      InfinitePageController controller = InfinitePageController();

      await tester.pumpWidget(
        MaterialApp(
          home: TestPageView(
            controller: controller,
          ),
        ),
      );

      controller.jumpToPage(12);
      await tester.pump();
      expect(
        find.text('Page 12'),
        findsOneWidget,
        reason: "controller.jumpToPage() failed for +ve page value",
      );

      controller.jumpToPage(-10);
      await tester.pump();
      expect(
        find.text('Page -10'),
        findsOneWidget,
        reason: "controller.jumpToPage() failed for -ve page value",
      );
    });

    // testWidgets("Animate to Page", (WidgetTester tester) async {
    //   InfinitePageController controller = InfinitePageController();
    //
    //   await tester.pumpWidget(
    //     MaterialApp(
    //       home: TestPageView(
    //         controller: controller,
    //       ),
    //     ),
    //   );
    //
    //   await controller.animateToPage(
    //     17,
    //     duration: const Duration(milliseconds: 100),
    //     curve: Curves.ease,
    //   );
    //   expect(
    //     find.text('Page 17'),
    //     findsOneWidget,
    //     reason: "controller.animateToPage() failed for +ve page value",
    //   );
    // });
  });
}
