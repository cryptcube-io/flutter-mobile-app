import 'package:flutter/material.dart';
import '../../components/appDetailPage/app_score_card.dart';
import '../../components/appDetailPage/bottom_action_buttons.dart';
import '../../components/appDetailPage/data_collection_section.dart';
import '../../components/appDetailPage/header_section.dart';
import '../../components/custom_navbar.dart';


class AppDetail extends StatefulWidget {
  final String appName;
  const AppDetail({super.key, required this.appName});

  @override
  State<AppDetail> createState() => _AppDetailState();
}

class _AppDetailState extends State<AppDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    AppHeaderSection(appName: widget.appName),
                    const SizedBox(height: 20),
                    const AppScoreCard(),
                    const SizedBox(height: 24),
                    const DataCollectionSection(),
                    const SizedBox(height: 24),
                    BottomActionButtons(appName: widget.appName),
                  ],
                ),
              ),
            ),
            CustomNavBar(),
          ],
        ),
      ),
    );
  }
}