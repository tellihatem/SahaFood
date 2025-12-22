import 'package:flutter/material.dart';

/// App-wide color constants
/// Following Material 3 design system with Arabic food delivery theme
class AppColors {
  // Primary Brand Colors
  static const Color primary = Color(0xFFFF7622);
  static const Color primaryDark = Color(0xFFE66610);
  static const Color primaryLight = Color(0xFFFF9F5E);
  
  // Background Colors
  static const Color background = Color(0xFFFFFFFF);
  static const Color backgroundDark = Color(0xFF1E1D2E);
  static const Color backgroundGrey = Color(0xFFF8F8F8);
  
  // Text Colors
  static const Color textPrimary = Color(0xFF32343E);
  static const Color textSecondary = Color(0xFF646982);
  static const Color textHint = Color(0xFFA0A5BA);
  static const Color textLight = Color(0xFF7E8A97);
  static const Color textOnDark = Color(0xFFFFFFFF);
  
  // Border Colors
  static const Color border = Color(0xFFEEEEEE);
  static const Color borderLight = Color(0xFFE5E5E5);
  static const Color borderFocus = primary;
  
  // Status Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFF44336);
  static const Color warning = Color(0xFFFFC107);
  static const Color info = Color(0xFF2196F3);
  
  // Neutral Colors
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  
  // Pattern/Overlay Colors
  static Color patternOverlay = Colors.white.withOpacity(0.04);
  static Color patternOverlayDark = Colors.white.withOpacity(0.03);
  static Color textOnDarkSubtle = Colors.white.withOpacity(0.8);
}
