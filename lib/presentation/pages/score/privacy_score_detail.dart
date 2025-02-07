import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import '../../../config/api_endpoints.dart';
import '../../../services/auth_notifier_service.dart';
import '../../components/custom_navbar.dart';
import '../../components/shared/standard_button.dart';
import '../../../icons/privacy_score_gauge.dart';
import 'app_list.dart';
import 'privacy_score_factors.dart';

class PrivacyScoreDetail extends ConsumerStatefulWidget {
  const PrivacyScoreDetail({super.key});

  @override
  ConsumerState<PrivacyScoreDetail> createState() => _PrivacyScoreDetailState();
}

class _PrivacyScoreDetailState extends ConsumerState<PrivacyScoreDetail> {
  final Dio _dio = Dio();
  List<AppData> apps = [
    AppData('TikTok', 310),
    AppData('Facebook', 390),
    AppData('Instagram', 491),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Report Details',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      _buildScoreCard(),
                      const SizedBox(height: 24),
                      _buildAppsList(),
                      const SizedBox(height: 16),
                      _buildPrivacyFactorCard(),
                    ],
                  ),
                ),
              ),
            ),
            CustomNavBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildScoreCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blue.shade100),
        borderRadius: BorderRadius.circular(12),
      ),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Apps Affecting Your Score (${apps.length})',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 16),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: apps.length,
          itemBuilder: (context, index) {
            return _buildAppItem(apps[index]);
          },
        ),
        const SizedBox(height: 16),
        StandardButton(
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
      ],
    );
  }

  Widget _buildAppItem(AppData app) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Icon(Icons.apps),
      ),
      title: Text(app.name),
      subtitle: Text('Privacy Score: ${app.score}/800'),
      trailing: const Icon(Icons.chevron_right),
    );
  }

  Widget _buildPrivacyFactorCard() {
    return InkWell(
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
        trailing: Container(
          padding: const EdgeInsets.all(8),
          decoration: const BoxDecoration(
            color: Colors.amber,
            shape: BoxShape.circle,
          ),
          child: const Text(
            'S',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}

class AppData {
  final String name;
  final int score;
  AppData(this.name, this.score);
}