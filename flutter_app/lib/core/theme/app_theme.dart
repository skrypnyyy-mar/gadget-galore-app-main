import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData get lightTheme {
    final baseTextTheme = GoogleFonts.interTextTheme();
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light(
        surface: AppColors.surface, onSurface: AppColors.foreground,
        primary: AppColors.primary, onPrimary: AppColors.primaryForeground,
        secondary: AppColors.secondary, onSecondary: AppColors.secondaryForeground,
        error: AppColors.destructive, onError: AppColors.destructiveForeground,
      ),
      scaffoldBackgroundColor: AppColors.background,
      textTheme: baseTextTheme.copyWith(
        displayLarge: baseTextTheme.displayLarge?.copyWith(color: AppColors.foreground, letterSpacing: -0.02),
        displayMedium: baseTextTheme.displayMedium?.copyWith(color: AppColors.foreground, letterSpacing: -0.02),
        displaySmall: baseTextTheme.displaySmall?.copyWith(color: AppColors.foreground, letterSpacing: -0.02),
        headlineLarge: baseTextTheme.headlineLarge?.copyWith(color: AppColors.foreground, letterSpacing: -0.02),
        headlineMedium: baseTextTheme.headlineMedium?.copyWith(color: AppColors.foreground, letterSpacing: -0.02),
        headlineSmall: baseTextTheme.headlineSmall?.copyWith(color: AppColors.foreground, letterSpacing: -0.02),
        bodyLarge: baseTextTheme.bodyLarge?.copyWith(color: AppColors.foreground),
        bodyMedium: baseTextTheme.bodyMedium?.copyWith(color: AppColors.foreground),
        bodySmall: baseTextTheme.bodySmall?.copyWith(color: AppColors.mutedForeground),
      ),
      appBarTheme: const AppBarTheme(backgroundColor: AppColors.background, foregroundColor: AppColors.foreground, elevation: 0, centerTitle: false),
      cardTheme: const CardThemeData(color: AppColors.card, elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(14)), side: BorderSide(color: AppColors.border))),
      elevatedButtonTheme: ElevatedButtonThemeData(style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: AppColors.primaryForeground, elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)), padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12))),
      outlinedButtonTheme: OutlinedButtonThemeData(style: OutlinedButton.styleFrom(foregroundColor: AppColors.foreground, side: const BorderSide(color: AppColors.border), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)), padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12))),
      inputDecorationTheme: InputDecorationTheme(
        filled: true, fillColor: AppColors.background, contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: AppColors.border)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: AppColors.border)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: AppColors.ring, width: 2)),
        errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: AppColors.destructive)),
      ),
    );
  }
}
