import 'package:flutter/material.dart';

class AppColors {
  // Primary company color per requirement
  static const Color primaryColor = Color(0xFF03045E);
  static const Color primaryLight = Color(0xFF0077B6);
  static const Color accentColor = Color(0xFF00B4D8);
  static const Color highlightColor = Color(0xFF90E0EF);

  // Gradient colors
  static const List<Color> primaryGradient = [
    Color(0xFF03045E),
    Color(0xFF0077B6),
    Color(0xFF00B4D8),
  ];

  static const List<Color> accentGradient = [
    Color(0xFF00B4D8),
    Color(0xFF90E0EF),
    Color(0xFFCAF0F8),
  ];

  // Supporting colors
  static const Color backgroundColor = Color(0xFFF8F9FA);
  static const Color cardBackgroundColor = Colors.white;
  static const Color textPrimary = Color(0xFF2B2D42);
  static const Color textSecondary = Color(0xFF8D99AE);
  static const Color dividerColor = Color(0xFFEEEEEE);
  static const Color iconColor = Color(0xFF0077B6);
  static const Color cardColor = Colors.white;
  static const Color starColor = Color(0xFFFFD700);

  // Status colors
  static const Color successColor = Color(0xFF4CAF50);
  static const Color errorColor = Color(0xFFE63946);
  static const Color warningColor = Color(0xFFFF9800);
  static const Color infoColor = Color(0xFF2196F3);

  // Glass effect colors
  static const Color glassColor = Color(0x40FFFFFF);
  static Color glassBorder = Colors.white.withOpacity(0.2);
  static Color glassShadow = Colors.black.withOpacity(0.1);
}
