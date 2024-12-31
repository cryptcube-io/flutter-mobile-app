import 'package:flutter/services.dart';
import 'dart:developer' as developer;
import '../models/app_info.dart';

class InstalledAppsService {
  static const platform = MethodChannel('com.example.app/installed_apps');

  Future<List<AppInfo>> getInstalledAppsWithUsage() async {
    try {
      final List<dynamic> apps = await platform.invokeMethod('getInstalledAppsWithUsage');
      final List<AppInfo> appList = apps
          .map((app) => AppInfo.fromMap(app as Map<Object?, Object?>))
          .toList();
      
      // Sort by usage time
      appList.sort((a, b) => b.usageTime.compareTo(a.usageTime));
      
      // Log apps and their usage
      for (var app in appList) {
        print('${app.toString()}');
      }
      
      return appList;
    } on PlatformException catch (e) {
      print('Error: ${e.message}');
      return [];
    }
  }
}