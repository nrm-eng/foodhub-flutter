import 'package:flutter/material.dart';

abstract final class AppColors {
  // Primary (жовтий/бурштин)
  static const Color primary = Color(0xFFF9A825);
  static const Color primaryLight = Color(0xFFFFD54F);
  static const Color primaryDark = Color(0xFFF57F17);

  // Dark theme backgrounds
  static const Color bgDark = Color(0xFF1A1A1A);
  static const Color surfaceDark = Color(0xFF242424);
  static const Color elevatedDark = Color(0xFF2E2E2E);
  static const Color borderDark = Color(0xFF3A3A3A);

  // Light theme backgrounds
  static const Color bgLight = Color(0xFFFFFDF5);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color elevatedLight = Color(0xFFF5F5F0);
  static const Color borderLight = Color(0xFFE8E8E0);

  // Text — dark theme
  static const Color textPrimaryDark = Color(0xFFF5F5F5);
  static const Color textSecondaryDark = Color(0xFF9E9E9E);

  // Text — light theme
  static const Color textPrimaryLight = Color(0xFF1A1A1A);
  static const Color textSecondaryLight = Color(0xFF757575);

  // Semantic
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFE53935);
  static const Color warning = Color(0xFFFF9800);
}