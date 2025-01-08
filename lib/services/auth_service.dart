import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final _dio = Dio();
  final String baseUrl = dotenv.env['BACKEND_URL'] ?? '';
  final String fixedSignInUrl = 'https://privacydoctor.cryptcube.io/api/auth/signin?usernameOrEmail=mo3pheus&password=proton101';

  
  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  Future<void> removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
  }

  Future<String> signIn(String usernameOrEmail, String password) async {
    try {
      print('\n=== Sign In Request ===');
      print('URL: $fixedSignInUrl');
      print('Content-Type: application/x-www-form-urlencoded');

      final response = await _dio.post(
        fixedSignInUrl,
        options: Options(
          contentType: 'application/x-www-form-urlencoded',
          validateStatus: (status) => true,
        ),
      );

      print('\n=== Response Details ===');
      print('Status Code: ${response.statusCode}');
      print('Response Data: ${response.data}');

      if (response.statusCode == 200 && response.data != null) {
        if (response.data is Map && response.data['accessToken'] != null) {
          final token = response.data['accessToken'].toString();
         
          await saveToken(token);
          return token;
        }
        throw Exception('Invalid response format: accessToken not found');
      } 
      throw Exception(response.data?.toString() ?? 'Unknown error occurred');
    } catch (e) {
      print('\n=== Error Details ===');
      print('Error Type: ${e.runtimeType}');
      print('Error Message: $e');
      if (e is DioException) {
        print('Response: ${e.response?.data}');
        print('Status Code: ${e.response?.statusCode}');
      }
      throw Exception('Failed to sign in: $e');
    }
  }

  Future<void> signUp({
    required String name,
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      final formData = FormData.fromMap({
        'name': name,
        'username': username,
        'email': email,
        'password': password,
      });

      print('\n=== Sign Up Request ===');
      print('URL: $baseUrl/api/auth/signup');
      print('Form Data: ${formData.fields}');

      final response = await _dio.post(
        '$baseUrl/api/auth/signup',
        data: formData,
        options: Options(
          contentType: 'application/x-www-form-urlencoded',
          validateStatus: (status) => true,
        ),
      );

      print('\n=== Response Details ===');
      print('Status Code: ${response.statusCode}');
      print('Response Data: ${response.data}');

      if (response.statusCode != 200) {
        throw Exception(response.data.toString());
      }
    } catch (e) {
      print('\n=== Error Details ===');
      print('Error Type: ${e.runtimeType}');
      print('Error Message: $e');
      if (e is DioException) {
        print('Response: ${e.response?.data}');
        print('Status Code: ${e.response?.statusCode}');
      }
      throw Exception('Failed to sign up: $e');
    }
  }


  Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

 
  Future<void> logout() async {
    await removeToken();
  }
}