import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';


class AuthService {
  final _dio = Dio();
  final String baseUrl = dotenv.env['BACKEND_URL'] ?? '';
  Future<String> signIn(String usernameOrEmail, String password) async 
  {
    try {
      final formData = FormData.fromMap({
        'usernameOrEmail': usernameOrEmail,
        'password': password,
      });

      print('Attempting to sign in at: $baseUrl/api/auth/signin');

      final response = await _dio.post(
        '$baseUrl/api/auth/signin',
        data: formData,
        options: Options(
          contentType: 'application/x-www-form-urlencoded',
          validateStatus: (status) => true,
        ),
      );

      print('Response status: ${response.statusCode}');
      print('Response data: ${response.data}');

      if (response.statusCode == 200) {
        return response.data['token'];
      } else {
        throw Exception(response.data.toString());
      }
    } catch (e) {
      print('Sign in error: $e');
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

      print('Attempting to sign up at: $baseUrl/api/auth/signup');

      final response = await _dio.post(
        '$baseUrl/api/auth/signup',
        data: formData,
        options: Options(
          contentType: 'application/x-www-form-urlencoded',
          validateStatus: (status) => true,
        ),
      );

      print('Response status: ${response.statusCode}');
      print('Response data: ${response.data}');

      if (response.statusCode != 200) {
        throw Exception(response.data.toString());
      }
    } catch (e) {
      print('Sign up error: $e');
      throw Exception('Failed to sign up: $e');
    }
  }
}
