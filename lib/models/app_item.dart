import 'package:flutter/material.dart';

class AppItem {
  final String name;
  final String packageName;
  final String score;
  final Color color;
  final IconData icon;

  AppItem({
    required this.name,
    required this.packageName,
    required this.score,
    required this.color,
    required this.icon,
  });
}