import 'dart:typed_data';
import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';

class AppIconManager {
  static final AppIconManager _instance = AppIconManager._internal();

  factory AppIconManager() {
    return _instance;
  }

  AppIconManager._internal();

  Future<Uint8List?> getAppIcon(String packageName) async {
    try {
      final app = await DeviceApps.getApp(packageName, true);
      if (app is ApplicationWithIcon) {
        return app.icon;
      }
    } catch (e) {
      print('Error getting icon for $packageName: $e');
    }
    return null;
  }

  Future<Map<String, Uint8List?>> getMultipleAppIcons(List<String> packageNames) async {
    Map<String, Uint8List?> icons = {};
    for (String packageName in packageNames) {
      icons[packageName] = await getAppIcon(packageName);
    }
    return icons;
  }

  IconData getFallbackIcon(String appName) {
    switch (appName.toLowerCase()) {
      case 'instagram':
        return Icons.camera_alt;
      case 'whatsapp':
        return Icons.chat;
      case 'facebook':
        return Icons.facebook;
      case 'youtube':
        return Icons.play_circle;
      case 'gmail':
        return Icons.mail;
      case 'chrome':
        return Icons.web;
      default:
        return Icons.android;
    }
  }
}