import 'package:flutter/material.dart';
import 'dart:math';
import 'package:dio/dio.dart';
import '../config/api_endpoints.dart';
import '../models/app_item.dart';
import '../../../services/installed_apps_service.dart';

class AppLoaderService {
  final Random random = Random();
  final InstalledAppsService _appsService = InstalledAppsService();
  final Dio _dio = Dio();

  final List<IconData> icons = [
    Icons.apps,
    Icons.android,
    Icons.phone_android,
    Icons.app_blocking,
    Icons.app_registration,
    Icons.app_settings_alt,
    Icons.toys,
    Icons.extension,
    Icons.widgets,
    Icons.dashboard,
    Icons.grid_view,
    Icons.view_module,
    Icons.web,
    Icons.web_asset,
    Icons.web_stories,
    Icons.devices,
    Icons.phone_iphone,
    Icons.tablet_android,
    Icons.laptop,
    Icons.desktop_windows
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

  Future<int> getPrivacyScore(
      String token, String appName, String appVector) async {
    try {
      final response = await _dio.get(
        ApiEndpoints.getApplicationPrivacyScore,
        queryParameters: {'appName': appName, 'appVector': appVector},
        options: Options(
            headers: {'Authorization': 'Bearer $token'},
            responseType: ResponseType.plain),
      );

      if (response.statusCode == 200) {
        return int.parse(response.data.toString());
      }
      throw DioException(
          requestOptions: response.requestOptions,
          message: 'Failed to get privacy score');
    } catch (e) {
      throw Exception('Failed to get privacy score: $e');
    }
  }

  Future<List<AppItem>> loadApps(String? token,
      {int page = 0, int pageSize = 20}) async {
    if (token == null) throw Exception('Token is required');

    final appInfoList = await _appsService.getInstalledAppsWithUsage();
    if (appInfoList.isEmpty) return [];

    final sortedApps = List<Map<String, dynamic>>.from(appInfoList)
      ..sort((a, b) => (b['usageTimeInMilliseconds'] as int)
          .compareTo(a['usageTimeInMilliseconds'] as int));

    final startIndex = page * pageSize;
    if (startIndex >= sortedApps.length) return [];

    final endIndex = min(startIndex + pageSize, sortedApps.length);
    final currentPageApps = sortedApps.sublist(startIndex, endIndex);

    List<AppItem> appItems = [];

    for (var appInfo in currentPageApps) {
      try {
        final score = await getPrivacyScore(
            token, appInfo['appName'], appInfo['packageName']);

        appItems.add(AppItem(
          name: appInfo['appName'],
          packageName: appInfo['packageName'],
          score: '$score/800',
          color:
              getRandomColor(), // You might want to remove this since we have real icons now
          iconBytes: appInfo['icon'],
        ));
      } catch (e) {
        print('Error getting score for ${appInfo['appName']}: $e');
      }
    }

    return appItems;
  }
}
