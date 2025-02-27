import 'package:flutter/material.dart';

class PrivacyFactorCard extends StatelessWidget {
  final VoidCallback onTap;

  const PrivacyFactorCard({required this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      child: InkWell(
        onTap: onTap,
        child: ListTile(
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.security, color: Color(0xFF6C5CE7)),
          ),
          title: const Text(
            'Privacy Score Factor',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF111827),
            ),
          ),
          subtitle: const Text(
            'Lorem Ipsum has been the industry\'s.',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: Color(0xFF6B7280),
            ),
          ),
        ),
      ),
    );
  }
}