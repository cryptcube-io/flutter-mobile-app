import 'package:flutter/material.dart';
import 'dart:math';
import '../models/app_item.dart';
import '../../../services/installed_apps_service.dart';

class AppLoaderService {
  final Random random = Random();
  final InstalledAppsService _appsService = InstalledAppsService();
  
  final List<IconData> icons = [
    Icons.apps, Icons.android, Icons.phone_android, Icons.app_blocking,
    Icons.app_registration, Icons.app_settings_alt, Icons.toys, Icons.extension,
    Icons.widgets, Icons.dashboard, Icons.grid_view, Icons.view_module,
    Icons.web, Icons.web_asset, Icons.web_stories, Icons.devices,
    Icons.phone_iphone, Icons.tablet_android, Icons.laptop, Icons.desktop_windows
  ];

  Color getRandomColor() {
    return Color.fromRGBO(
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
      1,
    );
  }

  IconData getRandomIcon() {
    return icons[random.nextInt(icons.length)];
  }

  Future<List<AppItem>> loadApps() async {
    print("Loading apps...");
    final appInfoList = await _appsService.getInstalledAppsWithUsage();
    print("Original list:");

    if (appInfoList.isEmpty) return [];

    final sortedApps = List<Map<String, dynamic>>.from(appInfoList)
      ..sort((a, b) => (b['usageTimeInMilliseconds'] as int)
          .compareTo(a['usageTimeInMilliseconds'] as int));

    print("Sorted list:");
    sortedApps.forEach((app) => print("${app['appName']} (${app['usageTimeInMilliseconds']} ms)"));

    return sortedApps.map((appInfo) {
      return AppItem(
        name: appInfo['appName'],
        packageName: appInfo['packageName'],
        score: '${600 + (appInfo['appName'].hashCode % 200)}/800',
        color: getRandomColor(),
        icon: getRandomIcon(),
      );
    }).toList();
  }
}