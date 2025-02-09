import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import '../../../config/api_endpoints.dart';
import '../../../config/theme/app_colors.dart';
import '../../../services/auth_notifier_service.dart';
import '../../components/appDetailPage/app_score_card.dart';
import '../../components/appDetailPage/bottom_action_buttons.dart';
import '../../components/appDetailPage/data_collection_section.dart';
import '../../components/custom_navbar.dart';
import '../../components/shared/header.dart';

class AppDetail extends ConsumerStatefulWidget {
  final String appName;
  const AppDetail({super.key, required this.appName});

  @override
  ConsumerState<AppDetail> createState() => _AppDetailState();
}

class _AppDetailState extends ConsumerState<AppDetail> {
  final Dio _dio = Dio();
  String explanation = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchExplanation();
  }

  Future<void> _fetchExplanation() async {
    try {
      final token = ref.read(authProvider).token;
      if (token == null) return;

      final response = await _dio.get(
        ApiEndpoints.getApplicationScoreExplanation,
        queryParameters: {
          'appName': widget.appName,
          'appVector': widget.appName,
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
                title: 'App Details',
                onBackPressed: () => Navigator.pop(context),
              ),
              Expanded(
                child: Container(
                  color: AppColors.contentAreaBackground,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        const AppScoreCard(),
                        const SizedBox(height: 24),
                        // if (isLoading)
                        //   const Center(
                        //     child: Padding(
                        //       padding: EdgeInsets.symmetric(horizontal: 20),
                        //       child: CircularProgressIndicator(),
                        //     ),
                        //   )
                        // else if (explanation.isNotEmpty)
                        //   Padding(
                        //     padding: const EdgeInsets.symmetric(horizontal: 20),
                        //     child: Container(
                        //       width: double.infinity,
                        //       padding: const EdgeInsets.all(16),
                        //       decoration: BoxDecoration(
                        //         color: Colors.grey[100],
                        //         borderRadius: BorderRadius.circular(12),
                        //         boxShadow: [
                        //           BoxShadow(
                        //             color: Colors.grey.withOpacity(0.1),
                        //             spreadRadius: 2,
                        //             blurRadius: 4,
                        //             offset: const Offset(0, 2),
                        //           ),
                        //         ],
                        //       ),
                        //       child: Text(
                        //         explanation,
                        //         style: const TextStyle(
                        //           fontSize: 16,
                        //           color: Colors.black87,
                        //           height: 1.5,
                        //         ),
                        //       ),
                        //     ),
                        //   ),
                        const SizedBox(height: 24),
                        const DataCollectionSection(),
                        const SizedBox(height: 24),
                        BottomActionButtons(appName: widget.appName),
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