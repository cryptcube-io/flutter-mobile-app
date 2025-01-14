// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'dart:developer' as dev;

// import '../config/api_endpoints.dart';

// class PrivacyScoreService {
//   final http.Client _client = http.Client();

//   bool _isHtmlResponse(String body) {
//     return body.trim().toLowerCase().startsWith('<!doctype html>') ||
//            body.trim().toLowerCase().startsWith('<html');
//   }

//   Future<T> _handleResponse<T>(http.Response response, String errorMessage) async {
//     if (_isHtmlResponse(response.body)) {
//       dev.log('Received HTML response instead of JSON', 
//              name: 'PrivacyScoreService',
//              error: 'API returned HTML. Status code: ${response.statusCode}\nURL: ${response.request?.url}');
//       throw Exception('Authentication required or invalid endpoint');
//     }

//     if (response.statusCode == 200) {
//       try {
//         return json.decode(response.body);
//       } catch (e) {
//         dev.log('Failed to decode JSON response', 
//                name: 'PrivacyScoreService',
//                error: '${response.body}\nError: $e');
//         throw Exception('Invalid response format');
//       }
//     } else {
//       dev.log('$errorMessage: ${response.statusCode}', 
//              name: 'PrivacyScoreService',
//              error: response.body);
//       throw Exception(errorMessage);
//     }
//   }

//   Future<int> getOverallPrivacyScore() async {
//     try {
//       final response = await _client.get(
//         Uri.parse(ApiEndpoints.getOverallPrivacyScore),
//       );
//       return await _handleResponse(response, 'Failed to get overall privacy score');
//     } catch (e) {
//       dev.log('Error getting overall privacy score', 
//              name: 'PrivacyScoreService', 
//              error: e);
//       rethrow;
//     }
//   }

//   Future<int> getApplicationScore(String appName, String appVector) async {
//     try {
//       final response = await _client.get(
//         Uri.parse('${ApiEndpoints.getApplicationPrivacyScore}?appName=$appName&appVector=$appVector'),
//       );
//       return await _handleResponse(response, 'Failed to get application score');
//     } catch (e) {
//       dev.log('Error getting application score', 
//              name: 'PrivacyScoreService', 
//              error: e);
//       rethrow;
//     }
//   }

//   Future<String> getScoreExplanation() async {
//     try {
//       final response = await _client.get(
//         Uri.parse(ApiEndpoints.getOverallScoreExplanation),
//       );
//       return await _handleResponse(response, 'Failed to get score explanation');
//     } catch (e) {
//       dev.log('Error getting score explanation', 
//              name: 'PrivacyScoreService', 
//              error: e);
//       rethrow;
//     }
//   }

//   Future<String> explainAppScore(String appName, String appVector) async {
//     try {
//       final response = await _client.get(
//         Uri.parse('${ApiEndpoints.getApplicationScoreExplanation}?appName=$appName&appVector=$appVector'),
//       );
//       return await _handleResponse(response, 'Failed to get app score explanation');
//     } catch (e) {
//       dev.log('Error getting app score explanation', 
//              name: 'PrivacyScoreService', 
//              error: e);
//       rethrow;
//     }
//   }

//   Future<String> uploadAppDataVector(String appName, String appVector) async {
//     try {
//       final response = await _client.post(
//         Uri.parse(ApiEndpoints.uploadAppDataVector),
//         body: {
//           'appName': appName,
//           'appVector': appVector,
//         },
//       );
//       return await _handleResponse(response, 'Failed to upload app vector');
//     } catch (e) {
//       dev.log('Error uploading app vector', 
//              name: 'PrivacyScoreService', 
//              error: e);
//       rethrow;
//     }
//   }

//   Future<Map<String, dynamic>> getAllPrivacyData(String appName, String appVector) async {
//     try {
//       final overallScore = await getOverallPrivacyScore();
//       final appScore = await getApplicationScore(appName, appVector);
//       final scoreExplanation = await getScoreExplanation();
//       final appScoreExplanation = await explainAppScore(appName, appVector);
//       final uploadResult = await uploadAppDataVector(appName, appVector);

//       return {
//         'overallScore': overallScore,
//         'applicationScore': appScore,
//         'scoreExplanation': scoreExplanation,
//         'appScoreExplanation': appScoreExplanation,
//         'uploadResult': uploadResult
//       };
//     } catch (e) {
//       dev.log('Error getting all privacy data', 
//              name: 'PrivacyScoreService', 
//              error: e);
//       rethrow;
//     }
//   }

//   void dispose() {
//     _client.close();
//   }
// }