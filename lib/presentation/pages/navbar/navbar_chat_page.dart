import 'package:flutter/material.dart';
import '../../../core/theme/colors/app_colors.dart';
import '../../../models/app_data.dart';
import '../../components/custom_navbar.dart';
import '../../components/navbarChatPage/frequently_used_apps_card.dart';
import '../../components/navbarChatPage/introduction_text_section.dart';
import '../../pages/score/app_detail.dart';

class IntroductionPage extends StatefulWidget {
  const IntroductionPage({super.key});
  
  @override
  State<IntroductionPage> createState() => _IntroductionPageState();
}

class _IntroductionPageState extends State<IntroductionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.transparent,
      body: Container(
        decoration: BoxDecoration(
          gradient: AppColors.backgroundGradient,
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 50),
              const IntroductionTextSection(),
              const SizedBox(height: 40),
              Expanded(
                child: FrequentlyUsedAppsCard(
                  onAppSelected: (AppData app) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AppDetail(
                          appName: app.name,
                          iconBytes: app.iconBytes,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomNavBar(),
    );
  }
}