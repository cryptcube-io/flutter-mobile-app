import 'package:flutter/services.dart';
import 'dart:developer' as developer;
import 'dart:convert';
import '../models/app_info.dart';

class InstalledAppsService {
  static const platform = MethodChannel('com.example.Cryptcube_mobile_app/installed_apps');

  Future<List<AppInfo>> getInstalledAppsWithUsage() async {
    try {
      final List<dynamic> apps = await platform.invokeMethod('getInstalledAppsWithUsage');
      
      final List<AppInfo> appList = apps
          .map((app) => AppInfo.fromMap(app as Map<Object?, Object?>))
          .where((app) => app.usageTime.inMilliseconds > 0)
          .toList();

      appList.sort((a, b) => b.usageTime.compareTo(a.usageTime));

      final jsonList = appList.map((app) => app.toMap()).toList();
      developer.log(json.encode(jsonList), name: 'AppUsage');

      return appList;
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