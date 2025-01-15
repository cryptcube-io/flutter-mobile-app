import 'package:hive/hive.dart';

@HiveType(typeId: 1)
class AppPrivacyInfo extends HiveObject {
  @HiveField(0)
  final String packageName;

  @HiveField(1)
  final String appName;

  @HiveField(2)
  final int usageTimeInMilliseconds;

  @HiveField(3)
  final DateTime installationDate;

  @HiveField(4)
  final String version;

  @HiveField(5)
  final String operatingSystem;

  @HiveField(6)
  final String privacyScore;

  @HiveField(7)
  final String scoreExplanation;

  AppPrivacyInfo({
    required this.packageName,
    required this.appName,
    required this.usageTimeInMilliseconds,
    required this.installationDate,
    required this.version,
    required this.operatingSystem,
    this.privacyScore = '',
    this.scoreExplanation = '',
  });

  factory AppPrivacyInfo.fromMap(Map<String, dynamic> map) {
    try {
      return AppPrivacyInfo(
        packageName: map['packageName']?.toString() ?? '',
        appName: map['appName']?.toString() ?? '',
        usageTimeInMilliseconds: int.tryParse(map['usageTimeInMilliseconds']?.toString() ?? '0') ?? 0,
        installationDate: DateTime.tryParse(map['installationDate']?.toString() ?? '') ?? DateTime.now(),
        version: map['version']?.toString() ?? '',
        operatingSystem: map['operatingSystem']?.toString() ?? '',
        privacyScore: map['privacyScore']?.toString() ?? '',
        scoreExplanation: map['scoreExplanation']?.toString() ?? '',
      );
    } catch (e) {
      print('Error creating AppPrivacyInfo from map: $e');
      print('Map content: $map');
      rethrow;
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'packageName': packageName,
      'appName': appName,
      'usageTimeInMilliseconds': usageTimeInMilliseconds,
      'installationDate': installationDate.toIso8601String(),
      'version': version,
      'operatingSystem': operatingSystem,
      'privacyScore': privacyScore,
      'scoreExplanation': scoreExplanation,
    };
  }
}