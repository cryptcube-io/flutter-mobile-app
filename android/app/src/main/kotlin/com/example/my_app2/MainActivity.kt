package com.example.my_app2

import android.content.Context
import android.app.usage.UsageStatsManager
import android.app.usage.UsageStats
import java.util.Calendar
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.content.pm.PackageManager
import android.app.AppOpsManager
import android.content.Intent
import android.provider.Settings

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.example.app/installed_apps"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "getInstalledAppsWithUsage" -> {
                    if (!hasUsageStatsPermission()) {
                        startActivity(Intent(Settings.ACTION_USAGE_ACCESS_SETTINGS))
                        result.error("PERMISSION_DENIED", "Usage stats permission required", null)
                        return@setMethodCallHandler
                    }
                    try {
                        val apps = mutableListOf<Map<String, Any>>()
                        val packages = packageManager.getInstalledPackages(PackageManager.GET_META_DATA)
                        val usageStats = getAppUsageStats()
                        
                        for (packageInfo in packages) {
                            try {
                                val appInfo = packageManager.getApplicationInfo(packageInfo.packageName, 0)
                                val app = mutableMapOf<String, Any>()
                                app["packageName"] = packageInfo.packageName
                                app["appName"] = packageManager.getApplicationLabel(appInfo).toString()
                                app["usageTime"] = usageStats[packageInfo.packageName] ?: 0L
                                apps.add(app)
                            } catch (e: Exception) {
                                continue
                            }
                        }
                        result.success(apps)
                    } catch (e: Exception) {
                        result.error("ERROR", "Failed to get apps", e.message)
                    }
                }
                else -> result.notImplemented()
            }
        }
    }

    private fun getAppUsageStats(): Map<String, Long> {
    val usageStatsManager = getSystemService(Context.USAGE_STATS_SERVICE) as UsageStatsManager
    
    // Get stats since Unix epoch (Jan 1, 1970)
    val endTime = System.currentTimeMillis()
    val startTime = 0L  // Beginning of time for Android

    // Query for all available intervals
    val intervals = listOf(
        UsageStatsManager.INTERVAL_YEARLY,
        UsageStatsManager.INTERVAL_MONTHLY,
        UsageStatsManager.INTERVAL_WEEKLY,
        UsageStatsManager.INTERVAL_DAILY
    )

    val usageMap = mutableMapOf<String, Long>()
    
    // Aggregate stats from all intervals
    for (interval in intervals) {
        val stats = usageStatsManager.queryUsageStats(interval, startTime, endTime)
        stats?.forEach { stat ->
            usageMap[stat.packageName] = (usageMap[stat.packageName] ?: 0L) + stat.totalTimeInForeground
        }
    }

    return usageMap
}

    private fun hasUsageStatsPermission(): Boolean {
        val appOps = getSystemService(Context.APP_OPS_SERVICE) as AppOpsManager
        val mode = appOps.checkOpNoThrow(
            AppOpsManager.OPSTR_GET_USAGE_STATS,
            android.os.Process.myUid(),
            packageName
        )
        return mode == AppOpsManager.MODE_ALLOWED
    }
}