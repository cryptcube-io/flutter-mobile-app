import 'package:flutter/material.dart';

import '../../../icons/privacy_score_gauge.dart';

class PrivacyScoreGaugeCard extends StatelessWidget {
  final double value;

  const PrivacyScoreGaugeCard({required this.value, super.key});

  @override
  Widget build(BuildContext context) {
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
          PrivacyScoreGauge(value: value),
        ],
      ),
    );
  }
}