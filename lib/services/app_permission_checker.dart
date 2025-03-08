import 'package:flutter/services.dart';
import 'dart:convert';
import '../models/permission_structure.dart';
import '../../../services/logger_service.dart';

class AppPermissionChecker with LoggerMixin {
  final MethodChannel _channel = const MethodChannel('app_permissions');

  Future<Map<String, String>> getAppPermissions(String packageName) async {
    try {
      logInfo('Fetching permissions for package: $packageName');
      final Map<dynamic, dynamic> result = await _channel.invokeMethod(
        'getAppPermissions',
        {'packageName': packageName},
      );

      logDebug('Permissions retrieved for $packageName: $result');
      return Map<String, String>.from(result);
    } on PlatformException catch (e, stackTrace) {
      logError('Error getting app permissions for $packageName', e, stackTrace);
      return {};
    }
  }

  void _updateStructure(Map<String, dynamic> structure, Map<String, String> permissions) {
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

  Future<void> printStructuredPermissions(String packageName) async {
    try {
      logInfo('Generating structured permissions for package: $packageName');

      final permissions = await getAppPermissions(packageName);

      logInfo('BEGIN RAW PERMISSIONS for $packageName');
      permissions.forEach((key, value) {
        logDebug('$key: $value');
      });
      logInfo('END RAW PERMISSIONS');

      final Map<String, dynamic> result =
          json.decode(json.encode(PermissionStructure.structure));

      _updateStructure(result, permissions);

      logInfo('BEGIN STRUCTURED PERMISSIONS for $packageName');
      final prettyJson = JsonEncoder.withIndent('  ').convert(result);
      const int chunkSize = 800;
      for (var i = 0; i < prettyJson.length; i += chunkSize) {
        var end = (i + chunkSize < prettyJson.length) ? i + chunkSize : prettyJson.length;
        logDebug(prettyJson.substring(i, end));
      }
      logInfo('END STRUCTURED PERMISSIONS');

    } catch (e, stackTrace) {
      logError('Error generating structured permissions for $packageName', e, stackTrace);
    }
  }
}
