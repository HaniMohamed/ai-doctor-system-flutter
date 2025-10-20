import 'package:flutter/material.dart';
import 'color_scheme.dart';
import 'text_theme.dart';
import 'component_theme.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: AppColorScheme.lightColorScheme,
      textTheme: AppTextTheme.textTheme,
      appBarTheme: ComponentTheme.appBarTheme,
      elevatedButtonTheme: ComponentTheme.elevatedButtonTheme,
      outlinedButtonTheme: ComponentTheme.outlinedButtonTheme,
      textButtonTheme: ComponentTheme.textButtonTheme,
      inputDecorationTheme: ComponentTheme.inputDecorationTheme,
      // cardTheme expects CardThemeData in newer Flutter; keep default to avoid mismatch
      bottomNavigationBarTheme: ComponentTheme.bottomNavigationBarTheme,
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: AppColorScheme.darkColorScheme,
      textTheme: AppTextTheme.textTheme,
      appBarTheme: ComponentTheme.appBarTheme,
      elevatedButtonTheme: ComponentTheme.elevatedButtonTheme,
      outlinedButtonTheme: ComponentTheme.outlinedButtonTheme,
      textButtonTheme: ComponentTheme.textButtonTheme,
      inputDecorationTheme: ComponentTheme.inputDecorationTheme,
      // cardTheme removed to avoid type mismatch; adjust ComponentTheme if needed
      // cardTheme removed to avoid type mismatch; adjust ComponentTheme if needed
      bottomNavigationBarTheme: ComponentTheme.bottomNavigationBarTheme,
    );
  }
}
