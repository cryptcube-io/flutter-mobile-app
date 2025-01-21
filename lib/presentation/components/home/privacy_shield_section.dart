import 'package:flutter/material.dart';
import '../../../icons/home_page_shield.dart';
import '../../pages/shield/privacy_shield.dart';

class PrivacyShieldSection extends StatelessWidget {
  const PrivacyShieldSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
              SizedBox(
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
                  child: const Stack(
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
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PrivacyShield(),
                  ),
                ),
                style: TextButton.styleFrom(
                  backgroundColor: Colors.grey[100],
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
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
                    Icon(Icons.arrow_forward, size: 20, color: Colors.black87),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}