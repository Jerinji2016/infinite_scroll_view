part of infinite_page_view;

class InfinitePageController extends ScrollController {
  /// The page to show when first creating the [PageView].
  final int initialPage;

  /// Provides this param to all [PageView] used in [InfinitePageView]
  final bool keepPage;

  InfinitePageController({
    this.initialPage = 0,
    this.keepPage = true,
  });

  late _InfinitePageProvider _provider;

  void _registerProviders(_InfinitePageProvider provider) => _provider = provider;

  late int _currentPage = initialPage;

  /// The current page displayed in the controlled [InfinitePageView].
  int get page => _currentPage;

  void _setCurrentPage(int index) {
    _currentPage = index;
    notifyListeners();
  }

  /// Animates the controlled [InfinitePageView] from the current page to the given page.
  ///
  /// The animation lasts for the given duration and follows the given curve.
  /// The returned [Future] resolves when the animation completes.
  ///
  /// The `duration` and `curve` arguments must not be null.
  Future<void> animateToPage(int page, {required Duration duration, required Curve curve}) =>
      _provider.animateToPage(page, duration: duration, curve: curve);

  /// Changes which page is displayed in the controlled [InfinitePageView].
  ///
  /// Jumps the page position from its current value to the given value,
  /// without animation, and without checking if the new value is in range.
  void jumpToPage(int page) => _provider.jumpToPage(page);

  /// Animates the controlled [InfinitePageView] to the next page.
  ///
  /// The animation lasts for the given duration and follows the given curve.
  /// The returned [Future] resolves when the animation completes.
  ///
  /// The `duration` and `curve` arguments must not be null.
  Future<void> nextPage({required Duration duration, required Curve curve}) =>
      _provider.nextPage(duration: duration, curve: curve);

  /// Animates the controlled [InfinitePageView] to the previous page.
  ///
  /// The animation lasts for the given duration and follows the given curve.
  /// The returned [Future] resolves when the animation completes.
  ///
  /// The `duration` and `curve` arguments must not be null.
  Future<void> previousPage({required Duration duration, required Curve curve}) =>
      _provider.previousPage(duration: duration, curve: curve);
}
