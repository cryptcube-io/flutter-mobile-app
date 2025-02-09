import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'dart:typed_data';

import '../../../config/theme/app_colors.dart';
import '../../components/custom_navbar.dart';
import '../../components/shared/header.dart';
import '../../components/shared/standard_button.dart';
import '../../../icons/privacy_score_gauge.dart';
import '../../../services/app_icon_manager.dart';
import '../../../services/app_loader_service.dart';
import 'app_detail.dart';
import 'app_list.dart';
import 'privacy_score_factors.dart';

class PrivacyScoreDetail extends ConsumerStatefulWidget {
  const PrivacyScoreDetail({super.key});

  @override
  ConsumerState<PrivacyScoreDetail> createState() => _PrivacyScoreDetailState();
}

class _PrivacyScoreDetailState extends ConsumerState<PrivacyScoreDetail> {
  final Dio _dio = Dio();
  final AppIconManager _iconManager = AppIconManager();
  final AppLoaderService _appLoader = AppLoaderService();
  List<AppData> apps = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadApps();
  }

  Future<void> _loadApps() async {
    try {
      final appItems = await _appLoader.loadApps('your_token_here', pageSize: 3);
      setState(() {
        apps = appItems.map((item) => AppData(
          item.name,
          int.parse(item.score.split('/')[0]),
          item.packageName,
          item.iconBytes,
        )).toList();
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        color: Colors.white,
        child: SafeArea(
          child: Column(
            children: [
              CustomHeader(
                title: 'Report Details',
                onBackPressed: () => Navigator.pop(context),
              ),
              Expanded(
                child: Container(
                  color: AppColors.contentAreaBackground,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildScoreCard(),
                        const SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildAppsList(),
                              const SizedBox(height: 16),
                              _buildPrivacyFactorCard(),
                              const SizedBox(height: 16),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              CustomNavBar(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildScoreCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const Text(
            'Your Privacy Score',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 34),
          PrivacyScoreGauge(value: 660),
        ],
      ),
    );
  }

  Widget _buildAppsList() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 0,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 8),
            child: Text(
              'Apps Affecting Your Score (${isLoading ? "..." : apps.length})',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: Color(0xFF6B7280),
                height: 1.5,
                letterSpacing: 0,
                fontFamily: 'body',
              ),
            ),
          ),
          if (isLoading)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 32),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          else ...[
            for (int i = 0; i < apps.length; i++) ...[
              _buildAppItem(apps[i]),
              if (i < apps.length - 1)
                const Divider(height: 1, indent: 16, endIndent: 16),
            ],
          ],
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: StandardButton(
              text: 'View All Apps',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AppList(),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildAppItem(AppData app) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      leading: SizedBox(
        width: 48,
        height: 48,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: app.iconBytes != null
              ? Image.memory(
                  app.iconBytes!,
                  width: 48,
                  height: 48,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return _buildFallbackIcon(app.name);
                  },
                )
              : _buildFallbackIcon(app.name),
        ),
      ),
      title: Text(
        app.name,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: RichText(
        text: TextSpan(
          text: 'Privacy Score: ',
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w300,
            height: 1.0,
            letterSpacing: 0,
            color: Colors.black87,
          ),
          children: [
            TextSpan(
              text: '${app.score}',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                height: 1.0,
                letterSpacing: 0,
                color: Colors.black87,
              ),
            ),
            TextSpan(
              text: '/800',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                height: 1.0,
                letterSpacing: 0,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: Colors.grey,
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AppDetail(
              appName: app.name,
              iconBytes: app.iconBytes,
            ),
          ),
        );
      },
    );
  }

  Widget _buildFallbackIcon(String appName) {
    return Container(
      color: getAppColor(appName),
      child: Icon(
        _iconManager.getFallbackIcon(appName),
        color: Colors.white,
        size: 30,
      ),
    );
  }

  Color getAppColor(String appName) {
    switch (appName.toLowerCase()) {
      case 'tiktok':
        return Colors.black87;
      case 'facebook':
        return const Color(0xFF1877F2);
      case 'instagram':
        return const Color(0xFFE4405F);
      case 'whatsapp':
        return const Color(0xFF25D366);
      case 'youtube':
        return const Color(0xFFFF0000);
      case 'cryptcube_mobile_app':
        return const Color(0xFF00E5FF);
      default:
        return Colors.grey.shade200;
    }
  }

  Widget _buildPrivacyFactorCard() {
    return Card(
      color: Colors.white,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const PrivacyScoreFactors(),
            ),
          );
        },
        child: ListTile(
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.security, color: Color(0xFF6C5CE7)),
          ),
          title: const Text('Privacy Score Factor'),
          subtitle: const Text('Lorem ipsum has been the industry\'s'),
        ),
      ),
    );
  }
}

class AppData {
  final String name;
  final int score;
  final String packageName;
  final Uint8List? iconBytes;

  AppData(this.name, this.score, this.packageName, this.iconBytes);
}