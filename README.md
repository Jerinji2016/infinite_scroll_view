# Infinite Scoll View

[![pub package](https://img.shields.io/pub/v/infinite_scroll_view.svg)](https://pub.dartlang.org/packages/infinite_scroll_view) <!-- TODO: Check if fixed after publishing -->
[![codecov](https://codecov.io/gh/infinite_scroll_view/branch/master/graph/badge.svg?token=I5qW0RvoXN)](https://codecov.io/gh/infinite_scroll_view) <!-- TODO: Fix while doing CI/CD -->
[![Build Status](https://github.com/Baseflow/flutter_cached_network_image/workflows/app_facing_package/badge.svg?branch=develop)](https://github.com/Baseflow/flutter_cached_network_image/actions/workflows/app_facing_package.yaml) <!-- TODO: Fix while doing CI/CD -->

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

- Work on CI/CD for example app and to publish to pub
- Create InfiniteListView

## Constraints

- InfinitePageView does not support viewport fraction
