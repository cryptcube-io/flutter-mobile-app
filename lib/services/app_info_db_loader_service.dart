import 'package:Cryptcube_mobile_app/constants/api_endpoints.dart';
import 'package:dio/dio.dart';
import 'package:hive/hive.dart';
import '../models/app_info_database.dart';
import 'installed_apps_service.dart';
import '../../../services/logger_service.dart';

class AppInfoDbLoaderService with LoggerMixin {
  final InstalledAppsService _installedAppsService = InstalledAppsService();
  final Dio _dio = Dio();
  late Box<AppInfoEntity> _appPrivacyBox;

  static const String _authToken = 'YOUR_AUTH_TOKEN_HERE';

  Future<void> init() async {
    try {
      _appPrivacyBox = await Hive.openBox<AppInfoEntity>('app_privacy');
      logInfo('AppPrivacyService initialized successfully');
    } catch (e, stackTrace) {
      logError('Failed to initialize AppPrivacyService', e, stackTrace);
      rethrow;
    }
  }

  Future<void> clearExistingData() async {
    try {
      await _appPrivacyBox.clear();
      logInfo('Cleared existing app privacy data');
    } catch (e, stackTrace) {
      logError('Error clearing app privacy data', e, stackTrace);
      rethrow;
    }
  }

  bool _isAppDataUnique(String packageName) {
    return !_appPrivacyBox.containsKey(packageName);
  }

  Future<String> _getPrivacyScore(String appName, String appVector) async {
    try {
      logDebug('Fetching privacy score for: $appName');
      final response = await _dio.get(
        ApiEndpoints.getApplicationPrivacyScore,
        queryParameters: {
          'appName': appName,
          'appVector': appVector,
        },
        options: Options(
          headers: {'Authorization': 'Bearer $_authToken'},
        ),
      );
      return response.data.toString();
    } on DioException catch (e, stackTrace) {
      logError('Dio error getting privacy score for $appName', e, stackTrace);
      return '';
    } catch (e, stackTrace) {
      logError('Error getting privacy score for $appName', e, stackTrace);
      return '';
    }
  }

  Future<String> _getScoreExplanation(String appName, String appVector) async {
    try {
      logDebug('Fetching score explanation for: $appName');
      final response = await _dio.get(
        ApiEndpoints.getApplicationScoreExplanation,
        queryParameters: {
          'appName': appName,
          'appVector': appVector,
        },
        options: Options(
          headers: {'Authorization': 'Bearer $_authToken'},
        ),
      );
      return response.data.toString();
    } on DioException catch (e, stackTrace) {
      logError('Dio error getting score explanation for $appName', e, stackTrace);
      return '';
    } catch (e, stackTrace) {
      logError('Error getting score explanation for $appName', e, stackTrace);
      return '';
    }
  }

  Future<void> updateAppPrivacyData() async {
    try {
      logInfo('Starting privacy data update cycle');
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
          if (!_isAppDataUnique(packageName)) continue;

          final String appName = appMap['appName']?.toString() ?? '';
          final privacyScore = await _getPrivacyScore(appName, packageName);
          final scoreExplanation = await _getScoreExplanation(appName, packageName);

          appMap['privacyScore'] = privacyScore;
          appMap['scoreExplanation'] = scoreExplanation;

          final appPrivacyInfo = AppInfoEntity.fromMap(appMap);
          await _appPrivacyBox.put(packageName, appPrivacyInfo);
          uniqueApps++;
        } catch (e, stackTrace) {
          logError('Error processing app', e, stackTrace);
          continue;
        }
      }

      logInfo('Update cycle completed - Processed: $processedApps, Unique: $uniqueApps');
    } catch (e, stackTrace) {
      logError('Error in update cycle', e, stackTrace);
      rethrow;
    }
  }

  Future<List<AppInfoEntity>> getAllAppPrivacyInfo() async {
    try {
      logInfo('Fetching all stored app privacy data');
      return _appPrivacyBox.values.toList();
    } catch (e, stackTrace) {
      logError('Error retrieving stored app privacy info', e, stackTrace);
      return [];
    }
  }

  Future<void> printStoredData() async {
    try {
      final allData = await getAllAppPrivacyInfo();
      logInfo('Total apps stored in DB: ${allData.length}');
      
      for (var app in allData) {
        logDebug('''
        App Details:
        -------------
        App Name: ${app.appName}
        Package Name: ${app.packageName}
        Privacy Score: ${app.privacyScore}
        Score Explanation: ${app.scoreExplanation}
        Usage Time: ${app.usageTimeInMilliseconds}ms
        Install Date: ${app.installationDate}
        Version: ${app.version}
        Operating System: ${app.operatingSystem}
        -------------''');
      }
    } catch (e, stackTrace) {
      logError('Error printing stored data', e, stackTrace);
    }
  }

  Future<void> close() async {
    try {
      await _appPrivacyBox.close();
      logInfo('AppPrivacyService closed successfully');
    } catch (e, stackTrace) {
      logError('Error closing AppPrivacyService', e, stackTrace);
      rethrow;
    }
  }
}
