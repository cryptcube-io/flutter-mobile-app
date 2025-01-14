import 'package:flutter/material.dart';

class AppHeaderSection extends StatelessWidget {
  final String appName;

  const AppHeaderSection({super.key, required this.appName});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        appName,
        style: const TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}