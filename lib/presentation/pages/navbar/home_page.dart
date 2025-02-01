import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import '../../../services/app_info_db_loader_service.dart';
import '../../../services/app_permission_checker.dart';
import '../../../services/auth_notifier_service.dart';
import '../../../services/bluetooth_scanner_service.dart';
import '../../../services/installed_apps_service.dart';
import '../../../services/wifi_scanner_service.dart';
import '../../components/custom_navbar.dart';
import '../../components/home/header_section.dart';
import '../../components/home/privacy_score_section.dart';
import '../../components/home/privacy_shield_section.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final InstalledAppsService _appsService = InstalledAppsService();
  final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  final AppPermissionChecker appPermissionChecker = AppPermissionChecker();
  final bluetoothScanner = BluetoothScanner();
  final wifiScanner = WifiScanner();
  final AppInfoDbLoaderService _appPrivacyService = AppInfoDbLoaderService();

  @override
  void initState() {
    super.initState();
    _checkPermissions();
  }

  Future<void> _checkPermissions() async {
    try {
      await _appPrivacyService.init();
      // await _appPrivacyService.updateAppPrivacyData();
      // await _appPrivacyService.printStoredData();
      // wifiScanner.scanWifiNetworks();
      // _appsService.getInstalledAppsWithUsage();
      // AppPermissionChecker.printStructuredPermissions("com.google.android.apps.maps");
    } catch (e) {
      print('Error checking permissions: $e');
      print('Stack trace: ${StackTrace.current}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              HeaderSection(userName: "John"),
              SizedBox(height: 40),
              PrivacyScoreSection(),
              SizedBox(height: 40),
              PrivacyShieldSection(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomNavBar(),
    );
  }
}
