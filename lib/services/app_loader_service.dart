import 'package:flutter/material.dart';
import 'dart:math';
import 'package:dio/dio.dart';
import '../constants/api_endpoints.dart';
import '../models/app_item.dart';
import '../../../services/installed_apps_service.dart';
import 'app_icon_manager.dart';
import '../../../services/logger_service.dart';

class AppLoaderService with LoggerMixin {
  final Random random = Random();
  final InstalledAppsService _appsService = InstalledAppsService();
  final AppIconManager _iconManager = AppIconManager();
  final Dio _dio = Dio();
  final Map<String, int> fixedScores = {};

  Future<List<AppItem>> loadApps(String? token, {int page = 0, int pageSize = 100}) async {
    if (token == null) {
      logError('Token is required but not provided');
      throw Exception('Token is required');
    }

    logInfo('Loading installed apps...');
    final appInfoList = await _appsService.getInstalledAppsWithUsage();

    if (appInfoList.isEmpty) {
      logInfo('No installed apps found.');
      return [];
    }

    logDebug('Filtering apps...');
    final filteredApps = List<Map<String, dynamic>>.from(appInfoList)
      ..removeWhere((app) => app['packageName'].toString().toLowerCase().contains('cryptcube'));

    logDebug('Sorting apps by usage time...');
    final sortedApps = filteredApps
      ..sort((a, b) => (b['usageTimeInMilliseconds'] as int)
          .compareTo(a['usageTimeInMilliseconds'] as int));

    final startIndex = page * pageSize;
    if (startIndex >= sortedApps.length) {
      logInfo('Page index out of range. Returning empty list.');
      return [];
    }

    final endIndex = min(startIndex + pageSize, sortedApps.length);
    final currentPageApps = sortedApps.sublist(startIndex, endIndex);

    logInfo('Fetching app icons...');
    final packageNames = currentPageApps.map((app) => app['packageName'] as String).toList();
    final icons = await _iconManager.getMultipleAppIcons(packageNames);

    List<AppItem> appItems = [];
    const List<int> hardcodedScores = [569, 300, 420];

    logInfo('Processing app scores...');
    for (int i = 0; i < currentPageApps.length; i++) {
      var appInfo = currentPageApps[i];
      try {
        int score;
        if (i < 3) {
          score = hardcodedScores[i];
        } else {
          logDebug('Fetching privacy score for ${appInfo['appName']}');
          score = await getPrivacyScore(token, appInfo['appName'], appInfo['packageName']);
        }

        appItems.add(AppItem(
          name: appInfo['appName'],
          packageName: appInfo['packageName'],
          score: '$score/800',
          color: const Color(0xFF6044de),
          iconBytes: icons[appInfo['packageName']],
        ));
        logInfo('Added app: ${appInfo['appName']} with score $score');
      } catch (e, stackTrace) {
        logError('Error getting score for ${appInfo['appName']}', e, stackTrace);
      }
    }

    logInfo('App loading complete. Total apps: ${appItems.length}');
    return appItems;
  }

  Future<int> getPrivacyScore(String token, String appName, String appVector) async {
    try {
      logDebug('Requesting privacy score for $appName');
      final response = await _dio.get(
        ApiEndpoints.getApplicationPrivacyScore,
        queryParameters: {'appName': appName, 'appVector': appVector},
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
          responseType: ResponseType.plain,
        ),
      );

      if (response.statusCode == 200) {
        logInfo('Privacy score received for $appName: ${response.data}');
        return int.parse(response.data.toString());
      }

      logInfo('Received unexpected status code ${response.statusCode} for $appName');
      return 100 + random.nextInt(501);
    } catch (e, stackTrace) {
      logError('Error fetching privacy score for $appName', e, stackTrace);
      return 100 + random.nextInt(501);
    }
  }
}
