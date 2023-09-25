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
        const Offset(-200, 0),
      );
      await tester.pump();
      expect(find.text('Page 1'), findsOneWidget);

      await tester.drag(
        find.byType(InfinitePageView),
        const Offset(200, 0),
      );
      await tester.pump();

      await tester.drag(
        find.byType(InfinitePageView),
        const Offset(200, 0),
      );
      await tester.pump();
      expect(find.text('Page -1'), findsOneWidget);
    });

    testWidgets("Page Snapping", (WidgetTester tester) async {
      InfinitePageController controller = InfinitePageController();
      await tester.pumpWidget(
        MaterialApp(
          home: InfinitePageView(
            controller: controller,
            itemBuilder: (context, index) => Text(
              "Page $index",
            ),
          ),
        ),
      );

      await tester.drag(
        find.byType(InfinitePageView),
        const Offset(200, 0),
      );
      await tester.pump();
      expect(
        "-0.252525",
        controller.page.toStringAsFixed(6),
        reason: "page snapping to positive value has issue",
      );
      await tester.pumpAndSettle();

      await tester.drag(
        find.byType(InfinitePageView),
        const Offset(-200, 0),
      );
      await tester.pump();
      expect(
        "0.252525",
        controller.page.toStringAsFixed(6),
        reason: "page snapping to positive value has issue",
      );
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

      controller.jumpToPage(12000);
      await tester.pump();
      expect(
        find.text('Page 12000'),
        findsOneWidget,
        reason: "controller.jumpToPage() failed for +ve page value",
      );

      controller.jumpToPage(-10000);
      await tester.pump();
      expect(
        find.text('Page -10000'),
        findsOneWidget,
        reason: "controller.jumpToPage() failed for -ve page value",
      );
    });

    testWidgets("Animate to Page", (WidgetTester tester) async {
      InfinitePageController controller = InfinitePageController();

      await tester.pumpWidget(
        MaterialApp(
          home: TestPageView(
            controller: controller,
          ),
        ),
      );

      const duration = Duration(milliseconds: 100);

      //  awaiting `animateToPage` method will block the test at this point
      controller.animateToPage(17, duration: duration, curve: Curves.ease);

      //  pump and settle since animateToPage cannot be awaited
      await tester.pumpAndSettle(duration);
      expect(
        find.text('Page 17'),
        findsOneWidget,
        reason: "controller.animateToPage() failed for +ve page value",
      );
    });

    testWidgets("Next/Previous Page", (WidgetTester tester) async {
      InfinitePageController controller = InfinitePageController();

      await tester.pumpWidget(
        MaterialApp(
          home: TestPageView(
            controller: controller,
          ),
        ),
      );

      const duration = Duration(milliseconds: 100);

      controller.nextPage(duration: duration, curve: Curves.ease);
      await tester.pumpAndSettle(duration);
      expect(find.text('Page 1'), findsOneWidget);

      controller.jumpToPage(0);
      controller.previousPage(duration: duration, curve: Curves.ease);
      await tester.pumpAndSettle(duration);
      expect(find.text('Page -1'), findsOneWidget);
    });
  });
}
