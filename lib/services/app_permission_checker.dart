// lib/utils/permission_checker.dart
import 'package:flutter/services.dart';
import 'dart:convert';

class AppPermissionChecker {
  static const _channel = MethodChannel('app_permissions');

  static final Map<String, dynamic> permissionStructure = {
    "app_name": {
      "Location Services": {
        "GPS Data": {
          "ACCESS_FINE_LOCATION": {"status": ""},
          "ACCESS_BACKGROUND_LOCATION": {"status": ""},
          "FOREGROUND_SERVICE": {"status": ""}
        },
        "Wi-Fi Data": {
          "ACCESS_WIFI_STATE": {"status": ""},
          "CHANGE_WIFI_STATE": {"status": ""},
          "ACCESS_COARSE_LOCATION": {"status": ""},
          "INTERNET": {"status": ""}
        },
        "Cellular Network Data": {
          "ACCESS_COARSE_LOCATION": {"status": ""},
          "ACCESS_NETWORK_STATE": {"status": ""},
          "INTERNET": {"status": ""}
        },
        "Bluetooth Data": {
          "BLUETOOTH": {"status": ""},
          "BLUETOOTH_ADMIN": {"status": ""},
          "BLUETOOTH_SCAN": {"status": ""},
          "BLUETOOTH_CONNECT": {"status": ""},
          "BLUETOOTH_ADVERTISE": {"status": ""}
        },
        "Geofencing Data": {
          "ACCESS_FINE_LOCATION": {"status": ""},
          "ACCESS_BACKGROUND_LOCATION": {"status": ""},
          "FOREGROUND_SERVICE": {"status": ""}
        }
      },
      "Health and Fitness Data": {
        "Health Data": {
          "BODY_SENSORS": {"status": ""},
          "ACTIVITY_RECOGNITION": {"status": ""},
          "com.google.android.gms.permission.ACTIVITY_RECOGNITION": {
            "status": ""
          },
          "FOREGROUND_SERVICE": {"status": ""}
        }
      },
      "Sensor Data": {
        "Sensors": {
          "HIGH_SAMPLING_RATE_SENSORS": {"status": ""},
          "FOREGROUND_SERVICE": {"status": ""}
        }
      },
      "Application Usage Data": {
        "App Usage": {
          "PACKAGE_USAGE_STATS": {"status": ""},
          "GET_APP_OPS_STATS": {"status": ""},
          "INTERNET": {"status": ""},
          "FOREGROUND_SERVICE": {"status": ""}
        }
      },
      "Device Information": {
        "Device Info": {
          "READ_PHONE_STATE": {"status": ""}
        },
        "Battery": {
          "BATTERY_STATS": {"status": ""}
        },
        "Storage": {
          "READ_EXTERNAL_STORAGE": {"status": ""},
          "WRITE_EXTERNAL_STORAGE": {"status": ""},
          "MANAGE_EXTERNAL_STORAGE": {"status": ""}
        },
        "Network": {
          "ACCESS_NETWORK_STATE": {"status": ""},
          "INTERNET": {"status": ""},
          "ACCESS_WIFI_STATE": {"status": ""}
        }
      },
      "User Behavior and Preferences": {
        "Browser History": {
          "READ_HISTORY_BOOKMARKS": {"status": ""},
          "WRITE_HISTORY_BOOKMARKS": {"status": ""},
          "INTERNET": {"status": ""}
        },
        "Voice Commands": {
          "RECORD_AUDIO": {"status": ""},
          "INTERNET": {"status": ""}
        },
        "App Store": {
          "BILLING": {"status": ""},
          "INTERNET": {"status": ""}
        },
        "Social Media": {
          "INTERNET": {"status": ""},
          "READ_CONTACTS": {"status": ""}
        },
        "Messaging": {
          "READ_CONTACTS": {"status": ""},
          "READ_SMS": {"status": ""},
          "READ_EMAIL": {"status": ""},
          "INTERNET": {"status": ""}
        }
      },
      "Financial Data": {
        "Financial": {
          "INTERNET": {"status": ""},
          "USE_BIOMETRIC": {"status": ""},
          "USE_FINGERPRINT": {"status": ""}
        }
      }
    }
  };

    static Future<Map<String, String>> getAppPermissions(String packageName) async {
    try {
      final Map<dynamic, dynamic> result = await _channel.invokeMethod('getAppPermissions', {
        'packageName': packageName
      });
      return Map<String, String>.from(result);
    } on PlatformException catch (e) {
      print('Error getting app permissions: ${e.message}');
      return {};
    }
  }

  static void _updateStructure(Map<String, dynamic> structure, Map<String, String> permissions) {
    structure.forEach((key, value) {
      if (value is Map<String, dynamic>) {
        if (value.containsKey('status')) {
          // This is a permission entry
          value['status'] = permissions[key] ?? "NOT_REQUESTED";  // Changed here
        } else {
          // This is a category or subcategory
          _updateStructure(value, permissions);
        }
      }
    });
  }

  static Future<void> printStructuredPermissions(String packageName) async {
    try {
      final permissions = await getAppPermissions(packageName);
      
      // Create a deep copy of the structure
      final Map<String, dynamic> result = json.decode(json.encode(permissionStructure));
      
      // Update the statuses
      _updateStructure(result, permissions);
      
      // Print formatted JSON
      final prettyJson = JsonEncoder.withIndent('  ').convert(result);
      print('BEGIN PERMISSIONS OUTPUT');
      print(prettyJson);
      print('END PERMISSIONS OUTPUT');
      
    } catch (e) {
      print('Error: $e');
    }
  }
}