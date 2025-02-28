import 'package:flutter/material.dart';
import 'app_text_styles.dart';

extension TextStyleExtensions on BuildContext {
  TextStyle get headingH1 => AppTextStyles.headingH1;
  TextStyle get headingH2 => AppTextStyles.headingH2;
  TextStyle get headingH3 => AppTextStyles.headingH3;
  TextStyle get headingH4 => AppTextStyles.headingH4;
  TextStyle get headingH5 => AppTextStyles.headingH5;
  TextStyle get headingH6 => AppTextStyles.headingH6;
  TextStyle get paragraphLarge => AppTextStyles.paragraphLarge;
  TextStyle get paragraphMedium => AppTextStyles.paragraphMedium;
  TextStyle get paragraphSmall => AppTextStyles.paragraphSmall;
  TextStyle get labelMedium => AppTextStyles.labelMedium;
  TextStyle get labelSmall => AppTextStyles.labelSmall;
  TextStyle get labelXSmall => AppTextStyles.labelXSmall;
}