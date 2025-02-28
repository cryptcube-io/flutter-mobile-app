import 'package:flutter/material.dart';

class AppTextStyles {
  static TextStyle get headingH1 => const TextStyle(
    fontSize: 36,
    height: 44/36,
    letterSpacing: -0.02,
    fontWeight: FontWeight.bold,
  );

  static TextStyle get headingH2 => const TextStyle(
    fontSize: 32,
    height: 40/32,
    letterSpacing: -0.02,
    fontWeight: FontWeight.bold,
  );

  static TextStyle get headingH3 => const TextStyle(
    fontSize: 28,
    height: 36/28,
    letterSpacing: -0.02,
    fontWeight: FontWeight.bold,
  );

  static TextStyle get headingH4 => const TextStyle(
    fontSize: 24,
    height: 32/24,
    fontWeight: FontWeight.bold,
  );

  static TextStyle get headingH5 => const TextStyle(
    fontSize: 20,
    height: 28/20,
    fontWeight: FontWeight.bold,
  );

  static TextStyle get headingH6 => const TextStyle(
    fontSize: 16,
    height: 24/16,
    fontWeight: FontWeight.bold,
  );

  static TextStyle get paragraphLarge => const TextStyle(
    fontSize: 16,
    height: 24/16,
  );

  static TextStyle get paragraphMedium => const TextStyle(
    fontSize: 14,
    height: 20/14,
  );

  static TextStyle get paragraphSmall => const TextStyle(
    fontSize: 12,
    height: 20/12,
  );

  static TextStyle get labelMedium => const TextStyle(
    fontSize: 14,
    height: 16/14,
  );

  static TextStyle get labelSmall => const TextStyle(
    fontSize: 12,
    height: 16/12,
  );

  static TextStyle get labelXSmall => const TextStyle(
    fontSize: 10,
    height: 14/10,
  );
}
