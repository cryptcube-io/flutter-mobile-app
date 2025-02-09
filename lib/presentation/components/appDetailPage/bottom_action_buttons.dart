import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../pages/score/faq_screen.dart';
import '../../pages/score/privacy_toolkit.dart';

class BottomActionButtons extends StatelessWidget {
  final String appName;
  final Uint8List? iconBytes;
  
  const BottomActionButtons({super.key, required this.appName,this.iconBytes,});

  Widget _buildButton(String text, IconData icon, {required VoidCallback onTap}) {
    return Card(
      margin: EdgeInsets.zero,
      color: const Color(0xFFEEEDFC),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 20, color: const Color(0xFF6044de)),
              const SizedBox(width: 8),
              Text(
                text,
                style: const TextStyle(
                  color: Color(0xFF6044de),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
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
                    builder: (context) => FAQScreen(appName: appName,iconBytes: iconBytes,),
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