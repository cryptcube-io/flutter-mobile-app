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
import android.os.Process
import android.content.pm.PackageInfo
import android.annotation.SuppressLint

enum class PermissionType {
    LOCATION_GPS,
    LOCATION_WIFI,
    LOCATION_CELLULAR,
    LOCATION_BLUETOOTH,
    LOCATION_GEOFENCING,
    HEALTH_FITNESS,
    SENSORS,
    APP_USAGE,
    DEVICE_INFO,
    STORAGE,
    NETWORK,
    USER_BEHAVIOR,
    FINANCIAL,
    OTHER
}

class MainActivity: FlutterActivity() {
    private val APPS_CHANNEL = "com.example.app/installed_apps"
    private val PERMISSIONS_CHANNEL = "app_permissions"

    private fun checkPermissionResult(packageName: String, permission: String): Boolean {
        return packageManager.checkPermission(permission, packageName) == PackageManager.PERMISSION_GRANTED
    }

    @SuppressLint("NewApi")
    private fun getPermissionState(packageName: String, permission: String): String {
        val appOps = getSystemService(Context.APP_OPS_SERVICE) as AppOpsManager
        
        if (permission in listOf(
            android.Manifest.permission.ACCESS_FINE_LOCATION,
            android.Manifest.permission.ACCESS_COARSE_LOCATION
        )) {
            val backgroundGranted = checkPermissionResult(packageName, android.Manifest.permission.ACCESS_BACKGROUND_LOCATION)
            val foregroundGranted = checkPermissionResult(packageName, permission)
            
            return when {
                backgroundGranted && foregroundGranted -> "ALLOW_ALL_TIME"
                foregroundGranted -> "ALLOW_WHILE_USING"
                else -> "DENIED"
            }
        }
        
        if (permission == android.Manifest.permission.RECORD_AUDIO) {
            val granted = checkPermissionResult(packageName, permission)
            if (!granted) return "DENIED"
            
            val mode = appOps.unsafeCheckOpNoThrow(AppOpsManager.OPSTR_RECORD_AUDIO, Process.myUid(), packageName)
            return when (mode) {
                AppOpsManager.MODE_ALLOWED -> "ALLOW_WHILE_USING"
                AppOpsManager.MODE_FOREGROUND -> "ALLOW_WHILE_USING"
                else -> "DENIED"
            }
        }

        return if (checkPermissionResult(packageName, permission)) "ALLOWED" else "DENIED"
    }

    private fun getPermissionsForPackage(packageName: String): Map<String, String> {
        val permissions = mutableMapOf<String, String>()
        val packageInfo = packageManager.getPackageInfo(packageName, PackageManager.GET_PERMISSIONS)
        
        val permissionCategories = mapOf(
            // Location Services - GPS
            "ACCESS_FINE_LOCATION" to PermissionType.LOCATION_GPS,
            "ACCESS_BACKGROUND_LOCATION" to PermissionType.LOCATION_GPS,
            "FOREGROUND_SERVICE" to PermissionType.LOCATION_GPS,
            
            // Location Services - WiFi
            "ACCESS_WIFI_STATE" to PermissionType.LOCATION_WIFI,
            "CHANGE_WIFI_STATE" to PermissionType.LOCATION_WIFI,
            "ACCESS_COARSE_LOCATION" to PermissionType.LOCATION_WIFI,
            "INTERNET" to PermissionType.NETWORK,
            
            // Bluetooth
            "BLUETOOTH" to PermissionType.LOCATION_BLUETOOTH,
            "BLUETOOTH_ADMIN" to PermissionType.LOCATION_BLUETOOTH,
            "BLUETOOTH_SCAN" to PermissionType.LOCATION_BLUETOOTH,
            "BLUETOOTH_CONNECT" to PermissionType.LOCATION_BLUETOOTH,
            "BLUETOOTH_ADVERTISE" to PermissionType.LOCATION_BLUETOOTH,
            
            // Health and Fitness
            "BODY_SENSORS" to PermissionType.HEALTH_FITNESS,
            "ACTIVITY_RECOGNITION" to PermissionType.HEALTH_FITNESS,
            
            // Sensors
            "HIGH_SAMPLING_RATE_SENSORS" to PermissionType.SENSORS,
            
            // App Usage
            "PACKAGE_USAGE_STATS" to PermissionType.APP_USAGE,
            "GET_APP_OPS_STATS" to PermissionType.APP_USAGE,
            
            // Device Info
            "READ_PHONE_STATE" to PermissionType.DEVICE_INFO,
            "BATTERY_STATS" to PermissionType.DEVICE_INFO,
            
            // Storage
            "READ_EXTERNAL_STORAGE" to PermissionType.STORAGE,
            "WRITE_EXTERNAL_STORAGE" to PermissionType.STORAGE,
            "MANAGE_EXTERNAL_STORAGE" to PermissionType.STORAGE,
            
            // User Behavior
            "READ_HISTORY_BOOKMARKS" to PermissionType.USER_BEHAVIOR,
            "WRITE_HISTORY_BOOKMARKS" to PermissionType.USER_BEHAVIOR,
            "RECORD_AUDIO" to PermissionType.USER_BEHAVIOR,
            "BILLING" to PermissionType.USER_BEHAVIOR,
            "READ_CONTACTS" to PermissionType.USER_BEHAVIOR,
            "READ_SMS" to PermissionType.USER_BEHAVIOR,
            "READ_EMAIL" to PermissionType.USER_BEHAVIOR,
            
            // Financial
            "USE_BIOMETRIC" to PermissionType.FINANCIAL,
            "USE_FINGERPRINT" to PermissionType.FINANCIAL
        )
        
        val requestedPermissions = packageInfo.requestedPermissions
        println("All requested permissions for $packageName: ${requestedPermissions?.joinToString(", ") ?: "none"}")
        
        if (requestedPermissions != null) {
            for (permission in requestedPermissions) {
                try {
                    val simpleName = permission.split(".").last()
                    if (simpleName in permissionCategories.keys) {
                        val category = permissionCategories[simpleName] ?: PermissionType.OTHER
                        val state = getPermissionState(packageName, permission)
                        
                        permissions[simpleName] = state
                        
                        //println("Permission: $permission")
                        //println("State: $state")
                        //println("Category: $category")
                    }
                } catch (e: Exception) {
                    println("Error checking permission $permission: ${e.message}")
                    permissions[permission] = "ERROR"
                }
            }
        }
        
        return permissions
    }

    // [Previous usage stats related functions remain the same]
    private fun getAppUsageStats(): Map<String, Long> {
        val usageStatsManager = getSystemService(Context.USAGE_STATS_SERVICE) as UsageStatsManager
        val endTime = System.currentTimeMillis()
        val startTime = 0L
        
        val intervals = listOf(
            UsageStatsManager.INTERVAL_YEARLY,
            UsageStatsManager.INTERVAL_MONTHLY,
            UsageStatsManager.INTERVAL_WEEKLY,
            UsageStatsManager.INTERVAL_DAILY
        )
        val usageMap = mutableMapOf<String, Long>()
        
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
            Process.myUid(),
            packageName
        )
        return mode == AppOpsManager.MODE_ALLOWED
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, APPS_CHANNEL).setMethodCallHandler { call, result ->
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

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, PERMISSIONS_CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "getAppPermissions" -> {
                    val packageName = call.argument<String>("packageName")
                    if (packageName == null) {
                        result.error("INVALID_ARGUMENT", "Package name is required", null)
                        return@setMethodCallHandler
                    }

                    try {
                        val permissions = getPermissionsForPackage(packageName)
                        result.success(permissions)
                    } catch (e: PackageManager.NameNotFoundException) {
                        result.error("PACKAGE_NOT_FOUND", "Package $packageName not found", null)
                    } catch (e: Exception) {
                        result.error("ERROR", "Failed to get permissions: ${e.message}", null)
                    }
                }
                else -> result.notImplemented()
            }
        }
    }
}