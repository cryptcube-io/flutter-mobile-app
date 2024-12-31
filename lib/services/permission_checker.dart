// permission_checkers.dart
import 'package:flutter/services.dart';

class PermissionChecker {
  static const _channel = MethodChannel('app_permissions');
  
  static Future<Map<String, String>> getAllStorageApps() async {
    try {
      final Map<dynamic, dynamic> result = await _channel.invokeMethod('getAllStorageApps');
      return Map<String, String>.from(result);
    } on PlatformException catch (e) {
      print('Error getting storage apps: ${e.message}');
      return {};
    }
  }

  static Future<Map<String, String>> getAllCameraApps() async {
    try {
      final Map<dynamic, dynamic> result = await _channel.invokeMethod('getAllCameraApps');
      return Map<String, String>.from(result);
    } on PlatformException catch (e) {
      print('Error getting camera apps: ${e.message}');
      return {};
    }
  }

  static Future<Map<String, String>> getAllMicrophoneApps() async {
    try {
      final Map<dynamic, dynamic> result = await _channel.invokeMethod('getAllMicrophoneApps');
      return Map<String, String>.from(result);
    } on PlatformException catch (e) {
      print('Error getting microphone apps: ${e.message}');
      return {};
    }
  }

  static Future<void> printPermissionStatus(String permissionType) async {
    try {
      Map<String, String> apps;
      String title;
      
      switch (permissionType.toLowerCase()) {
        case 'storage':
          apps = await getAllStorageApps();
          title = 'Storage';
          break;
        case 'camera':
          apps = await getAllCameraApps();
          title = 'Camera';
          break;
        case 'microphone':
          apps = await getAllMicrophoneApps();
          title = 'Microphone';
          break;
        default:
          print('Unknown permission type: $permissionType');
          return;
      }
      
      // Group apps by permission level
      Map<String, List<String>> groupedApps = {};
      
      apps.forEach((packageName, permissionLevel) {
        groupedApps.putIfAbsent(permissionLevel, () => []).add(packageName);
      });
      
      print('\nApps with $title permissions:');
      print('--------------------------------');
      
      ['allowed', 'notAllowed'].forEach((level) {
        if (groupedApps.containsKey(level) && groupedApps[level]!.isNotEmpty) {
          print('\n${level.toUpperCase()}:');
          for (var app in groupedApps[level]!..sort()) {
            print('- $app');
          }
        }
      });
      
    } catch (e) {
      print('Error: $e');
    }
  }
}