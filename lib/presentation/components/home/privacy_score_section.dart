import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import '../../../config/api_endpoints.dart';
import '../../../services/auth_notifier_service.dart';
import '../../../services/logger_service.dart';
import '../../pages/score/privacy_score_detail.dart';
import '../../../icons/privacy_score_gauge.dart';
import 'package:intl/intl.dart';

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
    fetchPrivacyScore();
  }

  Future<void> fetchPrivacyScore() async {
    final token = ref.read(authProvider).token;
    if (token == null) return;

    final dio = Dio();
    try {
      final response = await dio.get(
        ApiEndpoints.getOverallPrivacyScore,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        setState(() {
          privacyScore = response.data;
          isLoading = false;
        });
      } else {
        setState(() => isLoading = false);
      }
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
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
                const TextSpan(text: 'Your Privacy is at '),
                TextSpan(
                  text: 'Risk',
                  style: TextStyle(color: Colors.orange[700]),
                ),
                const TextSpan(text: '.'),
              ],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Lorem ipsum odor amet, consectetuer adipiscing elit.',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          if (isLoading)
            const Center(child: CircularProgressIndicator())
          else
            Column(
              children: [
                SimpleRadialGauge(value: privacyScore.toDouble()),
                const SizedBox(height: 8),
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
                      'Last updated on ${DateFormat('MM/dd/yyyy').format(DateTime.now())}',
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
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
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