import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'dart:typed_data';
import 'package:device_apps/device_apps.dart';
import '../../../constants/api_endpoints.dart';
import '../../../core/theme/colors/app_colors.dart';
import '../../../services/auth_notifier_service.dart';
import '../../../services/app_icon_manager.dart';
import '../../components/appDetailPage/app_score_card.dart';
import '../../components/appDetailPage/bottom_action_buttons.dart';
import '../../components/appDetailPage/data_collection_section.dart';
import '../../components/custom_navbar.dart';
import '../../components/shared/header.dart';

class AppDetail extends ConsumerStatefulWidget {
  final String appName;
  final Uint8List? iconBytes;
  
  const AppDetail({
    super.key, 
    required this.appName,
    this.iconBytes,
  });

  @override
  ConsumerState<AppDetail> createState() => _AppDetailState();
}

class _AppDetailState extends ConsumerState<AppDetail> {
  final Dio _dio = Dio();
  final AppIconManager _iconManager = AppIconManager();
  String explanation = '';
  bool isLoading = true;
  String? packageName;

  @override
  void initState() {
    super.initState();
    _fetchPackageName();
  }

  Future<void> _fetchPackageName() async {
    List<Application> apps = await DeviceApps.getInstalledApplications(includeAppIcons: false, includeSystemApps: true);
    for (var app in apps) {
      if (app.appName.toLowerCase() == widget.appName.toLowerCase()) {
        setState(() {
          packageName = app.packageName;
        });
        _fetchExplanation();
        return;
      }
    }
    setState(() {
      isLoading = false;
    });
  }

  Future<void> _fetchExplanation() async {
    if (packageName == null) return;
    try {
      final token = ref.read(authProvider).token;
      if (token == null) return;

      final response = await _dio.get(
        ApiEndpoints.getApplicationScoreExplanation,
        queryParameters: {
          'appName': widget.appName,
          'appVector': packageName,
        },
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
          responseType: ResponseType.plain,
        ),
      );

      if (response.statusCode == 200) {
        setState(() {
          explanation = response.data.toString();
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching explanation: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Widget _buildAppHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
      child: Column(
        children: [
          SizedBox(
            width: 80,
            height: 80,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: widget.iconBytes != null
                  ? Image.memory(
                      widget.iconBytes!,
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: const Color(0xFF6044de),
                          child: Icon(
                            _iconManager.getFallbackIcon(widget.appName),
                            color: Colors.white,
                            size: 40,
                          ),
                        );
                      },
                    )
                  : Container(
                      color: const Color(0xFF6044de),
                      child: Icon(
                        _iconManager.getFallbackIcon(widget.appName),
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            widget.appName,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Text(
        'Error loading app details',
        style: TextStyle(
          color: Colors.red[700],
          fontSize: 16,
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildAppHeader(),
        const SizedBox(height: 5),
        const AppScoreCard(),
        const SizedBox(height: 15),
        // if (explanation.isNotEmpty) Padding(
        //   padding: const EdgeInsets.symmetric(horizontal: 16),
        //   child: Text(
        //     explanation,
        //     style: const TextStyle(
        //       fontSize: 14,
        //       color: Colors.black87,
        //       height: 1.5,
        //     ),
        //   ),
        // ),
        const SizedBox(height: 8),
        const DataCollectionSection(),
        const SizedBox(height: 20),
        BottomActionButtons(appName: widget.appName,iconBytes: widget.iconBytes),
      ],
    );
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
                title: 'App Info',
                onBackPressed: () => Navigator.pop(context),
              ),
              Expanded(
                child: Container(
                  color: AppColors.contentAreaBackground,
                  child: isLoading
                      ? _buildLoadingState()
                      : packageName == null
                          ? _buildErrorState()
                          : SingleChildScrollView(
                              child: _buildContent(),
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