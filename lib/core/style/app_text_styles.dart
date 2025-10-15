import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppTextStyles {
  static const TextStyle headlineLarge = TextStyle(
    fontSize: 35.0,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    letterSpacing: 0.2,
  );
  static const TextStyle headlineMid = TextStyle(
    fontSize: 30.0,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );
  static const TextStyle headlineSmall = TextStyle(
    fontSize: 24.0,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 18.0,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
  );
  static const TextStyle bodyMid = TextStyle(
    fontSize: 16.0,
    color: AppColors.textSecondary,
  );
  static const TextStyle bodySmall = TextStyle(
    fontSize: 14.0,
    color: AppColors.textSecondary,
  );
}
