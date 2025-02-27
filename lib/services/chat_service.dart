import 'package:dio/dio.dart';
import 'dart:convert';
import '../config/api_endpoints.dart';
import '../services/logger_service.dart';

class ChatService with LoggerMixin {
 final Dio _dio = Dio();

 Future<String?> getPrivacyResponse(String question, String appName, String? token) async {
   try {
     if (token == null) {
       logInfo('Authentication token missing');
       return 'Please sign in first';
     }

     logInfo('Making privacy API request for app: $appName');
     
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
       logDebug('Received response from privacy API');
       final responseStr = response.data['response'] as String;
       final startIndex = responseStr.indexOf("response='") + 10;
       final endIndex = responseStr.lastIndexOf("'}");

       if (startIndex > 9 && endIndex != -1) {
         final jsonStr = responseStr.substring(startIndex, endIndex);
         
         try {
           final responseJson = json.decode(jsonStr);
           logDebug('Successfully parsed response JSON');

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
                 logInfo('Successfully extracted answer from response');
                 return answer;
               }
               return inferenceStr;
             } catch (e) {
               logError('Error processing inference string', e);
               return inferenceStr.replaceAll('"', '').trim();
             }
           }
         } catch (e) {
           logError('Error parsing response JSON', e);
         }
       }
     }
     
     logError('Invalid response format received');
     return 'Could not process the response';
   } catch (e) {
     logError('API connection error', e);
     return 'Connection error: $e';
   }
 }
}