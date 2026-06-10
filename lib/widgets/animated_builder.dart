import 'package:flutter/material.dart';

/// Reusable AnimatedWidget builder helper.
/// Named WallVerseAnimatedBuilder to avoid conflict with Flutter's built-in AnimatedBuilder.
class WallVerseAnimatedBuilder extends AnimatedWidget {
  final Widget Function(BuildContext, Widget?) builder;
  final Widget? child;

  const WallVerseAnimatedBuilder({
    super.key,
    required Animation<double> animation,
    required this.builder,
    this.child,
  }) : super(listenable: animation);

  @override
  Widget build(BuildContext context) {
    return builder(context, child);
  }
}
