import 'package:Cryptcube_mobile_app/icons/home_page_shield.dart';
import 'package:flutter/material.dart';

import '../shared/standard_button.dart';

class PrivacyShieldSection extends StatelessWidget {
  const PrivacyShieldSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFFFFFFFF),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Privacy Shield',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Lorem ipsum dolor amet, consectetur adipiscing elit. Parturient suspendisse ipsum mi scelerisque nascetur present molestie.',
                        style: TextStyle(
                          color: Colors.grey[600],
                          height: 1.4,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            const Color(0xFFe1dcf7),
                            const Color(0xFFeee6f5),
                            const Color(0xFFfbeff3),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          PercentageShieldIcon(percentage: 75),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          StandardButton(
            text: 'What this Means?',
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
