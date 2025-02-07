import 'package:flutter/material.dart';

class StandardButton extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;
  final bool isFullWidth;

  const StandardButton({
    super.key,
    required this.text,
    this.onTap,
    this.isFullWidth = true,
  });

  @override
  Widget build(BuildContext context) {
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
          child: Center(
            child: Text(
              text,
              style: const TextStyle(
                color: Color(0xFF6044de),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}