import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import '../../../config/api_endpoints.dart';
import '../../../services/auth_notifier_service.dart';
import '../../../services/logger_service.dart';
import '../../pages/score/privacy_score_detail.dart';
import '../../../icons/privacy_score_gauge.dart';
import 'package:logging/logging.dart';

class PrivacyScoreSection extends ConsumerStatefulWidget {
  const PrivacyScoreSection({super.key});

  @override
  ConsumerState<PrivacyScoreSection> createState() =>
      _PrivacyScoreSectionState();
}

class _PrivacyScoreSectionState extends ConsumerState<PrivacyScoreSection>
    with LoggerMixin {
  int privacyScore = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    logInfo('Initializing PrivacyScoreSection');
    fetchPrivacyScore();
  }

  Future<void> fetchPrivacyScore() async {
    final token = ref.read(authProvider).token;
    if (token == null) {
      logError('Token is null, cannot fetch privacy score');
      return;
    }

    final dio = Dio();
    try {
      logDebug(
          'Fetching privacy score from ${ApiEndpoints.getOverallPrivacyScore}');
      final response = await dio.get(
        ApiEndpoints.getOverallPrivacyScore,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        logInfo('Successfully fetched privacy score: ${response.data}');
        setState(() {
          privacyScore = response.data;
          isLoading = false;
        });
      } else {
        logError(
            'Failed to fetch privacy score. Status code: ${response.statusCode}');
        setState(() {
          isLoading = false;
        });
      }
    } catch (e, stackTrace) {
      logError('Error fetching privacy score', e, stackTrace);
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    logDebug('Building PrivacyScoreSection widget');
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24),
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
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isLoading)
            const SizedBox(
              height: 200,
              child: Center(child: CircularProgressIndicator()),
            )
          else
            Column(
              children: [
                SimpleRadialGauge(value: privacyScore.toDouble()),
                Transform.translate(
                  offset: const Offset(0, -40),
                  child: const Column(
                    children: [
                      Text(
                        'Good',
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF6C5CE7),
                        ),
                      ),
                      Text(
                        '0 pts',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '100',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      '850',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
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
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
        ],
      ),
    );
  }
}
