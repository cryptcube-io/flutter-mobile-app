class AppInfo {
  final String packageName;
  final String appName;
  final Duration usageTimeInMilliseconds;
  final DateTime installDate;
  final String version;

  AppInfo({
    required this.packageName,
    required this.appName,
    required this.usageTimeInMilliseconds,
    required this.installDate,
    required this.version,
  });

  factory AppInfo.fromMap(Map<Object?, Object?> map) {
    return AppInfo(
      packageName: map['packageName'] as String,
      appName: map['appName'] as String,
      usageTimeInMilliseconds: Duration(milliseconds: (map['usageTime'] as int).toInt()),
      installDate: DateTime.fromMillisecondsSinceEpoch(map['installDate'] as int),
      version: map['version'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'packageName': packageName,
      'appName': appName,
      'usageTimeInMilliseconds': usageTimeInMilliseconds.inMilliseconds,
      'installationDate': installDate.toIso8601String(),
      'version': version,
    };
  }

  @override
  String toString() {
    final hours = usageTimeInMilliseconds.inHours;
    final minutes = usageTimeInMilliseconds.inMinutes.remainder(60);
    final installDateStr = '${installDate.year}-${installDate.month.toString().padLeft(2, '0')}-${installDate.day.toString().padLeft(2, '0')}';
    return '$appName v$version (Installed: $installDateStr, Usage: ${hours}h ${minutes}m)';
  }
}