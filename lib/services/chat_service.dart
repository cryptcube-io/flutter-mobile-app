
import 'package:dio/dio.dart';
import 'dart:convert';

import '../config/api_endpoints.dart';

class ChatService {
  final Dio _dio = Dio();
  
  Future<String?> getPrivacyResponse(String question, String appName, String? token) async {
    try {
      if (token == null) return 'Please sign in first';

      final response = await _dio.get(
        ApiEndpoints.privacy,
        queryParameters: {
          'appName': appName,
          'question': question,
          'documentType': 'txt'
        },
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
          validateStatus: (status) => true,
        ),
      );

      if (response.data != null && response.data['response'] != null) {
        final responseStr = response.data['response'] as String;
        final startIndex = responseStr.indexOf("response='") + 10;
        final endIndex = responseStr.lastIndexOf("'}");

        if (startIndex > 9 && endIndex != -1) {
          final jsonStr = responseStr.substring(startIndex, endIndex);
          final responseJson = json.decode(jsonStr);

          if (responseJson['inferenceResponse'] != null) {
            String inferenceStr = responseJson['inferenceResponse'].toString();
            try {
              if (inferenceStr.contains('"answer"')) {
                final answerStart = inferenceStr.indexOf('"answer"') + 9;
                String answer = inferenceStr.substring(answerStart);
                answer = answer
                    .replaceAll('"', '')
                    .replaceAll('{', '')
                    .replaceAll('}', '')
                    .replaceAll('\\n', ' ')
                    .trim();
                if (answer.endsWith('} }')) {
                  answer = answer.substring(0, answer.length - 4).trim();
                }
                return answer;
              }
              return inferenceStr;
            } catch (e) {
              return inferenceStr.replaceAll('"', '').trim();
            }
          }
        }
      }
      return 'Could not process the response';
    } catch (e) {
      return 'Connection error: $e';
    }
  }
}