part of infinite_page_view;

enum _CurrentlyScrollingPageType { parent, past, future }

class _InfinitePageProvider extends ChangeNotifier {
  static const _animatePageDuration = Duration(milliseconds: 200);
  static const double _pastPage = 0.0, _futurePage = 1.0;

  final InfinitePageController controller;

  _InfinitePageProvider._(this.controller);

  bool _canPageSnap = true;

  _CurrentlyScrollingPageType? _currentlyScrollingPageType;

  final PageController parentPageController = PageController(initialPage: 1);
  final PageController pastPageController = PageController();
  final PageController futurePageController = PageController();

  void onPageChanged(int index) => controller._setCurrentPage(index);

  void onPanStart(DragStartDetails details) {
    _canPageSnap = false;
    notifyListeners();
  }

  void onPanUpdate(DragUpdateDetails details) {
    double deltaOffset = details.delta.dx;
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

  @override
  void dispose() {
    super.dispose();

    parentPageController.dispose();
    pastPageController.dispose();
    futurePageController.dispose();
  }
}
