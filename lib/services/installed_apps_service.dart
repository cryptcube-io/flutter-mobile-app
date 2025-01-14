import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'dart:developer' as developer;
import 'dart:convert';
import 'dart:io';
import '../config/api_endpoints.dart';
import '../models/app_info.dart';

class InstalledAppsService {
  static const platform =
      MethodChannel('com.example.Cryptcube_mobile_app/installed_apps');

  final Dio _dio = Dio();

  Future<void> _sendToPrivacyShield(List<Map<String, dynamic>> jsonList) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.appManifest,
        data: {'appData': jsonList},
      );

      developer.log('Privacy Shield Response Status: ${response.statusCode}', name: 'AppUsage');
      developer.log('Privacy Shield Response: ${response.data}', name: 'AppUsage');
    } on DioException catch (e) {
      developer.log('Privacy Shield error: ${e.message}', name: 'AppUsage', error: e);
      throw Exception('Failed to communicate with Privacy Shield');
    }
  }

  Future<List<Object>> getInstalledAppsWithUsage() async {
    try {
      final List<dynamic> apps =
          await platform.invokeMethod('getInstalledAppsWithUsage');

      final String operatingSystem = Platform.isAndroid ? 'ANDROID' : 'MAC';

      final List<AppInfo> appList = apps
          .map((app) {
            final Map<Object?, Object?> appMap = app as Map<Object?, Object?>;
            appMap['operatingSystem'] = operatingSystem;
            return AppInfo.fromMap(appMap);
          })
          .where((app) => app.usageTimeInMilliseconds.inMilliseconds > 0)
          .toList();

      appList.sort((a, b) =>
          b.usageTimeInMilliseconds.compareTo(a.usageTimeInMilliseconds));

      final jsonList = appList.map((app) => app.toMap()).toList();
      // developer.log(json.encode(jsonList), name: 'AppUsage');

      // _sendToPrivacyShield(jsonList);

      return jsonList;
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        developer.log('Usage stats permission required', name: 'AppUsage');
      }
      developer.log('Error: ${e.message}', name: 'AppUsage', error: e);
      return [];
    } catch (e) {
      developer.log('Unexpected error: $e', name: 'AppUsage', error: e);
      return [];
    }
  }
}
