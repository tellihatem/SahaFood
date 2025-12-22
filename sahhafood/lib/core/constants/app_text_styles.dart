import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'app_colors.dart';

/// App-wide text style constants
/// Uses Tajawal font for Arabic RTL support
class AppTextStyles {
  // Display Styles (Large headings)
  static TextStyle displayLarge = TextStyle(
    fontSize: 32.sp,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    fontFamily: 'Tajawal',
  );
  
  static TextStyle displayMedium = TextStyle(
    fontSize: 28.sp,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    fontFamily: 'Tajawal',
  );
  
  // Headline Styles
  static TextStyle headlineLarge = TextStyle(
    fontSize: 24.sp,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    fontFamily: 'Tajawal',
  );
  
  static TextStyle headlineMedium = TextStyle(
    fontSize: 20.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    fontFamily: 'Tajawal',
  );
  
  static TextStyle headlineSmall = TextStyle(
    fontSize: 18.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    fontFamily: 'Tajawal',
  );
  
  // Title Styles
  static TextStyle titleLarge = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    fontFamily: 'Tajawal',
  );
  
  static TextStyle titleMedium = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
    fontFamily: 'Tajawal',
  );
  
  static TextStyle titleSmall = TextStyle(
    fontSize: 12.sp,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
    fontFamily: 'Tajawal',
  );
  
  // Body Styles
  static TextStyle bodyLarge = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
    fontFamily: 'Tajawal',
  );
  
  static TextStyle bodyMedium = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
    fontFamily: 'Tajawal',
  );
  
  static TextStyle bodySmall = TextStyle(
    fontSize: 12.sp,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    fontFamily: 'Tajawal',
  );
  
  // Label Styles (for buttons, chips, etc.)
  static TextStyle labelLarge = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    fontFamily: 'Tajawal',
  );
  
  static TextStyle labelMedium = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
    fontFamily: 'Tajawal',
  );
  
  static TextStyle labelSmall = TextStyle(
    fontSize: 12.sp,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
    fontFamily: 'Tajawal',
  );
  
  // Special Styles
  static TextStyle buttonText = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.white,
    fontFamily: 'Tajawal',
  );
  
  static TextStyle caption = TextStyle(
    fontSize: 12.sp,
    fontWeight: FontWeight.w400,
    color: AppColors.textHint,
    fontFamily: 'Tajawal',
  );
  
  static TextStyle overline = TextStyle(
    fontSize: 10.sp,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
    fontFamily: 'Tajawal',
    letterSpacing: 0.5,
  );
}
