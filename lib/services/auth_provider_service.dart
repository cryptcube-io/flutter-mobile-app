import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/auth_state.dart';
import 'auth_notifier_service.dart';
import 'auth_service.dart';

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(AuthService());
});