import 'package:flutter/material.dart';

import '../../../constants/enums.dart';



class StandardButton extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;
  final bool isFullWidth;
  final double? width;
  final double? height;
  final ButtonType type;

  const StandardButton({
    super.key,
    required this.text,
    this.onTap,
    this.isFullWidth = true,
    this.width,
    this.height,
    this.type = ButtonType.primary,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: isFullWidth ? double.infinity : width,
      height: height,
      child: Card(
        margin: EdgeInsets.zero,
        color: type == ButtonType.primary ? const Color(0xFF5A4BD0) : const Color(0xFFDED8F8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  text,
                  style: TextStyle(
                    color: type == ButtonType.primary ? Colors.white : const Color(0xFF5A4BD0),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  Icons.chevron_right,
                  color: type == ButtonType.primary ? Colors.white : const Color(0xFF5A4BD0),
                  size: 18,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}