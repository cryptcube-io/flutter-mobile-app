package com.example.my_app2

import android.content.pm.PackageManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val PERMISSIONS_CHANNEL = "app_permissions"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, PERMISSIONS_CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "getAllStorageApps" -> {
                    try {
                        val apps = mutableMapOf<String, String>()
                        val packages = packageManager.getInstalledPackages(PackageManager.GET_PERMISSIONS)
                        
                        for (packageInfo in packages) {
                            val permissions = packageInfo.requestedPermissions
                            if (permissions != null) {
                                val hasStorage = permissions.contains("android.permission.READ_EXTERNAL_STORAGE") ||
                                               permissions.contains("android.permission.WRITE_EXTERNAL_STORAGE")

                                if (hasStorage) {
                                    val permissionLevel = if (
                                        checkPermissionGranted(packageInfo.packageName, "android.permission.READ_EXTERNAL_STORAGE") ||
                                        checkPermissionGranted(packageInfo.packageName, "android.permission.WRITE_EXTERNAL_STORAGE")
                                    ) {
                                        "allowed"
                                    } else {
                                        "notAllowed"
                                    }
                                    apps[packageInfo.packageName] = permissionLevel
                                }
                            }
                        }
                        result.success(apps)
                    } catch (e: Exception) {
                        result.error("ERROR", "Failed to get storage apps", e.message)
                    }
                }

                "getAllCameraApps" -> {
                    try {
                        val apps = mutableMapOf<String, String>()
                        val packages = packageManager.getInstalledPackages(PackageManager.GET_PERMISSIONS)
                        
                        for (packageInfo in packages) {
                            val permissions = packageInfo.requestedPermissions
                            if (permissions != null && permissions.contains("android.permission.CAMERA")) {
                                val permissionLevel = if (checkPermissionGranted(packageInfo.packageName, "android.permission.CAMERA")) {
                                    "allowed"
                                } else {
                                    "notAllowed"
                                }
                                apps[packageInfo.packageName] = permissionLevel
                            }
                        }
                        result.success(apps)
                    } catch (e: Exception) {
                        result.error("ERROR", "Failed to get camera apps", e.message)
                    }
                }

                "getAllMicrophoneApps" -> {
                    try {
                        val apps = mutableMapOf<String, String>()
                        val packages = packageManager.getInstalledPackages(PackageManager.GET_PERMISSIONS)
                        
                        for (packageInfo in packages) {
                            val permissions = packageInfo.requestedPermissions
                            if (permissions != null && permissions.contains("android.permission.RECORD_AUDIO")) {
                                val permissionLevel = if (checkPermissionGranted(packageInfo.packageName, "android.permission.RECORD_AUDIO")) {
                                    "allowed"
                                } else {
                                    "notAllowed"
                                }
                                apps[packageInfo.packageName] = permissionLevel
                            }
                        }
                        result.success(apps)
                    } catch (e: Exception) {
                        result.error("ERROR", "Failed to get microphone apps", e.message)
                    }
                }

                else -> result.notImplemented()
            }
        }
    }

    private fun checkPermissionGranted(packageName: String, permission: String): Boolean {
        return packageManager.checkPermission(
            permission,
            packageName
        ) == PackageManager.PERMISSION_GRANTED
    }
}