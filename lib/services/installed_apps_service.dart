import 'package:flutter/services.dart';
import 'dart:developer' as developer;
import '../models/app_info.dart';

class InstalledAppsService {
  static const platform = MethodChannel('com.example.app/installed_apps');

  Future<List<AppInfo>> getInstalledApps() async {
    try {
      final List<dynamic> apps = await platform.invokeMethod('getInstalledApps');
      return apps.map((app) => AppInfo.fromMap(app as Map<Object?, Object?>)).toList();
    } on PlatformException catch (e) {
      developer.log('Error getting installed apps: ${e.message}', name: 'InstalledAppsService');
      return [];
    }
  }
}