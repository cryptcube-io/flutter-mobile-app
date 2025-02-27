import 'package:flutter/material.dart';
import '../../../config/theme/app_colors.dart';
import '../../components/custom_navbar.dart';
import '../../components/shared/header.dart';

class PrivacyScoreFactors extends StatelessWidget {
  const PrivacyScoreFactors({super.key});

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
                title: 'Privacy Score Factors',
                onBackPressed: () => Navigator.pop(context),
              ),
              Expanded(
                child: Container(
                  color: AppColors.contentAreaBackground,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        _buildFactorCard(
                          title: 'Data Collection',
                          description: 'Data Collection Practices: Apps receive scores based on the types and amount of personal data they collect. Apps that collect only necessary data and provide clear explanations score higher than those collecting excessive information.',
                          backgroundColor: Color(0xFFFFE4E4),
                          iconColor: Colors.red,
                          icon: Icons.social_distance,
                        ),
                        const SizedBox(height: 20),
                        _buildFactorCard(
                          title: 'Data Sharing',
                          description: 'Third-Party Data Sharing: Your privacy score considers how apps share your data with external partners and advertisers. Apps with minimal third-party sharing and strong data protection policies receive better ratings.',
                          backgroundColor: Color(0xFFE4F5FF),
                          iconColor: Colors.blue,
                          icon: Icons.people_outline,
                        ),
                        const SizedBox(height: 20),
                        _buildFactorCard(
                          title: 'Security',
                          description: 'Security Measures: The strength of an app\'s security features impacts your privacy score. This includes encryption practices, secure data storage, regular security updates, and protection against unauthorized access to your personal information.',
                          backgroundColor: Color(0xFFE8FFE4),
                          iconColor: Colors.green,
                          icon: Icons.security,
                        ),
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

  Widget _buildFactorCard({
    required String title,
    required String description,
    required Color backgroundColor,
    required Color iconColor,
    required IconData icon,
  }) {
    return Card(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 3,
                  child: Text(
                    description,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                      height: 1.5,
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    icon,
                    size: 40,
                    color: iconColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}