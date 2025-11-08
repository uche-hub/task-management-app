import 'package:flutter/material.dart';

class AppColors {
  // Core App Colors
  static const Color primaryBlue = Color(0xFF4C7FFF);
  static const Color accentYellow = Color(0xFFFFB300);
  static const Color scaffoldBackgroundLight = Color(0xFFF7F7F7);
  static const Color scaffoldBackgroundDark = Color(0xFF121212);

  // Card Colors
  static const Color cardProposal = Color(0xFF388E3C); // Dark Green
  static const Color cardMeeting = Color(0xFFE65100);  // Dark Orange
  static const Color cardDesign = Color(0xFFFBC02D);   // Dark Yellow

  // Status/Task Card Colors
  static final Color cardColor1 = Color(0xFF4CAF50).withValues(alpha: 0.8); // Green
  static final Color cardColor2 = Color(0xFFFF9800).withValues(alpha: 0.8); // Orange
  static final Color cardColor3 = Color(0xFFFFEB3B).withValues(alpha: 0.8); // Yellow
  static final Color cardColor4 = primaryBlue.withValues(alpha: 0.8);  // blue
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

// Dark Theme
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