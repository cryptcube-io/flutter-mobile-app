import 'package:flutter/services.dart';
import 'dart:convert';

import '../models/permission_structure.dart';

class AppPermissionChecker {
  static const _channel = MethodChannel('app_permissions');

  static Future<Map<String, String>> getAppPermissions(String packageName) async {
    try {
      final Map<dynamic, dynamic> result = await _channel.invokeMethod('getAppPermissions', {
        'packageName': packageName
      });
      return Map<String, String>.from(result);
    } on PlatformException catch (e) {
      print('Error getting app permissions: ${e.message}');
      return {};
    }
  }

  static void _updateStructure(Map<String, dynamic> structure, Map<String, String> permissions) {
    structure.forEach((key, value) {
      if (value is Map<String, dynamic>) {
        if (value.containsKey('status')) {
          if (permissions.containsKey(key)) {
            value['status'] = permissions[key];
          }
        } else {
          _updateStructure(value, permissions);
        }
      }
    });
  }

  static Future<void> printStructuredPermissions(String packageName) async {
    try {
      final permissions = await getAppPermissions(packageName);
      
      print('BEGIN RAW PERMISSIONS');
      print('Package: $packageName');
      permissions.forEach((key, value) {
        print('$key: $value');
      });
      print('END RAW PERMISSIONS\n');
      
      final Map<String, dynamic> result = json.decode(json.encode(PermissionStructure.structure));
      
      _updateStructure(result, permissions);
      
      print('BEGIN STRUCTURED PERMISSIONS');
      final prettyJson = JsonEncoder.withIndent('  ').convert(result);
      const int chunkSize = 800;
      for (var i = 0; i < prettyJson.length; i += chunkSize) {
        var end = (i + chunkSize < prettyJson.length) ? i + chunkSize : prettyJson.length;
        print(prettyJson.substring(i, end));
      }
      print('END STRUCTURED PERMISSIONS');
      
    } catch (e) {
      print('Error: $e');
    }
  }
}