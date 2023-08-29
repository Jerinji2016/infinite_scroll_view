library infinite_scroll_view;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

typedef OnPageChangeChanged = void Function(int index);

class InfinitePageController extends ScrollController {
  final int initialPage;
  final bool keepPage;

  InfinitePageController({
    this.initialPage = 0,
    this.keepPage = true,
  });
}

enum CurrentlyScrollingPageType { parent, past, future }

class InfinitePageProvider extends ChangeNotifier {
  static const _animatePageDuration = Duration(milliseconds: 200);
  static const double pastPage = 0.0, futurePage = 1.0;

  bool canPageSnap = true;

  CurrentlyScrollingPageType? currentlyScrollingPageType;

  final PageController parentPageController = PageController(initialPage: 1);
  final PageController pastPageController = PageController();
  final PageController futurePageController = PageController();

  void onPageChanged(int index) {
    debugPrint("InfinitePageProvider.onPageChanged: $index");
  }

  void onPanStart(DragStartDetails details) {
    canPageSnap = false;
    notifyListeners();
  }

  void onPanUpdate(DragUpdateDetails details) {
    double deltaOffset = details.delta.dx;
    double? currentParentPage = parentPageController.page;

    if (deltaOffset > 0) {
      //  swipe right
      if (currentParentPage == pastPage) {
        double newOffset = pastPageController.offset + deltaOffset;
        pastPageController.jumpTo(newOffset);
        currentlyScrollingPageType = CurrentlyScrollingPageType.past;
        return;
      }

      double currentFuturePage = futurePageController.page ?? 0.0;
      if (currentFuturePage > 0.0) {
        double newOffset = futurePageController.offset - deltaOffset;
        futurePageController.jumpTo(newOffset);
        currentlyScrollingPageType = CurrentlyScrollingPageType.future;
        return;
      }
    } else {
      //  swipe left
      if (currentParentPage == futurePage) {
        double newOffset = futurePageController.offset - deltaOffset;
        futurePageController.jumpTo(newOffset);
        currentlyScrollingPageType = CurrentlyScrollingPageType.future;
        return;
      }

      double currentPastPage = pastPageController.page ?? 0.0;
      if (currentPastPage > 0.0) {
        double newOffset = pastPageController.offset + deltaOffset;
        pastPageController.jumpTo(newOffset);
        currentlyScrollingPageType = CurrentlyScrollingPageType.past;
        return;
      }
    }

    double newOffset = parentPageController.offset - deltaOffset;
    parentPageController.jumpTo(newOffset);
    currentlyScrollingPageType = CurrentlyScrollingPageType.parent;
  }

  void onPanEnd(DragEndDetails details) {
    canPageSnap = true;
    notifyListeners();

    double swipeVelocity = details.velocity.pixelsPerSecond.dx;
    if (swipeVelocity.abs() < 1000.0) return;

    bool isSwipeLeft = swipeVelocity < 0;

    PageController controller;
    int nextPage;
    switch (currentlyScrollingPageType) {
      case CurrentlyScrollingPageType.past:
        int currentPage = (pastPageController.page ?? 0).toInt();
        nextPage = currentPage + (isSwipeLeft ? 0 : 1);
        controller = pastPageController;
        break;

      case CurrentlyScrollingPageType.future:
        int currentPage = (futurePageController.page ?? 0).toInt();
        nextPage = currentPage + (isSwipeLeft ? 1 : 0);
        controller = futurePageController;
        break;

      default:
        nextPage = isSwipeLeft ? 1 : 0;
        controller = parentPageController;
    }
    controller.animateToPage(
      nextPage,
      duration: _animatePageDuration,
      curve: Curves.ease,
    );
  }

  @override
  void dispose() {
    super.dispose();

    parentPageController.dispose();
    pastPageController.dispose();
    futurePageController.dispose();
  }
}

class InfinitePageView extends StatefulWidget {
  const InfinitePageView({Key? key}) : super(key: key);

  @override
  State<InfinitePageView> createState() => _InfinitePageViewState();
}

class _InfinitePageViewState extends State<InfinitePageView> {
  void _onPageChanged(int index) {
    debugPrint("_InfinitePageViewState._onPageChanged: parent: $index");
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => InfinitePageProvider(),
      builder: (context, child) => Consumer<InfinitePageProvider>(
        builder: (context, provider, child) {
          return GestureDetector(
            onPanStart: provider.onPanStart,
            onPanUpdate: provider.onPanUpdate,
            onPanEnd: provider.onPanEnd,
            child: PageView(
              pageSnapping: provider.canPageSnap,
              controller: provider.parentPageController,
              scrollBehavior: const MaterialScrollBehavior(),
              physics: const NeverScrollableScrollPhysics(),
              onPageChanged: _onPageChanged,
              children: [
                NestedPageView(
                  controller: provider.pastPageController,
                  reverse: true,
                ),
                NestedPageView(
                  controller: provider.futurePageController,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class NestedPageView extends StatelessWidget {
  final PageController controller;
  final bool reverse;

  const NestedPageView({
    Key? key,
    required this.controller,
    this.reverse = false,
  }) : super(key: key);

  void _onPageChanged(int index) {
    debugPrint("NestedPageView._onPageChanged: nested: $index");
  }

  @override
  Widget build(BuildContext context) {
    InfinitePageProvider infinitePageProvider = Provider.of<InfinitePageProvider>(context);
    return PageView.builder(
      controller: controller,
      reverse: reverse,
      onPageChanged: _onPageChanged,
      pageSnapping: infinitePageProvider.canPageSnap,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final int originalIndex = reverse ? (index + 1) * -1 : index;

        return _Page(
          index: originalIndex,
          isPast: reverse,
        );
      },
    );
  }
}

class _Page extends StatelessWidget {
  final int index;
  final bool isPast;

  const _Page({
    Key? key,
    required this.index,
    required this.isPast,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MaterialColor color = isPast ? Colors.grey : Colors.blue;
    int colorIndex = (index.abs() * 100) % 900;
    return Container(
      color: color[colorIndex],
      child: Center(
        child: Text(
          "${isPast ? "PAST" : "FUTURE"}\nIndex $index",
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.bold,
            fontSize: 18.0,
          ),
        ),
      ),
    );
  }
}
