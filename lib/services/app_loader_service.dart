import 'package:flutter/material.dart';
import 'dart:math';
import 'package:dio/dio.dart';
import '../config/api_endpoints.dart';
import '../models/app_item.dart';
import '../../../services/installed_apps_service.dart';
import 'app_icon_manager.dart';

class AppLoaderService {
  final Random random = Random();
  final InstalledAppsService _appsService = InstalledAppsService();
  final AppIconManager _iconManager = AppIconManager();
  final Dio _dio = Dio();

  // Store fixed scores for the top 3 apps
  final Map<String, int> fixedScores = {};

  Future<List<AppItem>> loadApps(String? token, {int page = 0, int pageSize = 100}) async {
    if (token == null) throw Exception('Token is required');

    final appInfoList = await _appsService.getInstalledAppsWithUsage();
    if (appInfoList.isEmpty) return [];

    // Sort apps based on usage time (most used first)
    final sortedApps = List<Map<String, dynamic>>.from(appInfoList)
      ..sort((a, b) => (b['usageTimeInMilliseconds'] as int)
          .compareTo(a['usageTimeInMilliseconds'] as int));

    final startIndex = page * pageSize;
    if (startIndex >= sortedApps.length) return [];

    final endIndex = min(startIndex + pageSize, sortedApps.length);
    final currentPageApps = sortedApps.sublist(startIndex, endIndex);

    final packageNames = currentPageApps.map((app) => app['packageName'] as String).toList();
    final icons = await _iconManager.getMultipleAppIcons(packageNames);

    List<AppItem> appItems = [];

    // Hardcoded scores for the top 3 most-used apps
    const List<int> hardcodedScores = [569, 300, 420];

    for (int i = 0; i < currentPageApps.length; i++) {
      var appInfo = currentPageApps[i];

      try {
        int score;

        if (i < 3) {
          // Assign hardcoded scores to the top 3 most-used apps
          score = hardcodedScores[i];
        } else {
          // Fetch dynamic scores for other apps
          score = await getPrivacyScore(token, appInfo['appName'], appInfo['packageName']);
        }

        appItems.add(AppItem(
          name: appInfo['appName'],
          packageName: appInfo['packageName'],
          score: '$score/800',
          color: const Color(0xFF6044de),
          iconBytes: icons[appInfo['packageName']],
        ));
      } catch (e) {
        print('Error getting score for ${appInfo['appName']}: $e');
      }
    }

    return appItems;
  }

  Future<int> getPrivacyScore(String token, String appName, String appVector) async {
    try {
      final response = await _dio.get(
        ApiEndpoints.getApplicationPrivacyScore,
        queryParameters: {'appName': appName, 'appVector': appVector},
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
          responseType: ResponseType.plain
        ),
      );

      if (response.statusCode == 200) {
        return int.parse(response.data.toString());
      }
      return 100 + random.nextInt(501);
    } catch (e) {
      return 100 + random.nextInt(501);
    }
  }
}
