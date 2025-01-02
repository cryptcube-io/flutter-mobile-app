import 'package:flutter/services.dart';

enum PermissionType {
  location,
  camera,
  microphone,
  contacts,
  storage,
  calendar,
  phone,
  sms,
  sensors,
  other  // Added for unknown permissions
}

class AppPermissionChecker {
  static const _channel = MethodChannel('app_permissions');

  static Future<Map<String, String>> getAppPermissions(String packageName) async {
    try {
      final Map<dynamic, dynamic> result = await _channel.invokeMethod('getAppPermissions', {
        'packageName': packageName
      });
      
      // Convert the result to Map<String, String>
      return Map<String, String>.from(result);
      
    } on PlatformException catch (e) {
      print('Error getting app permissions: ${e.message}');
      return {};
    }
  }

  static Future<void> printAppPermissions(String packageName) async {
    try {
      final permissions = await getAppPermissions(packageName);
      
      print('\nPermissions for $packageName:');
      print('--------------------------------');
      
      // Group permissions by their status
      Map<String, List<String>> grouped = {};
      permissions.forEach((permission, status) {
        grouped.putIfAbsent(status, () => []).add(permission);
      });
      
      // Print grouped permissions
      ['granted', 'denied', 'unknown'].forEach((status) {
        if (grouped.containsKey(status)) {
          print('\n$status:');
          for (var permission in grouped[status]!..sort()) {
            print('- $permission');
          }
        }
      });
      
    } catch (e) {
      print('Error: $e');
    }
  }
}