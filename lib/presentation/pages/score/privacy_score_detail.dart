import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'dart:typed_data';

import '../../../config/theme/app_colors.dart';
import '../../../models/app_data.dart';
import '../../../services/logger_service.dart';
import '../../components/custom_navbar.dart';
import '../../components/privacyScoreDetails/app_list_item.dart';
import '../../components/privacyScoreDetails/privacy_factor_card.dart';
import '../../components/privacyScoreDetails/privacy_score_gauge_card.dart';
import '../../components/shared/header.dart';
import '../../components/shared/standard_button.dart';
import '../../../icons/privacy_score_gauge.dart';
import '../../../services/app_icon_manager.dart';
import '../../../services/app_loader_service.dart';
import 'app_detail.dart';
import 'app_list.dart';
import 'privacy_score_factors.dart';

class PrivacyScoreDetail extends ConsumerStatefulWidget {
  const PrivacyScoreDetail({super.key});

  @override
  ConsumerState<PrivacyScoreDetail> createState() => _PrivacyScoreDetailState();
}

class _PrivacyScoreDetailState extends ConsumerState<PrivacyScoreDetail> with LoggerMixin {
  final Dio _dio = Dio();
  final AppIconManager _iconManager = AppIconManager();
  final AppLoaderService _appLoader = AppLoaderService();
  List<AppData> apps = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadApps();
  }

  Future<void> _loadApps() async {
    try {
      final appItems = await _appLoader.loadApps('your_token_here', pageSize: 3);
      setState(() {
        apps = appItems
            .map((item) => AppData(
                  item.name,
                  int.parse(item.score.split('/')[0]),
                  item.packageName,
                  item.iconBytes,
                ))
            .toList();
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        color: Colors.white,
        child: SafeArea(
          child: Column(
            children: [
              CustomHeader(
                title: 'Report Details',
                onBackPressed: () => Navigator.pop(context),
              ),
              Expanded(
                child: Container(
                  color: AppColors.contentAreaBackground,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const PrivacyScoreGaugeCard(value: 600),
                        const SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AppsListSection(
                                apps: apps,
                                isLoading: isLoading,
                                onViewAllTapped: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const AppList(),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              PrivacyFactorCard(
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const PrivacyScoreFactors(),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
             CustomNavBar(),
            ],
          ),
        ),
      ),
    );
  }
}