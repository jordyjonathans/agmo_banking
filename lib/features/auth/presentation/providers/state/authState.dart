import 'package:agmotest_banking/features/auth/domain/entities/authResponseEntity.dart';

enum AuthStatus { initial, loading, success, error, loggedOut }

class AuthState {
  final AuthStatus status;
  final String? errorMessage;
  final AuthResponse? authResponse;
  final String? passwordValidatinError;

  AuthState({
    this.status = AuthStatus.initial,
    this.errorMessage,
    this.authResponse,
    this.passwordValidatinError,
  });

  AuthState copyWith({
    AuthStatus? status,
    String? errorMessage,
    AuthResponse? authResponse,
    String? passwordValidatinError,
  }) {
    return AuthState(
      status: status ?? this.status,
      errorMessage: errorMessage,
      authResponse: authResponse ?? this.authResponse,
      passwordValidatinError: passwordValidatinError,
    );
  }

  String? get currentUserId => authResponse?.user.id;
  String? get currentUserEmail => authResponse?.user.email;
  String? get currentUserName => authResponse?.user.name;
}
