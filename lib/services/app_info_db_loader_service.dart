import 'package:Cryptcube_mobile_app/config/api_endpoints.dart';
import 'package:dio/dio.dart';
import 'package:hive/hive.dart';
import 'dart:developer' as developer;
import '../models/app_info_database.dart';
import 'installed_apps_service.dart';

class AppPrivacyService {
  final InstalledAppsService _installedAppsService = InstalledAppsService();
  final Dio _dio = Dio();
  late Box<AppPrivacyInfo> _appPrivacyBox;

  static const String _authToken = 'eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJzYW5rZXQua29yZ2FvbmthckBwcm90b25tYWlsMTAxLmNvbSIsImlhdCI6MTczNjk1OTk2NCwiZXhwIjoxNzM4MjU1OTY0fQ.69P3Lk9-D5i7j8df8daXs0T5oyouMhscbtxBluo4mXQ';

  Future<void> init() async {
    try {
      _appPrivacyBox = await Hive.openBox<AppPrivacyInfo>('app_privacy');
      developer.log('AppPrivacyService initialized successfully', name: 'AppPrivacy');
    } catch (e) {
      developer.log('Failed to initialize AppPrivacyService: $e', name: 'AppPrivacy');
      rethrow;
    }
  }

  Future<String> _getPrivacyScore(String appName, String appVector) async {
    try {
      // developer.log('Getting privacy score for $appName', name: 'AppPrivacy');
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
      // developer.log('Privacy score response for $appName: ${response.data}', name: 'AppPrivacy');
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
      // developer.log('Getting score explanation for $appName', name: 'AppPrivacy');
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
      // developer.log('Score explanation response for $appName: ${response.data}', name: 'AppPrivacy');
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
      // developer.log('Starting to update app privacy data', name: 'AppPrivacy');
      final List<Object> apps = await _installedAppsService.getInstalledAppsWithUsage();
      // developer.log('Retrieved ${apps.length} installed apps', name: 'AppPrivacy');

      for (var app in apps) {
        try {
          // developer.log('Processing app data: $app', name: 'AppPrivacy');
          Map<String, dynamic> appMap = {};
          if (app is Map<Object?, Object?>) {
            appMap = Map<String, dynamic>.from(
              app.map((key, value) => MapEntry(key.toString(), value))
            );
          } else {
            developer.log('Unexpected app data format', name: 'AppPrivacy');
            continue;
          }

          final String appName = appMap['appName']?.toString() ?? '';
          final String appVector = appMap['packageName']?.toString() ?? '';

          // developer.log('Processing app: $appName', name: 'AppPrivacy');

          final privacyScore = await _getPrivacyScore(appName, appVector);
          final scoreExplanation = await _getScoreExplanation(appName, appVector);

          appMap['privacyScore'] = privacyScore;
          appMap['scoreExplanation'] = scoreExplanation;

          final appPrivacyInfo = AppPrivacyInfo.fromMap(appMap);
          await _appPrivacyBox.put(appPrivacyInfo.packageName, appPrivacyInfo);
          // developer.log('Successfully processed app: $appName', name: 'AppPrivacy');
        } catch (e) {
          developer.log('Error processing individual app: $e', name: 'AppPrivacy');
          continue; // Continue with next app even if one fails
        }
      }

      // developer.log('Finished updating app privacy data', name: 'AppPrivacy');
    } catch (e, stackTrace) {
      developer.log(
        'Error updating app privacy data: $e\n$stackTrace', 
        name: 'AppPrivacy',
        error: e,
        stackTrace: stackTrace
      );
      rethrow;
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
  Future<List<AppPrivacyInfo>> getAllAppPrivacyInfo() async {
    try {
      return _appPrivacyBox.values.toList();
    } catch (e) {
      developer.log('Error getting all app privacy info: $e', name: 'AppPrivacy');
      return [];
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