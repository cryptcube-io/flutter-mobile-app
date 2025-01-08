class PermissionStructure {
  static const String NOT_REQUESTED = "NOT_REQUESTED";

  static final Map<String, dynamic> structure = {
    "app_name": {
      "Location Services": {
        "GPS Data": {
          "ACCESS_FINE_LOCATION": {"status": NOT_REQUESTED},
          "ACCESS_BACKGROUND_LOCATION": {"status": NOT_REQUESTED},
          "FOREGROUND_SERVICE": {"status": NOT_REQUESTED}
        },
        "Wi-Fi Data": {
          "ACCESS_WIFI_STATE": {"status": NOT_REQUESTED},
          "CHANGE_WIFI_STATE": {"status": NOT_REQUESTED},
          "ACCESS_COARSE_LOCATION": {"status": NOT_REQUESTED},
          "INTERNET": {"status": NOT_REQUESTED}
        },
        "Cellular Network Data": {
          "ACCESS_COARSE_LOCATION": {"status": NOT_REQUESTED},
          "ACCESS_NETWORK_STATE": {"status": NOT_REQUESTED},
          "INTERNET": {"status": NOT_REQUESTED}
        },
        "Bluetooth Data": {
          "BLUETOOTH": {"status": NOT_REQUESTED},
          "BLUETOOTH_ADMIN": {"status": NOT_REQUESTED},
          "BLUETOOTH_SCAN": {"status": NOT_REQUESTED},
          "BLUETOOTH_CONNECT": {"status": NOT_REQUESTED},
          "BLUETOOTH_ADVERTISE": {"status": NOT_REQUESTED}
        },
        "Geofencing Data": {
          "ACCESS_FINE_LOCATION": {"status": NOT_REQUESTED},
          "ACCESS_BACKGROUND_LOCATION": {"status": NOT_REQUESTED},
          "FOREGROUND_SERVICE": {"status": NOT_REQUESTED}
        }
      },
      "Health and Fitness Data": {
        "Health Data": {
          "BODY_SENSORS": {"status": NOT_REQUESTED},
          "ACTIVITY_RECOGNITION": {"status": NOT_REQUESTED},
          "com.google.android.gms.permission.ACTIVITY_RECOGNITION": {"status": NOT_REQUESTED},
          "FOREGROUND_SERVICE": {"status": NOT_REQUESTED}
        }
      },
      "Sensor Data": {
        "Sensors": {
          "HIGH_SAMPLING_RATE_SENSORS": {"status": NOT_REQUESTED},
          "FOREGROUND_SERVICE": {"status": NOT_REQUESTED}
        }
      },
      "Application Usage Data": {
        "App Usage": {
          "PACKAGE_USAGE_STATS": {"status": NOT_REQUESTED},
          "GET_APP_OPS_STATS": {"status": NOT_REQUESTED},
          "INTERNET": {"status": NOT_REQUESTED},
          "FOREGROUND_SERVICE": {"status": NOT_REQUESTED}
        }
      },
      "Device Information": {
        "Device Info": {
          "READ_PHONE_STATE": {"status": NOT_REQUESTED}
        },
        "Battery": {
          "BATTERY_STATS": {"status": NOT_REQUESTED}
        },
        "Storage": {
          "READ_EXTERNAL_STORAGE": {"status": NOT_REQUESTED},
          "WRITE_EXTERNAL_STORAGE": {"status": NOT_REQUESTED},
          "MANAGE_EXTERNAL_STORAGE": {"status": NOT_REQUESTED}
        },
        "Network": {
          "ACCESS_NETWORK_STATE": {"status": NOT_REQUESTED},
          "INTERNET": {"status": NOT_REQUESTED},
          "ACCESS_WIFI_STATE": {"status": NOT_REQUESTED}
        }
      },
      "User Behavior and Preferences": {
        "Browser History": {
          "READ_HISTORY_BOOKMARKS": {"status": NOT_REQUESTED},
          "WRITE_HISTORY_BOOKMARKS": {"status": NOT_REQUESTED},
          "INTERNET": {"status": NOT_REQUESTED}
        },
        "Voice Commands": {
          "RECORD_AUDIO": {"status": NOT_REQUESTED},
          "INTERNET": {"status": NOT_REQUESTED}
        },
        "App Store": {
          "BILLING": {"status": NOT_REQUESTED},
          "INTERNET": {"status": NOT_REQUESTED}
        },
        "Social Media": {
          "INTERNET": {"status": NOT_REQUESTED},
          "READ_CONTACTS": {"status": NOT_REQUESTED}
        },
        "Messaging": {
          "READ_CONTACTS": {"status": NOT_REQUESTED},
          "READ_SMS": {"status": NOT_REQUESTED},
          "READ_EMAIL": {"status": NOT_REQUESTED},
          "INTERNET": {"status": NOT_REQUESTED}
        }
      },
      "Financial Data": {
        "Financial": {
          "INTERNET": {"status": NOT_REQUESTED},
          "USE_BIOMETRIC": {"status": NOT_REQUESTED},
          "USE_FINGERPRINT": {"status": NOT_REQUESTED}
        }
      },
      "Calendar Access": {
        "Calendar": {
          "READ_CALENDAR": {"status": NOT_REQUESTED},
          "WRITE_CALENDAR": {"status": NOT_REQUESTED}
        }
      },
      "Media Access": {
        "Camera and Media": {
          "CAMERA": {"status": NOT_REQUESTED},
          "READ_MEDIA_IMAGES": {"status": NOT_REQUESTED},
          "READ_MEDIA_VIDEO": {"status": NOT_REQUESTED},
          "READ_MEDIA_AUDIO": {"status": NOT_REQUESTED}
        }
      },
      "App Management": {
        "Notifications": {
          "POST_NOTIFICATIONS": {"status": NOT_REQUESTED}
        },
        "Updates": {
          "REQUEST_INSTALL_PACKAGES": {"status": NOT_REQUESTED}
        }
      },
      "Account Access": {
        "Accounts": {
          "GET_ACCOUNTS": {"status": NOT_REQUESTED},
          "MANAGE_ACCOUNTS": {"status": NOT_REQUESTED},
          "USE_CREDENTIALS": {"status": NOT_REQUESTED}
        }
      },
      "Google Services": {
        "Gmail": {
          "READ_GMAIL": {"status": NOT_REQUESTED},
          "WRITE_GMAIL": {"status": NOT_REQUESTED}
        },
        "Google Services": {
          "READ_GSERVICES": {"status": NOT_REQUESTED}
        }
      }
    }
  };
}