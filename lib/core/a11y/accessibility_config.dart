import 'package:flutter/material.dart';

class AccessibilityConfig extends StatelessWidget {
  final Widget child;
  final double minTextScale;
  final double maxTextScale;

  const AccessibilityConfig({
    super.key,
    required this.child,
    this.minTextScale = 1.0,
    this.maxTextScale = 2.0,
  });

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final clampedScale = mediaQuery.textScaleFactor.clamp(minTextScale, maxTextScale);
    return MediaQuery(
      data: mediaQuery.copyWith(textScaleFactor: clampedScale),
      child: child,
    );
  }
}


