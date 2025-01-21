import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PercentageShieldIcon extends StatelessWidget {
  final double percentage;
  final Color color;
  final double size;

  const PercentageShieldIcon({
    required this.percentage,
    this.color = CupertinoColors.systemBlue,
    this.size = 24.0,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Icon(
            CupertinoIcons.shield,
            size: size,
            color: color.withOpacity(0.3),
          ),
          ClipRect(
            child: Align(
              alignment: Alignment.bottomCenter,
              heightFactor: percentage / 100,
              child: Icon(
                CupertinoIcons.shield_fill,
                size: size,
                color: color,
              ),
            ),
          ),
          Center(
            // Center the text
            child: Text(
              '${percentage.round()}%', 
              style: TextStyle(
                fontSize: size * 0.20, 
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
