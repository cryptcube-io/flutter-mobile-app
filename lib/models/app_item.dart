import 'package:flutter/material.dart';
import 'dart:typed_data';

class AppItem {
  final String name;
  final String packageName;
  final String score;
  final Color color;
  final Uint8List? iconBytes;  // Make it optional

  AppItem({
    required this.name,
    required this.packageName,
    required this.score,
    required this.color,
    this.iconBytes,  // Optional parameter
  });
}