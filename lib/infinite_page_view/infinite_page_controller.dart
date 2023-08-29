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

  void jumpToPage(int index) {

  }

  void animateToPage(int index) {

  }

  // int get page;
}
