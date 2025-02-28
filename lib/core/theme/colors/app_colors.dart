import 'package:flutter/material.dart';

abstract class AppColors {
  static const contentAreaBackground = Color(0xFFF3F4F6);
  static const transparent = Colors.transparent;
  static const gradientStart = Color(0xFFf0effd);
  static const gradientEnd = Color(0xFFFFFFFF);
  static const backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      gradientStart,
      gradientEnd,
    ],
  );
  
  // Text colors
  static const textPrimary = Color(0xFF000000);
  static const textSecondary = Color(0xFF6B7280);
  static const textTertiary = Color(0xFF9CA3AF);
}