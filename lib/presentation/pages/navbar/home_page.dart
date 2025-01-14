import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';

import '../../../icons/home_page_shield.dart';
import '../../../icons/privacy_score_gauge.dart';
import '../../../models/app_info.dart';
import '../../../services/app_permission_checker.dart';
import '../../../services/bluetooth_scanner_service.dart';
import '../../../services/installed_apps_service.dart';
import 'dart:developer' as developer;

import '../../../services/privacy_score_service.dart';
import '../../components/custom_navbar.dart';
import '../score/app_list.dart';
import '../score/privacy_score_detail.dart';
import '../shield/privacy_shield.dart';

class HomePage extends StatefulWidget {
  final String token;

  const HomePage({super.key, required this.token});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final InstalledAppsService _appsService = InstalledAppsService();
  final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  // final PermissionService _permissionService = PermissionService();
  final AppPermissionChecker appPermissionChecker = AppPermissionChecker();
  // final PrivacyScoreService privacyScoreService = PrivacyScoreService();
    final bluetoothScanner = BluetoothScanner();

  @override
  void initState() {
    super.initState();
    _checkPermissions();
  }

  Future<void> _checkPermissions() async {
    try {
      bluetoothScanner.scanDevices();
      // _appsService.getInstalledAppsWithUsage();
      // AppPermissionChecker.printStructuredPermissions("com.chase.sig.android");

      // privacyScoreService.getAllPrivacyData("appName", "appVector");
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
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hi John,',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Here's your Privacy Score",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  CircleAvatar(
                    backgroundColor: Colors.blue[100],
                    radius: 25,
                    child: const Icon(
                      Icons.person,
                      color: Colors.blue,
                      size: 30,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              Center(
                child: GestureDetector(
                  onTap: () {},
                  child: Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Stack(
                      clipBehavior: Clip.none, // This allows child to overflow
                      children: [
                        Positioned(
                          left:
                              -20, // Adjust these values to position the outer circle
                          right: -20,
                          top: -20,
                          bottom: -20,
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withOpacity(0.4),
                            ),
                          ),
                        ),
                        SimpleRadialGauge(value: 400),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PrivacyScoreDetail(),
                      ),
                    );
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.grey[100],
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Text(
                        'See How You Scored',
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.arrow_forward,
                          size: 20, color: Colors.black87),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 40),
              const Text(
                'Privacy Shield',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: Column(
                  children: [
                    Container(
                      width: 150,
                      height: 150,
                      child: ShaderMask(
                        shaderCallback: (Rect bounds) {
                          return LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.green.withOpacity(0.7),
                              Colors.blue.withOpacity(0.7),
                            ],
                          ).createShader(bounds);
                        },
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            PercentageShieldIcon(
                              percentage: 50,
                              color: Colors.white,
                              size: 150,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PrivacyShield(),
                          ),
                        );
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.grey[100],
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Text(
                            'What this Means',
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(width: 8),
                          Icon(Icons.arrow_forward,
                              size: 20, color: Colors.black87),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomNavBar(),
    );
  }
}

class ScoreIndicatorPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.red.withOpacity(0.7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;

    final rect = Rect.fromCircle(
      center: Offset(size.width / 2, size.height / 2),
      radius: size.width / 2 - 10,
    );

    canvas.drawArc(
      rect,
      -3.14 / 2,
      2.5,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
