import 'package:flutter/material.dart';

class AppColorScheme {
  static const Color primary = Color(0xFF2E7D32);
  static const Color primaryVariant = Color(0xFF1B5E20);
  static const Color secondary = Color(0xFF1976D2);
  static const Color secondaryVariant = Color(0xFF0D47A1);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color background = Color(0xFFF5F5F5);
  static const Color error = Color(0xFFD32F2F);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color onSecondary = Color(0xFFFFFFFF);
  static const Color onSurface = Color(0xFF000000);
  static const Color onBackground = Color(0xFF000000);
  static const Color onError = Color(0xFFFFFFFF);

  static ColorScheme get lightColorScheme {
    return const ColorScheme.light(
      primary: primary,
      primaryContainer: primaryVariant,
      secondary: secondary,
      secondaryContainer: secondaryVariant,
      surface: surface,
      error: error,
      onPrimary: onPrimary,
      onSecondary: onSecondary,
      onSurface: onSurface,
      onError: onError,
    );
  }

  static ColorScheme get darkColorScheme {
    return const ColorScheme.dark(
      primary: primary,
      primaryContainer: primaryVariant,
      secondary: secondary,
      secondaryContainer: secondaryVariant,
      surface: surface,
      surface: surface,
      error: error,
      onPrimary: onPrimary,
      onSecondary: onSecondary,
      onSurface: onSurface,
      onSurface: onSurface,
      onError: onError,
    );
  }
}
