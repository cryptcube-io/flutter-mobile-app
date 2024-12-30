class AppInfo {
  final String packageName;
  final String appName;
  final String versionName;

  AppInfo({
    required this.packageName,
    required this.appName,
    required this.versionName,
  });

  factory AppInfo.fromMap(Map<Object?, Object?> map) {
    return AppInfo(
      packageName: map['packageName']?.toString() ?? '',
      appName: map['appName']?.toString() ?? '',
      versionName: map['versionName']?.toString() ?? '',
    );
  }
}