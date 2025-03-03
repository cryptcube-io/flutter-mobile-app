import 'package:Cryptcube_mobile_app/core/theme/colors/app_colors.dart';
import 'package:flutter/material.dart';
import '../../../core/theme/typography/app_text_styles.dart';

class IntroductionTextSection extends StatelessWidget {
  const IntroductionTextSection({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        children: [
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: AppTextStyles.headingH4.copyWith(color: Colors.white),
              children: [
                const TextSpan(text: "Hi, I am "),
                TextSpan(
                  text: "Bagheera",
                  style: AppTextStyles.headingH4.copyWith(color: Colors.purple),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            "Welcome! I'm here to help you understand a wide range of privacy-related topics—from data security and personal information protection to privacy settings. Just choose an app below, and let's get started.",
            textAlign: TextAlign.center,
            style: AppTextStyles.paragraphLarge.copyWith(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}