import 'package:flutter/material.dart';
import 'app_text_styles.dart';

class H1 extends StatelessWidget {
  final String text;
  final TextAlign? textAlign;
  final TextOverflow? overflow;
  final int? maxLines;

  const H1(this.text, {super.key, this.textAlign, this.overflow, this.maxLines});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppTextStyles.headingH1,
      textAlign: textAlign,
      overflow: overflow,
      maxLines: maxLines,
    );
  }
}

class ParagraphLarge extends StatelessWidget {
  final String text;
  final TextAlign? textAlign;
  final TextOverflow? overflow;
  final int? maxLines;

  const ParagraphLarge(this.text, {super.key, this.textAlign, this.overflow, this.maxLines});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppTextStyles.paragraphLarge,
      textAlign: textAlign,
      overflow: overflow,
      maxLines: maxLines,
    );
  }
}