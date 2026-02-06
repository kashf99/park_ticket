import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData light() {
    final base = ThemeData.light();
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.brand,
      brightness: Brightness.light,
    );

    return base.copyWith(
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.surface,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        foregroundColor: AppColors.ink,
      ),
      textTheme: base.textTheme.copyWith(
        headlineLarge: const TextStyle(
          fontSize: 34,
          fontWeight: FontWeight.w700,
          color: AppColors.ink,
          height: 1.1,
        ),
        headlineMedium: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w700,
          color: AppColors.ink,
        ),
        titleLarge: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppColors.ink,
        ),
        titleMedium: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: AppColors.ink,
        ),
        bodyLarge: const TextStyle(
          fontSize: 16,
          color: AppColors.ink,
          height: 1.5,
        ),
        bodyMedium: const TextStyle(
          fontSize: 14,
          color: AppColors.inkMuted,
          height: 1.5,
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.card,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: const BorderSide(color: AppColors.outline),
        ),
        margin: EdgeInsets.zero,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.card,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.brand),
        ),
      ),
    );
  }
}
