package com.example.my_app2

import android.content.pm.PackageManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val INSTALLED_APPS_CHANNEL = "com.example.app/installed_apps"
    private val PERMISSIONS_CHANNEL = "app_permissions"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        // Installed apps channel remains the same...
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, INSTALLED_APPS_CHANNEL).setMethodCallHandler { call, result ->
            // Your existing installed apps code...
        }

        // Modified permissions channel
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, PERMISSIONS_CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "getPackagePermissions" -> {
                    val packageName = call.argument<String>("packageName")
                    if (packageName != null) {
                        try {
                            val packageInfo = packageManager.getPackageInfo(packageName, PackageManager.GET_PERMISSIONS)
                            val permissions = packageInfo.requestedPermissions?.toList() ?: listOf()
                            result.success(permissions)
                        } catch (e: Exception) {
                            result.error("ERROR", "Failed to get permissions", e.message)
                        }
                    } else {
                        result.error("ERROR", "Package name is required", null)
                    }
                }
                "checkPermissionStatus" -> {
                    val packageName = call.argument<String>("packageName")
                    val permission = call.argument<String>("permission")
                    
                    if (packageName == null || permission == null) {
                        result.error("ERROR", "Package name and permission are required", null)
                        return@setMethodCallHandler
                    }

                    try {
                        // Convert permission string to actual Android permission
                        val androidPermission = when (permission) {
                            "location" -> "android.permission.ACCESS_FINE_LOCATION"
                            "locationAlways" -> "android.permission.ACCESS_BACKGROUND_LOCATION"
                            "bluetooth" -> "android.permission.BLUETOOTH"
                            "activityRecognition" -> "android.permission.ACTIVITY_RECOGNITION"
                            "sensors" -> "android.permission.HIGH_SAMPLING_RATE_SENSORS"
                            "phone" -> "android.permission.READ_PHONE_STATE"
                            "ignoreBatteryOptimizations" -> "android.permission.REQUEST_IGNORE_BATTERY_OPTIMIZATIONS"
                            "storage" -> "android.permission.READ_EXTERNAL_STORAGE"
                            "microphone" -> "android.permission.RECORD_AUDIO"
                            else -> null
                        }

                        if (androidPermission == null) {
                            result.error("ERROR", "Unknown permission: $permission", null)
                            return@setMethodCallHandler
                        }

                        val granted = packageManager.checkPermission(
                            androidPermission,
                            packageName
                        ) == PackageManager.PERMISSION_GRANTED

                        result.success(if (granted) 1 else 0)
                    } catch (e: Exception) {
                        result.error("ERROR", "Failed to check permission status", e.message)
                    }
                }
                else -> result.notImplemented()
            }
        }
    }
}