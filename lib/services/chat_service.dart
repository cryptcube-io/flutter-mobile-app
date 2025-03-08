import 'package:dio/dio.dart';
import 'dart:convert';
import '../constants/api_endpoints.dart';
import '../services/logger_service.dart';

class ChatService with LoggerMixin {
  final Dio _dio = Dio();

  Future<String?> getPrivacyResponse(String question, String appName, String? token) async {
    try {
      if (token == null) {
        logInfo('Authentication token missing');
        return 'Please sign in first';
      }

      logInfo('Making privacy API request for app: $appName with question: "$question"');

      final response = await _dio.get(
        ApiEndpoints.privacy,
        queryParameters: {
          'appName': appName,
          'question': question,
          'documentType': 'txt',
        },
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
          validateStatus: (status) => true,
        ),
      );

      logDebug('Privacy API response status: ${response.statusCode}');

      if (response.data == null || response.data['response'] == null) {
        logError('Invalid response format received');
        return 'Could not process the response';
      }

      logDebug('Received response data from privacy API');
      final responseStr = response.data['response'] as String;

      final startIndex = responseStr.indexOf("response='") + 10;
      final endIndex = responseStr.lastIndexOf("'}");

      if (startIndex <= 9 || endIndex == -1) {
        logError('Malformed response format detected');
        return 'Could not process the response';
      }

      final jsonStr = responseStr.substring(startIndex, endIndex);
      
      try {
        final responseJson = json.decode(jsonStr);
        logDebug('Successfully parsed response JSON');

        if (responseJson.containsKey('inferenceResponse')) {
          String inferenceStr = responseJson['inferenceResponse'].toString();
          
          try {
            if (inferenceStr.contains('"answer"')) {
              final answerStart = inferenceStr.indexOf('"answer"') + 9;
              String answer = inferenceStr.substring(answerStart)
                  .replaceAll(RegExp(r'[{}"\\n]'), ' ')
                  .trim();

              if (answer.endsWith('} }')) {
                answer = answer.substring(0, answer.length - 4).trim();
              }

              logInfo('Successfully extracted answer from response');
              return answer;
            }
            return inferenceStr;
          } catch (e, stackTrace) {
            logError('Error processing inference string', e, stackTrace);
            return inferenceStr.replaceAll('"', '').trim();
          }
        }
      } catch (e, stackTrace) {
        logError('Error parsing response JSON', e, stackTrace);
      }

      logError('No valid answer found in API response');
      return 'Could not extract a valid answer from the response';
      
    } on DioException catch (e, stackTrace) {
      logError('API connection error', e, stackTrace);
      return 'Connection error: ${e.message}';
    } catch (e, stackTrace) {
      logError('Unexpected error occurred in getPrivacyResponse', e, stackTrace);
      return 'Unexpected error: $e';
    }
  }
}
