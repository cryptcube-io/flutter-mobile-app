import 'package:flutter/material.dart';

class ResponsiveText {
  static double scale(BuildContext context, double size) {
    final width = MediaQuery.of(context).size.width;
    final scaleFactor = width / 375; // Base on iPhone 8 width
    
    // Constrain the scale factor to prevent text from becoming too small or too large
    final constrainedScale = scaleFactor.clamp(0.8, 1.2);
    
    return size * constrainedScale;
  }
  
  static TextStyle scaleTextStyle(BuildContext context, TextStyle style) {
    return style.copyWith(
      fontSize: scale(context, style.fontSize ?? 14),
    );
  }
}