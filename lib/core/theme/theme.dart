// lib/core/theme/theme.dart

import 'package:flutter/material.dart';

class AppColors {
  // Core App Colors
  static const Color primaryBlue = Color(0xFF4C7FFF); // A nice blue
  static const Color accentYellow = Color(0xFFFFB300);
  static const Color scaffoldBackgroundLight = Color(0xFFF7F7F7);
  static const Color scaffoldBackgroundDark = Color(0xFF121212);

  // Card Colors from Screenshot for reference/use
  static const Color cardProposal = Color(0xFF388E3C); // Dark Green
  static const Color cardMeeting = Color(0xFFE65100);  // Dark Orange
  static const Color cardDesign = Color(0xFFFBC02D);   // Dark Yellow

  // Opacity for Glassmorphism
  static final Color glassPrimary = primaryBlue.withValues(alpha: 0.1);
  static final Color glassSecondary = Colors.white.withValues(alpha: 0.25);

  // Status/Task Card Colors (as seen in the screenshot)
  static final Color cardColor1 = Color(0xFF4CAF50).withValues(alpha: 0.8); // Green
  static final Color cardColor2 = Color(0xFFFF9800).withValues(alpha: 0.8); // Orange
  static final Color cardColor3 = Color(0xFFFFEB3B).withValues(alpha: 0.8); // Yellow
  static final Color cardColor4 = primaryBlue.withValues(alpha: 0.8);       // Fallback/Extra
}

// Light Theme
ThemeData get lightTheme => ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primaryBlue,
        brightness: Brightness.light,
        primary: AppColors.primaryBlue,
        secondary: AppColors.accentYellow,
        surface: AppColors.scaffoldBackgroundLight,
      ),
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.scaffoldBackgroundLight,
      appBarTheme: const AppBarTheme(
        surfaceTintColor: Colors.transparent,
      ),
      dialogTheme: DialogThemeData(
        surfaceTintColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.primaryBlue,
        foregroundColor: Colors.white,
      )
    );

// Dark Theme (Basic setup, could be expanded)
ThemeData get darkTheme => ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primaryBlue,
        brightness: Brightness.dark,
        primary: AppColors.primaryBlue,
        secondary: AppColors.accentYellow,
        surface: AppColors.scaffoldBackgroundDark,
        onSurface: Colors.white,
      ),
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.scaffoldBackgroundDark,
      appBarTheme: const AppBarTheme(
        surfaceTintColor: Colors.transparent,
      ),
      dialogTheme: DialogThemeData(
        surfaceTintColor: Color(0xFF1E1E1E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.primaryBlue,
        foregroundColor: Colors.white,
      )
    );