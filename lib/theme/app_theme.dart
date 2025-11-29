import 'package:flutter/material.dart';

class AppTheme {
  static final double outlineAlpha = 0.2;
  static final Color success = Colors.green;
  static final Color seedColor = Color.fromARGB(255, 38, 116, 2);
  static final ColorScheme colorScheme = ColorScheme.fromSeed(
    seedColor: seedColor,
  );
  static final error = colorScheme.error;
  static final double inputDecorationThemeFillColorAlpha = 0.05;
  static final outlineBorderColor = colorScheme.outline.withValues(
    alpha: outlineAlpha,
  );

  static final baseThemeData = ThemeData(
    useMaterial3: true,
    fontFamily: 'Roboto',
    colorScheme: colorScheme.copyWith(brightness: Brightness.light),
    buttonTheme: ButtonThemeData(height: 44),
    inputDecorationTheme: InputDecorationTheme(
      isDense: true,
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: BorderSide(color: colorScheme.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: BorderSide(color: colorScheme.error),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: BorderSide(
          color: colorScheme.outline.withValues(alpha: outlineAlpha),
        ),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: BorderSide(
          color: colorScheme.outline.withValues(alpha: outlineAlpha),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: BorderSide(color: colorScheme.primary, width: 1),
      ),
      filled: true,
      fillColor: colorScheme.secondary.withValues(
        alpha: inputDecorationThemeFillColorAlpha,
      ),
    ),
  );

  static ThemeData light() => baseThemeData.copyWith(
    colorScheme: colorScheme.copyWith(brightness: Brightness.light),
  );

  static ThemeData dark() => baseThemeData.copyWith(
    colorScheme: colorScheme.copyWith(brightness: Brightness.dark),
  );
}
