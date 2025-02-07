import 'package:flutter/material.dart';

abstract class AppButtonTheme {
  static const backgroundColor = Color(0xFFEEEDFC);
  static const textColor = Color(0xFF6044de);
  static const double borderRadius = 12;
  static const padding = EdgeInsets.symmetric(vertical: 20, horizontal: 16);
  static const textStyle = TextStyle(
    color: textColor,
    fontWeight: FontWeight.w500,
  );
}