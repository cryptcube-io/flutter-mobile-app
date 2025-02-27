import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import '../../../config/theme/app_colors.dart';
import '../../../services/logger_service.dart';
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

class _HomePageState extends State<HomePage> with LoggerMixin {
  final InstalledAppsService _appsService = InstalledAppsService();
  final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  final AppPermissionChecker appPermissionChecker = AppPermissionChecker();
  final bluetoothScanner = BluetoothScanner();
  final wifiScanner = WifiScanner();
  final AppInfoDbLoaderService _appPrivacyService = AppInfoDbLoaderService();

  @override
  void initState() {
    super.initState();
    logInfo('HomePage initialized');
    _checkPermissions();
  }

  Future<void> _checkPermissions() async {
    try {
      logInfo('Starting permission checks');
      await _appPrivacyService.init();
      logInfo('App privacy service initialized successfully');
    } catch (e, stackTrace) {
      logError('Error checking permissions', e, stackTrace);
    }
  }

  @override
  Widget build(BuildContext context) {
    logDebug('Building HomePage widget');
    return Scaffold(
      backgroundColor: AppColors.transparent,
      body: Container(
        decoration: BoxDecoration(
          gradient: AppColors.backgroundGradient,
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 80),
                PrivacyScoreSection(),
                SizedBox(height: 20),
                PrivacyShieldSection(),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: CustomNavBar(),
    );
  }

  @override
  void dispose() {
    logInfo('HomePage disposing');
    super.dispose();
  }
}