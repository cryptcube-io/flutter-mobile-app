class AuthState {
  final String? token;
  final bool isLoading;
  final String? error;

  AuthState({this.token, this.isLoading = false, this.error});

  AuthState copyWith({String? token, bool? isLoading, String? error}) {
    return AuthState(
      token: token ?? this.token,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}