import 'package:flutter/material.dart';
import '../../../services/wifi_scanner_service.dart';
import '../../components/custom_navbar.dart';
import '../../components/home/header_section.dart';
import '../../components/home/privacy_score_section.dart';
import '../../components/home/privacy_shield_section.dart';

class HomePage extends StatefulWidget {
  final String token;

  const HomePage({super.key, required this.token});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final wifiScanner = WifiScanner();

  @override
  void initState() {
    super.initState();
    _checkPermissions();
  }

  Future<void> _checkPermissions() async {
    try {
      wifiScanner.scanWifiNetworks();
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
            children: const [
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
      bottomNavigationBar:  CustomNavBar(),
    );
  }
}