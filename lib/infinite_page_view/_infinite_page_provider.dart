part of infinite_page_view;

enum _CurrentlyScrollingPageType { parent, past, future }

class _InfinitePageProvider extends ChangeNotifier {
  static const _animatePageDuration = Duration(milliseconds: 200);
  static const int _pastPage = 0, _futurePage = 1;

  final InfinitePageController controller;

  late final PageController parentPageController;
  late final PageController pastPageController;
  late final PageController futurePageController;

  _InfinitePageProvider._(this.controller) {
    int initialParentPage = 1;
    int initialPastPage = 0;
    int initialFuturePage = 0;

    double initialPage = controller.initialPage;
    if (initialPage != 0) {
      if (initialPage > 0) {
        //  in future
        initialFuturePage = initialPage.toInt();
      } else {
        initialParentPage = _pastPage;
        initialPastPage = (initialPage + 1).abs().toInt();
      }
    }

    parentPageController = PageController(initialPage: initialParentPage, keepPage: true, viewportFraction: 0.99);
    pastPageController = PageController(initialPage: initialPastPage, keepPage: controller.keepPage);
    futurePageController = PageController(initialPage: initialFuturePage, keepPage: controller.keepPage);

    parentPageController.addListener(_parentPageChangeListener);
    pastPageController.addListener(_pastPageChangeListener);
    futurePageController.addListener(_futurePageChangeListener);
  }

  void _parentPageChangeListener() {
    double page = (parentPageController.page ?? 0) - 1;
    controller._setPage(page);
  }

  void _pastPageChangeListener() {
    double page = ((pastPageController.page ?? 0) + 1) * -1;
    controller._setPage(page);
  }

  void _futurePageChangeListener() {
    double page = futurePageController.page ?? 0;
    controller._setPage(page);
  }

  bool _canPageSnap = true;

  _CurrentlyScrollingPageType? _currentlyScrollingPageType;

  // void onPageChanged(int index) => controller._setPage(index.toDouble());

  void onPanStart(DragStartDetails details) {
    _canPageSnap = false;
    notifyListeners();
  }

  void onPanUpdate(DragUpdateDetails details) {
    double deltaOffset = details.delta.dx;
    if (deltaOffset == 0) return;

    double? currentParentPage = parentPageController.page;
    if (deltaOffset > 0) {
      //  swipe right
      if (currentParentPage == _pastPage) {
        double newOffset = pastPageController.offset + deltaOffset;
        pastPageController.jumpTo(newOffset);
        _currentlyScrollingPageType = _CurrentlyScrollingPageType.past;
        return;
      }

      double currentFuturePage = futurePageController.page ?? 0.0;
      if (currentFuturePage > 0.0) {
        double newOffset = futurePageController.offset - deltaOffset;
        futurePageController.jumpTo(newOffset);
        _currentlyScrollingPageType = _CurrentlyScrollingPageType.future;
        return;
      }
    } else {
      //  swipe left
      if (currentParentPage == _futurePage) {
        double newOffset = futurePageController.offset - deltaOffset;
        futurePageController.jumpTo(newOffset);
        _currentlyScrollingPageType = _CurrentlyScrollingPageType.future;
        return;
      }

      double currentPastPage = pastPageController.page ?? 0.0;
      if (currentPastPage > 0.0) {
        double newOffset = pastPageController.offset + deltaOffset;
        pastPageController.jumpTo(newOffset);
        _currentlyScrollingPageType = _CurrentlyScrollingPageType.past;
        return;
      }
    }

    double newOffset = parentPageController.offset - deltaOffset;
    parentPageController.jumpTo(newOffset);
    _currentlyScrollingPageType = _CurrentlyScrollingPageType.parent;
  }

  void onPanEnd(DragEndDetails details) {
    _canPageSnap = true;
    notifyListeners();

    double swipeVelocity = details.velocity.pixelsPerSecond.dx;
    if (swipeVelocity.abs() < 1000.0) return;

    bool isSwipeLeft = swipeVelocity < 0;

    PageController controller;
    int nextPage;
    switch (_currentlyScrollingPageType) {
      case _CurrentlyScrollingPageType.past:
        int currentPage = (pastPageController.page ?? 0).toInt();
        nextPage = currentPage + (isSwipeLeft ? 0 : 1);
        controller = pastPageController;
        break;

      case _CurrentlyScrollingPageType.future:
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

  Future<void> animateToPage(int page, {required Duration duration, required Curve curve}) async {
    double currentPage = controller.page;
    if (page == currentPage) return;

    if (page >= 0) {
      //  target in future
      if (currentPage < 0) {
        //  current in past
        pastPageController.jumpToPage(0);
        parentPageController.jumpToPage(_futurePage);
      }

      if (!pastPageController.hasClients) {
        //  page controller might not be attached yet on initial load
        await Future.delayed(const Duration(milliseconds: 100));
      }
      return futurePageController.animateToPage(page, duration: duration, curve: curve);
    }

    //  target in past
    if (currentPage >= 0) {
      //  current in future
      futurePageController.jumpToPage(0);
      parentPageController.jumpToPage(_pastPage);
    }

    if (!pastPageController.hasClients) {
      //  page controller might not be attached yet on initial load
      await Future.delayed(const Duration(milliseconds: 100));
    }

    int pastPage = (page + 1).abs();
    return pastPageController.animateToPage(pastPage, duration: duration, curve: curve);
  }

  void jumpToPage(int page) {
    double currentPage = controller.page;
    if (page == currentPage) return;

    if (page >= 0) {
      //  target in future
      if (currentPage < 0) {
        //  current in past
        pastPageController.jumpToPage(0);
        parentPageController.jumpToPage(_futurePage);
      }
      return futurePageController.jumpToPage(page);
    }

    //  target in past
    if (currentPage >= 0) {
      //  current in future
      futurePageController.jumpToPage(0);
      parentPageController.jumpToPage(_pastPage);
    }

    int pastPage = (page + 1).abs();
    return pastPageController.jumpToPage(pastPage);
  }

  Future<void> nextPage({required Duration duration, required Curve curve}) async {
    double currentPage = controller.page;
    if (currentPage >= 0) {
      return futurePageController.nextPage(duration: duration, curve: curve);
    }
    if (currentPage == -1) {
      return parentPageController.nextPage(duration: duration, curve: curve);
    }
    return pastPageController.previousPage(duration: duration, curve: curve);
  }

  Future<void> previousPage({required Duration duration, required Curve curve}) async {
    double currentPage = controller.page;
    if (currentPage < 0) {
      return pastPageController.nextPage(duration: duration, curve: curve);
    }
    if (currentPage == 0) {
      return parentPageController.previousPage(duration: duration, curve: curve);
    }
    return futurePageController.previousPage(duration: duration, curve: curve);
  }

  @override
  void dispose() {
    super.dispose();

    parentPageController
      ..removeListener(_parentPageChangeListener)
      ..dispose();
    pastPageController
      ..removeListener(_pastPageChangeListener)
      ..dispose();
    futurePageController
      ..removeListener(_futurePageChangeListener)
      ..dispose();
  }
}
