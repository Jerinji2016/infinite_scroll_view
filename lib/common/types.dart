import 'package:flutter/material.dart';

typedef OnPageChanged = void Function(int index);

typedef InfinitePageBuilder = Widget Function(BuildContext context, int index);
