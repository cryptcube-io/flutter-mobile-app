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

  Future<bool> _sendToPrivacyShield(List<Map<String, dynamic>> jsonList) async {
  try {
    logInfo('Sending app data to Privacy Shield...');
    final response = await _dio.post(
      ApiEndpoints.appManifest,
      data: {'appData': jsonList},
      options: Options(
        followRedirects: true,
        validateStatus: (status) {
          return status == 200 || status == 201;
        },
      ),
    );
    
    logInfo('Privacy Shield Response Status: ${response.statusCode}');
    logDebug('Privacy Shield Response: ${response.data}');
    
    return true;
  } on DioException catch (e, stackTrace) {
    final statusCode = e.response?.statusCode;
    logError('Failed to communicate with Privacy Shield. Status: $statusCode', e, stackTrace);
    
    if (statusCode == 302) {
      logInfo('Privacy Shield returned a redirect response which was not followed');
    }
    
    return false;
  }
}

  Future<List<Map<String, dynamic>>> getInstalledAppsWithUsage() async {
  try {
    logInfo('Fetching installed apps with usage stats...');
    final List<dynamic> apps = await platform.invokeMethod('getInstalledAppsWithUsage');
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
    appList.sort((a, b) => b.usageTimeInMilliseconds.compareTo(a.usageTimeInMilliseconds));
    
    final jsonList = appList.map((app) => app.toMap()).toList();
    
    final success = await _sendToPrivacyShield(jsonList);
    if (success) {
      logInfo('Successfully sent app data to Privacy Shield');
    } else {
      logInfo('Failed to send app data to Privacy Shield');
    }
    
    return jsonList;
  } catch (e, stackTrace) {
    logError('Unexpected error in getInstalledAppsWithUsage', e, stackTrace);
    return [];
  }
}

  Future<void> processAndSendAppsData() async {
    try {
      final jsonList = await getInstalledAppsWithUsage();
      if (jsonList.isNotEmpty) {
        await _sendToPrivacyShield(jsonList);
      }
    } catch (e, stackTrace) {
      logError('Failed to process and send apps data', e, stackTrace);
    }
  }
}
