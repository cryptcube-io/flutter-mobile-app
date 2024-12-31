// location_checker.dart
import 'package:flutter/services.dart';

enum LocationPermissionLevel {
  always,
  whileInUse,
  never,
  unknown
}

class LocationPermissionChecker {
  static const _channel = MethodChannel('app_permissions');

  static Future<Map<String, String>> getAllLocationApps() async {
    try {
      final Map<dynamic, dynamic> result = await _channel.invokeMethod('getAllLocationApps');
      return Map<String, String>.from(result);
    } on PlatformException catch (e) {
      print('Error getting location apps: ${e.message}');
      return {};
    }
  }

  static Future<void> printLocationApps() async {
    try {
      final apps = await getAllLocationApps();
      
      // Group apps by permission level
      Map<String, List<String>> groupedApps = {};
      
      apps.forEach((packageName, permissionLevel) {
        groupedApps.putIfAbsent(permissionLevel, () => []).add(packageName);
      });
      
      print('\nApps with location permissions:');
      print('--------------------------------');
      
      ['always', 'whileInUse', 'never', 'unknown'].forEach((level) {
        if (groupedApps.containsKey(level) && groupedApps[level]!.isNotEmpty) {
          print('\n${level.toUpperCase()}:');
          for (var app in groupedApps[level]!) {
            print('- $app');
          }
        }
      });
      
    } catch (e) {
      print('Error: $e');
    }
  }
}