import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import '../../../config/api_endpoints.dart';
import '../../../services/auth_notifier_service.dart';
import '../../../services/logger_service.dart';
import '../../pages/score/privacy_score_detail.dart';
import '../../../icons/privacy_score_gauge.dart';

class PrivacyScoreSection extends ConsumerStatefulWidget {
  const PrivacyScoreSection({super.key});

  @override
  ConsumerState<PrivacyScoreSection> createState() => _PrivacyScoreSectionState();
}

class _PrivacyScoreSectionState extends ConsumerState<PrivacyScoreSection> with LoggerMixin {
  int privacyScore = 660;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    logInfo('Initializing PrivacyScoreSection');
    fetchPrivacyScore();
  }

  Future<void> fetchPrivacyScore() async {
    logInfo('Fetching privacy score');
    final token = ref.read(authProvider).token;
    
    if (token == null) {
      logError('Auth token is null, cannot fetch privacy score');
      return;
    }

    final dio = Dio();
    try {
      logDebug('Making API request to ${ApiEndpoints.getOverallPrivacyScore}');
      final response = await dio.get(
        ApiEndpoints.getOverallPrivacyScore,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        logInfo('Successfully fetched privacy score: ${response.data}');
        setState(() {
          privacyScore = response.data;
          isLoading = false;
        });
      } else {
        logError('Failed to fetch privacy score. Status code: ${response.statusCode}');
        setState(() => isLoading = false);
      }
    } catch (e, stackTrace) {
      logError('Error fetching privacy score', e, stackTrace);
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    logDebug('Building PrivacyScoreSection, isLoading: $isLoading, score: $privacyScore');
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Hi John,',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          RichText(
            text: TextSpan(
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              children: [
                const TextSpan(text: 'Your Privacy is '),
                TextSpan(
                  text: 'Good',
                  style: TextStyle(color: Color(0xFF6044de)),
                ),
                const TextSpan(text: '.'),
              ],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'A score of 660 is fairly decent - congratulations.',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 25),
          if (isLoading)
            const Center(child: CircularProgressIndicator())
          else
            Column(
              children: [
                PrivacyScoreGauge(value: privacyScore.toDouble()),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    logInfo('Navigating to PrivacyScoreDetail');
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PrivacyScoreDetail(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6C5CE7),
                    minimumSize: const Size(double.infinity, 48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'View Report',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}