class AppInfo {
  final String packageName;
  final String appName;
  final Duration usageTime;

  AppInfo({
    required this.packageName,
    required this.appName,
    required this.usageTime,
  });

  factory AppInfo.fromMap(Map<Object?, Object?> map) {
    return AppInfo(
      packageName: map['packageName'] as String,
      appName: map['appName'] as String,
      usageTime: Duration(milliseconds: (map['usageTime'] as int).toInt()),
    );
  }

  @override
  String toString() {
    final hours = usageTime.inHours;
    final minutes = usageTime.inMinutes % 60;
    return '$appName (${hours}h ${minutes}m total usage)';
  }
}
