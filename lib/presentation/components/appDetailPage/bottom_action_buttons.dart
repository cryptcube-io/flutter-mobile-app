import 'package:flutter/material.dart';
import '../../pages/score/faq_screen.dart';
import '../../pages/score/privacy_toolkit.dart';

class BottomActionButtons extends StatelessWidget {
  final String appName;
  
  const BottomActionButtons({super.key, required this.appName});

  Widget _buildButton(String text, IconData icon, {required VoidCallback onTap}) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.grey[100],
        foregroundColor: Colors.black87,
        elevation: 0,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 8),
          Text(text),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: _buildButton(
              'FAQs',
              Icons.help_outline,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FAQScreen(appName: appName),
                  ),
                );
              },
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildButton(
              'Privacy Toolkit',
              Icons.build_outlined,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PrivacyToolkit(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}