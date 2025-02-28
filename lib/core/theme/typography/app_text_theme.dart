import 'package:flutter/material.dart';

class AppTextTheme {
  static TextTheme get textTheme {
    return const TextTheme(
      displayLarge: TextStyle(fontSize: 36, height: 44/36, letterSpacing: -0.02),
      displayMedium: TextStyle(fontSize: 32, height: 40/32, letterSpacing: -0.02),
      displaySmall: TextStyle(fontSize: 28, height: 36/28, letterSpacing: -0.02),
      headlineMedium: TextStyle(fontSize: 24, height: 32/24),
      headlineSmall: TextStyle(fontSize: 20, height: 28/20),
      titleLarge: TextStyle(fontSize: 16, height: 24/16),
      titleMedium: TextStyle(fontSize: 14, height: 20/14),
      titleSmall: TextStyle(fontSize: 12, height: 20/12),
      labelLarge: TextStyle(fontSize: 14, height: 16/14),
      labelMedium: TextStyle(fontSize: 12, height: 16/12),
      labelSmall: TextStyle(fontSize: 10, height: 14/10),
    );
  }
}
