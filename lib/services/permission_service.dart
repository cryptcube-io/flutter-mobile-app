// lib/services/permission_service.dart

import 'package:flutter/services.dart';
import 'dart:developer' as developer;
import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  static const platform = MethodChannel('app_permissions');
  
  Future<void> checkGoogleMapsDataAccess() async {
    const String GOOGLE_MAPS_PACKAGE = 'com.google.android.apps.messaging';
    developer.log('Starting Google Maps Permission Analysis', name: 'DataAccess');
    
    try {
      Set<int> requestedPoints = await getRequestedDataPoints(GOOGLE_MAPS_PACKAGE);
      Set<int> grantedPoints = await getGrantedDataPoints(GOOGLE_MAPS_PACKAGE);
      
      logPermissionResults(requestedPoints, grantedPoints);
    } catch (e) {
      developer.log('Error analyzing permissions: $e', name: 'DataAccess');
    }
  }

  Future<Set<int>> getRequestedDataPoints(String packageName) async {
    final Map<String, List<int>> permissionToDataPoints = {
      'android.permission.ACCESS_FINE_LOCATION': [1, 2],
      'android.permission.ACCESS_COARSE_LOCATION': [2, 3],
      'android.permission.ACCESS_BACKGROUND_LOCATION': [5],
      'android.permission.BLUETOOTH_SCAN': [4],
      'android.permission.BLUETOOTH_CONNECT': [4],
      'android.permission.ACTIVITY_RECOGNITION': [8],
      'com.google.android.gms.permission.ACTIVITY_RECOGNITION': [8],
      'android.permission.HIGH_SAMPLING_RATE_SENSORS': [12, 13, 14, 15, 16, 17],
      'android.permission.PACKAGE_USAGE_STATS': [18, 20],
      'android.permission.READ_PHONE_STATE': [22, 23, 24],
      'android.permission.BATTERY_STATS': [25],
      'android.permission.READ_EXTERNAL_STORAGE': [26, 28, 29],
      'android.permission.READ_MEDIA_IMAGES': [28],
      'android.permission.READ_MEDIA_VIDEO': [29],
      'android.permission.RECORD_AUDIO': [30],
      'android.permission.GET_PACKAGE_SIZE': [26],
      'android.permission.ACCESS_NETWORK_STATE': [27],
      'android.permission.ACCESS_WIFI_STATE': [2],
      'android.permission.CAMERA': [28],
    };
    
    try {
      final List<dynamic> requestedPermissions = await platform.invokeMethod(
        'getPackagePermissions',
        {'packageName': packageName}
      );
      
      Set<int> requestedPoints = {};
      for (String permission in requestedPermissions.cast<String>()) {
        if (permissionToDataPoints.containsKey(permission)) {
          requestedPoints.addAll(permissionToDataPoints[permission]!);
        }
      }
      
      developer.log('Raw Requested Permissions: ${requestedPermissions.join(", ")}', 
        name: 'DataAccess');
        
      return requestedPoints;
    } catch (e) {
      developer.log('Error getting requested permissions: $e', name: 'DataAccess');
      rethrow;
    }
  }

  Future<Set<int>> getGrantedDataPoints(String packageName) async {
    // Map Android permissions to permission_handler permissions and data points
    final Map<String, Map<Permission, List<int>>> androidToHandlerMapping = {
      'android.permission.ACCESS_FINE_LOCATION': {Permission.location: [1, 2]},
      'android.permission.ACCESS_COARSE_LOCATION': {Permission.location: [2, 3]},
      'android.permission.ACCESS_BACKGROUND_LOCATION': {Permission.locationAlways: [5]},
      'android.permission.BLUETOOTH_SCAN': {Permission.bluetoothScan: [4]},
      'android.permission.BLUETOOTH_CONNECT': {Permission.bluetoothConnect: [4]},
      'android.permission.ACTIVITY_RECOGNITION': {Permission.activityRecognition: [8]},
      'android.permission.READ_EXTERNAL_STORAGE': {Permission.storage: [26, 28, 29]},
      'android.permission.READ_MEDIA_IMAGES': {Permission.photos: [28]},
      'android.permission.READ_MEDIA_VIDEO': {Permission.videos: [29]},
      'android.permission.RECORD_AUDIO': {Permission.microphone: [30]},
      'android.permission.CAMERA': {Permission.camera: [28]},
    };
    
    try {
      // Get requested permissions first
      final List<dynamic> requestedPermissions = await platform.invokeMethod(
        'getPackagePermissions',
        {'packageName': packageName}
      );
      
      Set<int> grantedPoints = {};
      Map<Permission, bool> permissionStatuses = {};
      
      // Only check permissions that are actually requested
      for (String androidPermission in requestedPermissions.cast<String>()) {
        if (androidToHandlerMapping.containsKey(androidPermission)) {
          final mappings = androidToHandlerMapping[androidPermission]!;
          for (var entry in mappings.entries) {
            try {
              final status = await entry.key.status;
              permissionStatuses[entry.key] = status.isGranted;
              if (status.isGranted) {
                grantedPoints.addAll(entry.value);
              }
            } catch (e) {
              developer.log('Error checking permission ${entry.key}: $e', 
                name: 'DataAccess');
              continue;
            }
          }
        }
      }
      
      // Add auto-granted permissions if requested
      if (requestedPermissions.contains('android.permission.ACCESS_NETWORK_STATE')) {
        grantedPoints.add(27);
      }
      if (requestedPermissions.contains('android.permission.ACCESS_WIFI_STATE')) {
        grantedPoints.add(2);
      }
      
      developer.log('Permission Statuses: ${permissionStatuses.toString()}', 
        name: 'DataAccess');
        
      return grantedPoints;
    } catch (e) {
      developer.log('Error getting granted permissions: $e', name: 'DataAccess');
      rethrow;
    }
  }

  void logPermissionResults(Set<int> requestedPoints, Set<int> grantedPoints) {
    final Map<int, Map<String, String>> dataPoints = {
      1: {'category': 'Location Services', 'name': 'GPS Data'},
      2: {'category': 'Location Services', 'name': 'Wi-Fi Data'},
      3: {'category': 'Location Services', 'name': 'Cellular Network Data'},
      4: {'category': 'Location Services', 'name': 'Bluetooth Data'},
      5: {'category': 'Location Services', 'name': 'Geofencing Data'},
      6: {'category': 'Health and Fitness Data', 'name': 'Heart Rate'},
      7: {'category': 'Health and Fitness Data', 'name': 'Blood Oxygen Levels'},
      8: {'category': 'Health and Fitness Data', 'name': 'Step Count and Distance'},
      9: {'category': 'Health and Fitness Data', 'name': 'Sleep Patterns'},
      10: {'category': 'Health and Fitness Data', 'name': 'Calorie Consumption'},
      11: {'category': 'Health and Fitness Data', 'name': 'Body Temperature'},
      12: {'category': 'Sensor Data', 'name': 'Accelerometer'},
      13: {'category': 'Sensor Data', 'name': 'Gyroscope'},
      14: {'category': 'Sensor Data', 'name': 'Magnetometer'},
      15: {'category': 'Sensor Data', 'name': 'Barometer'},
      16: {'category': 'Sensor Data', 'name': 'Ambient Light Sensor'},
      17: {'category': 'Sensor Data', 'name': 'Proximity Sensor'},
      18: {'category': 'Application Usage Data', 'name': 'App Usage Time'},
      19: {'category': 'Application Usage Data', 'name': 'App Crashes and Errors'},
      20: {'category': 'Application Usage Data', 'name': 'App Interactions'},
      21: {'category': 'Application Usage Data', 'name': 'App Permissions Granted'},
      22: {'category': 'Device Information', 'name': 'Device Model and Manufacturer'},
      23: {'category': 'Device Information', 'name': 'Operating System Version'},
      24: {'category': 'Device Information', 'name': 'Device ID'},
      25: {'category': 'Device Information', 'name': 'Battery Level and Usage'},
      26: {'category': 'Device Information', 'name': 'Storage Usage'},
      27: {'category': 'Device Information', 'name': 'Network Connectivity'},
      28: {'category': 'User Behavior and Preferences', 'name': 'Search Queries'},
      29: {'category': 'User Behavior and Preferences', 'name': 'Browser History'},
      30: {'category': 'User Behavior and Preferences', 'name': 'Voice Commands'},
      31: {'category': 'User Behavior and Preferences', 'name': 'App Store Purchases'},
      32: {'category': 'User Behavior and Preferences', 'name': 'Social Media Activity'},
      33: {'category': 'User Behavior and Preferences', 'name': 'Email and Messaging'},
      34: {'category': 'Financial Data', 'name': 'Payment Information'},
      35: {'category': 'Financial Data', 'name': 'Transaction History'},
      36: {'category': 'Financial Data', 'name': 'Bank Account Information'},
    };

    String currentCategory = '';
    StringBuffer output = StringBuffer('Google Maps Data Access Analysis\n\n');

    for (var i = 1; i <= 36; i++) {
      var dataPoint = dataPoints[i]!;
      
      if (currentCategory != dataPoint['category']) {
        currentCategory = dataPoint['category']!;
        output.write('\n${currentCategory}:\n');
      }
      
      bool isRequested = requestedPoints.contains(i);
      bool isGranted = grantedPoints.contains(i);
      String status = isRequested ? (isGranted ? '✓ Granted' : '! Requested') : '- No Access';
      
      output.write('${i.toString().padLeft(2)}. ${dataPoint['name']?.padRight(35)} $status\n');
    }

    final percentage = requestedPoints.isEmpty ? 0.0 :
        (grantedPoints.length / requestedPoints.length * 100);
    
    output.write('\nSummary:\n');
    output.write('* Total Requested: ${requestedPoints.length}/36\n');
    output.write('* Total Granted: ${grantedPoints.length}/36\n');
    output.write('* Permission Coverage: ${percentage.toStringAsFixed(1)}%\n');

    developer.log(output.toString(), name: 'DataAccess');
  }
}