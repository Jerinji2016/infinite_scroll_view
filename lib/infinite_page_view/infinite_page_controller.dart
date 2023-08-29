part of infinite_page_view;

class InfinitePageController extends ScrollController {
  final int initialPage;
  final bool keepPage;

  InfinitePageController({
    this.initialPage = 0,
    this.keepPage = true,
  });

  late _InfinitePageProvider _provider;

  void _registerProviders(_InfinitePageProvider provider) => _provider = provider;

  late int _currentPage = initialPage;

  int get page => _currentPage;

  void _setCurrentPage(int index) => _currentPage = index;

  void animateToPage(int index, {Duration? duration, Curve curve = Curves.ease}) {

  }

  void jumpToPage(int index) {

  }
}
