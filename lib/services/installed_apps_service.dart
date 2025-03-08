import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import '../constants/api_endpoints.dart';
import '../models/app_info_manifest.dart';
import '../../../services/logger_service.dart';

class InstalledAppsService with LoggerMixin {
  static const platform =
      MethodChannel('com.example.Cryptcube_mobile_app/installed_apps');

  final Dio _dio = Dio();

  Future<void> _sendToPrivacyShield(List<Map<String, dynamic>> jsonList) async {
  try {
    logInfo('Sending app data to Privacy Shield...');
    final response = await _dio.post(
      ApiEndpoints.appManifest,
      data: {'appData': jsonList},
      options: Options(
        followRedirects: true,
        validateStatus: (status) {
          return status != null && status < 500;
        },
      ),
    );
    logInfo('Privacy Shield Response Status: ${response.statusCode}');
    logDebug('Privacy Shield Response: ${response.data}');
  } on DioException catch (e, stackTrace) {
    logError('Failed to communicate with Privacy Shield', e, stackTrace);
    throw Exception('Failed to communicate with Privacy Shield');
  }
}

  Future<List<Object>> getInstalledAppsWithUsage() async {
    try {
      logInfo('Fetching installed apps with usage stats...');
      final List<dynamic> apps =
          await platform.invokeMethod('getInstalledAppsWithUsage');

      final String operatingSystem = Platform.isAndroid ? 'ANDROID' : 'MAC';
      logDebug('Detected OS: $operatingSystem');

      final List<AppInfoManifest> appList = apps
          .map((app) {
            final Map<Object?, Object?> appMap = app as Map<Object?, Object?>;
            appMap['operatingSystem'] = operatingSystem;
            return AppInfoManifest.fromMap(appMap);
          })
          .where((app) => app.usageTimeInMilliseconds.inMilliseconds > 0)
          .toList();

      logInfo('Retrieved ${appList.length} apps with usage data.');

      appList.sort((a, b) =>
          b.usageTimeInMilliseconds.compareTo(a.usageTimeInMilliseconds));

      final jsonList = appList.map((app) => app.toMap()).toList();

      logInfo('Skipping API call to Privacy Shield...');
      await _sendToPrivacyShield(jsonList);

      return jsonList;
    } on PlatformException catch (e, stackTrace) {
      if (e.code == 'PERMISSION_DENIED') {
        logInfo('⚠️ Warning: Usage stats permission required');
      }
      logError('Platform error occurred while fetching installed apps', e,
          stackTrace);
      return [];
    } catch (e, stackTrace) {
      logError('Unexpected error in getInstalledAppsWithUsage', e, stackTrace);
      return [];
    }
  }
}
