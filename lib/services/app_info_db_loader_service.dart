import 'package:Cryptcube_mobile_app/constants/api_endpoints.dart';
import 'package:dio/dio.dart';
import 'package:hive/hive.dart';
import 'dart:developer' as developer;
import '../models/app_info_database.dart';
import 'installed_apps_service.dart';

class AppInfoDbLoaderService {
  final InstalledAppsService _installedAppsService = InstalledAppsService();
  final Dio _dio = Dio();
  late Box<AppInfoEntity> _appPrivacyBox;

  static const String _authToken = 'eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJzYW5rZXQua29yZ2FvbmthckBwcm90b25tYWlsMTAxLmNvbSIsImlhdCI6MTczNzA0ODEyNywiZXhwIjoxNzM4MzQ0MTI3fQ.pX8ZmWA6dQqIyYLWfj-7nO_vpTZME66ck9bwJ-wYsto';

  Future<void> init() async {
    try {
      _appPrivacyBox = await Hive.openBox<AppInfoEntity>('app_privacy');
      developer.log('AppPrivacyService initialized successfully', name: 'AppPrivacy');
    } catch (e) {
      developer.log('Failed to initialize AppPrivacyService: $e', name: 'AppPrivacy');
      rethrow;
    }
  }

  Future<void> clearExistingData() async {
    try {
      await _appPrivacyBox.clear();
      developer.log('Cleared existing app privacy data', name: 'AppPrivacy');
    } catch (e) {
      developer.log('Error clearing app privacy data: $e', name: 'AppPrivacy');
      rethrow;
    }
  }

  bool _isAppDataUnique(String packageName) {
    return !_appPrivacyBox.containsKey(packageName);
  }

  Future<String> _getPrivacyScore(String appName, String appVector) async {
    try {
      final response = await _dio.get(
        ApiEndpoints.getApplicationPrivacyScore,
        queryParameters: {
          'appName': appName,
          'appVector': appVector,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $_authToken',
          },
        ),
      );
      return response.data.toString();
    } on DioException catch (e) {
      developer.log(
        'Dio error getting privacy score for $appName: ${e.message}', 
        name: 'AppPrivacy',
        error: e
      );
      return '';
    } catch (e) {
      developer.log('Error getting privacy score for $appName: $e', name: 'AppPrivacy');
      return '';
    }
  }

  Future<String> _getScoreExplanation(String appName, String appVector) async {
    try {
      final response = await _dio.get(
        ApiEndpoints.getApplicationScoreExplanation,
        queryParameters: {
          'appName': appName,
          'appVector': appVector,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $_authToken',
          },
        ),
      );
      return response.data.toString();
    } on DioException catch (e) {
      developer.log(
        'Dio error getting score explanation for $appName: ${e.message}', 
        name: 'AppPrivacy',
        error: e
      );
      return '';
    } catch (e) {
      developer.log('Error getting score explanation for $appName: $e', name: 'AppPrivacy');
      return '';
    }
  }

  Future<void> updateAppPrivacyData() async {
    try {
      developer.log('Starting privacy data update cycle', name: 'AppPrivacy');
      
      await clearExistingData();
      
      final List<Object> apps = await _installedAppsService.getInstalledAppsWithUsage();
      int processedApps = 0;
      int uniqueApps = 0;
      
      for (var app in apps) {
        try {
          processedApps++;
          Map<String, dynamic> appMap = {};
          if (app is Map<Object?, Object?>) {
            appMap = Map<String, dynamic>.from(
              app.map((key, value) => MapEntry(key.toString(), value))
            );
          } else {
            continue;
          }

          final String packageName = appMap['packageName']?.toString() ?? '';
          
          if (!_isAppDataUnique(packageName)) {
            continue;
          }
          
          final String appName = appMap['appName']?.toString() ?? '';
          final privacyScore = await _getPrivacyScore(appName, packageName);
          final scoreExplanation = await _getScoreExplanation(appName, packageName);

          appMap['privacyScore'] = privacyScore;
          appMap['scoreExplanation'] = scoreExplanation;

          final appPrivacyInfo = AppInfoEntity.fromMap(appMap);
          await _appPrivacyBox.put(packageName, appPrivacyInfo);
          uniqueApps++;
          
        } catch (e) {
          developer.log('Error processing app: $e', name: 'AppPrivacy');
          continue;
        }
      }

      developer.log(
        'Update cycle completed - Processed: $processedApps, Unique: $uniqueApps', 
        name: 'AppPrivacy'
      );
      
    } catch (e, stackTrace) {
      developer.log(
        'Error in update cycle: $e\n$stackTrace', 
        name: 'AppPrivacy',
        error: e,
        stackTrace: stackTrace
      );
      rethrow;
    }
  }

  Future<List<AppInfoEntity>> getAllAppPrivacyInfo() async {
    try {
      return _appPrivacyBox.values.toList();
    } catch (e) {
      developer.log('Error getting all app privacy info: $e', name: 'AppPrivacy');
      return [];
    }
  }

  Future<void> printStoredData() async {
    try {
      final allData = await getAllAppPrivacyInfo();
      developer.log('Total apps stored in DB: ${allData.length}', name: 'AppPrivacy');
      
      for (var app in allData) {
        developer.log(
          'App Details:\n'
          '-------------\n'
          'App Name: ${app.appName}\n'
          'Package Name: ${app.packageName}\n'
          'Privacy Score: ${app.privacyScore}\n'
          'Score Explanation: ${app.scoreExplanation}\n'
          'Usage Time: ${app.usageTimeInMilliseconds}ms\n'
          'Install Date: ${app.installationDate}\n'
          'Version: ${app.version}\n'
          'Operating System: ${app.operatingSystem}\n'
          '-------------',
          name: 'AppPrivacy'
        );
      }
    } catch (e, stackTrace) {
      developer.log(
        'Error printing stored data: $e\n$stackTrace', 
        name: 'AppPrivacy',
        error: e,
        stackTrace: stackTrace
      );
    }
  }

  Future<void> close() async {
    try {
      await _appPrivacyBox.close();
      developer.log('AppPrivacyService closed successfully', name: 'AppPrivacy');
    } catch (e) {
      developer.log('Error closing AppPrivacyService: $e', name: 'AppPrivacy');
      rethrow;
    }
  }
}