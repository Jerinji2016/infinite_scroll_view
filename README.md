# Infinite Scoll View

[![pub package](https://img.shields.io/pub/v/infinite_scroll_view.svg)](https://pub.dartlang.org/packages/infinite_scroll_view) <!-- TODO: Check if fixed after publishing -->
[![codecov](https://codecov.io/gh/Jerinji2016/infinite_scroll_view/branch/master/graph/badge.svg)](https://codecov.io/gh/infinite_scroll_view)
[![Build Status](https://github.com/Jerinji2016/infinite_scroll_view/workflows/Package%20Tests/badge.svg?branch=master)](https://github.com/Jerinji2016/infinite_scroll_view/actions/workflows/flutter_tests.yaml)

A flutter library for scroll views that can be scrolled in either directions infinitely.

## Getting started

To install package go to your terminal and run

```dart
flutter pub add infinite_scroll_view
```

or add `infinite_scroll_view` to your _pubspec.yaml_

## Usage

Using InfinitePageView

```dart
InfinitePageView(
    onPageChanged: (index) {
        print('$index');
    },
    itemBuilder: (context, index) {
        return Text("Page $index");
    },
)
```

Use a controller to take control over `InfinitePageView`

```dart
final InfinitePageController controller = InfinitePageController();

// ...

InfinitePageView(
    controller: controller,
    itemBuilder: (context, index) {
        return Text("Page $index");
    },
)

```

## How it works

### InfinitePageView

Works by creating a __PageView__ with 2 pages which in turn are __PageViews__. Both PageViews are respectively controlled under the hood to get the desired working.

## TODO  

- Create InfiniteListView

## Constraints

- InfinitePageView does not support viewport fraction
