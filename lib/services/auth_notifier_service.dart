import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../services/auth_service.dart';
import '../models/auth_state.dart';

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(AuthService());
});

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthService _authService;
  
  AuthNotifier(this._authService) : super(AuthState());

  Future<void> signIn(String username, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final token = await _authService.signIn(username, password);
      state = state.copyWith(token: token, isLoading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  void signOut() {
    state = AuthState();
  }
  
  bool isAuthenticated() {
    return state.token != null;
  }

  void clearError() {
    state = state.copyWith(error: null);
  }

  String? getToken() {
    return state.token;
  }
}