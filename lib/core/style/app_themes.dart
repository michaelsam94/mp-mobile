import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';

class AppThemes {
  // Light Theme
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.background,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.primary,
      titleTextStyle: TextStyle(
        color: AppColors.secondary,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      iconTheme: IconThemeData(color: AppColors.secondary),
    ),
    textTheme: TextTheme(
      headlineLarge: AppTextStyles.headlineLarge,
      headlineMedium: AppTextStyles.headlineMid,
      headlineSmall: AppTextStyles.headlineSmall,
      bodySmall: AppTextStyles.bodySmall,
      bodyMedium: AppTextStyles.bodyMid,
      bodyLarge: AppTextStyles.bodyLarge,
      titleLarge: AppTextStyles.headlineLarge,
      titleMedium: AppTextStyles.headlineMid,
      titleSmall: AppTextStyles.headlineSmall,
      displaySmall: AppTextStyles.bodySmall,
      displayMedium: AppTextStyles.bodyMid,
      displayLarge: AppTextStyles.bodyLarge,
      labelSmall: AppTextStyles.bodySmall,
      labelMedium: AppTextStyles.bodyMid,
      labelLarge: AppTextStyles.bodyLarge,
    ),
    colorScheme: ColorScheme.light(
      primary: AppColors.primary,
      secondary: AppColors.accent,
      error: AppColors.error,
      background: AppColors.background,
      surface: AppColors.secondary,
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.accent),
      ),
      labelStyle: AppTextStyles.bodyMid,
      hintStyle: AppTextStyles.bodyMid.copyWith(color: AppColors.textSecondary),
    ),
  );

  // Dark Theme
  // static final ThemeData darkTheme = ThemeData(
  //   brightness: Brightness.dark,
  //   primaryColor: AppColors.accent,
  //   scaffoldBackgroundColor: AppColors.primary,
  //   appBarTheme: const AppBarTheme(
  //     backgroundColor: AppColors.primary,
  //     titleTextStyle: TextStyle(
  //       color: AppColors.secondary,
  //       fontSize: 20,
  //       fontWeight: FontWeight.bold,
  //     ),
  //     iconTheme: IconThemeData(color: AppColors.secondary),
  //   ),
  //   textTheme: TextTheme(
  //     headlineLarge: AppTextStyles.headlineLarge.copyWith(
  //       color: AppColors.textSecondary,
  //     ),
  //     headlineMedium: AppTextStyles.headlineMid.copyWith(
  //       color: AppColors.textSecondary,
  //     ),
  //     headlineSmall: AppTextStyles.headlineSmall.copyWith(
  //       color: AppColors.textSecondary,
  //     ),
  //     bodySmall: AppTextStyles.bodySmall.copyWith(
  //       color: AppColors.textSecondary,
  //     ),
  //     bodyMedium: AppTextStyles.bodyMid.copyWith(
  //       color: AppColors.textSecondary,
  //     ),
  //     bodyLarge: AppTextStyles.bodyLarge.copyWith(
  //       color: AppColors.textSecondary,
  //     ),
  //     titleLarge: AppTextStyles.headlineLarge.copyWith(
  //       color: AppColors.textSecondary,
  //     ),
  //     titleMedium: AppTextStyles.headlineMid.copyWith(
  //       color: AppColors.textSecondary,
  //     ),
  //     titleSmall: AppTextStyles.headlineSmall.copyWith(
  //       color: AppColors.textSecondary,
  //     ),
  //     displaySmall: AppTextStyles.bodySmall.copyWith(
  //       color: AppColors.textSecondary,
  //     ),
  //     displayMedium: AppTextStyles.bodyMid.copyWith(
  //       color: AppColors.textSecondary,
  //     ),
  //     displayLarge: AppTextStyles.bodyLarge.copyWith(
  //       color: AppColors.textSecondary,
  //     ),
  //     labelSmall: AppTextStyles.bodySmall.copyWith(
  //       color: AppColors.textSecondary,
  //     ),
  //     labelMedium: AppTextStyles.bodyMid.copyWith(
  //       color: AppColors.textSecondary,
  //     ),
  //     labelLarge: AppTextStyles.bodyLarge.copyWith(
  //       color: AppColors.textSecondary,
  //     ),
  //   ),
  //   colorScheme: ColorScheme.dark(
  //     primary: AppColors.accent,
  //     secondary: AppColors.primary,
  //     error: AppColors.error,
  //     background: AppColors.primary,
  //     surface: AppColors.primary,
  //   ),
  //   inputDecorationTheme: InputDecorationTheme(
  //     border: OutlineInputBorder(
  //       borderRadius: BorderRadius.circular(12),
  //       borderSide: BorderSide(color: AppColors.textSecondary),
  //     ),
  //     enabledBorder: OutlineInputBorder(
  //       borderRadius: BorderRadius.circular(12),
  //       borderSide: BorderSide(color: AppColors.textSecondary),
  //     ),
  //     focusedBorder: OutlineInputBorder(
  //       borderRadius: BorderRadius.circular(12),
  //       borderSide: BorderSide(color: AppColors.accent),
  //     ),
  //     labelStyle: AppTextStyles.body2.copyWith(color: AppColors.textSecondary),
  //     hintStyle: AppTextStyles.body2.copyWith(
  //       color: AppColors.textSecondary.withOpacity(0.6),
  //     ),
  //   ),
  // );
}
