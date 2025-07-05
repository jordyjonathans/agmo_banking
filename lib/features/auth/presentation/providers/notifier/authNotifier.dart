import 'package:agmotest_banking/features/auth/domain/entities/authResponseEntity.dart';
import 'package:agmotest_banking/features/auth/domain/useCases/getCacheTokenUseCase.dart';
import 'package:agmotest_banking/features/auth/domain/useCases/loginUseCase.dart';
import 'package:agmotest_banking/features/auth/domain/useCases/logoutUseCase.dart';
import 'package:agmotest_banking/features/auth/presentation/providers/state/authState.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthNotifier extends StateNotifier<AuthState> {
  final LoginUseCase _loginUseCase;
  final LogoutUseCase _logoutUseCase;
  final GetCachedUserUseCase _getCachedUserUseCase;

  AuthNotifier(
    this._loginUseCase,
    this._logoutUseCase,
    this._getCachedUserUseCase,
  ) : super(AuthState());

  Future<void> getCachedUser() async {
    state = state.copyWith(status: AuthStatus.loading);
    try {
      final cachedUser = await _getCachedUserUseCase.call();
      if (cachedUser != null) {
        final authResponse = AuthResponse(user: cachedUser);
        state = state.copyWith(
          status: AuthStatus.success,
          authResponse: authResponse,
        );
      } else {
        state = state.copyWith(status: AuthStatus.loggedOut);
      }
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> logout({String? errorMessage}) async {
    state = state.copyWith(status: AuthStatus.loading);
    try {
      await _logoutUseCase.execute();
      state = AuthState(
        status: AuthStatus.loggedOut,
        errorMessage: errorMessage ?? "You have been logged out.",
      );
    } catch (e) {
      state = AuthState(
        status: AuthStatus.error,
        errorMessage:
            "An unexpected error occurred during logout: ${e.toString()}",
      );
    }
    state = state.copyWith(authResponse: null);
  }

  String? _validatePassword(String password) {
    if (password.length < 6) {
      return 'Password must be at least 6 characters long.';
    }
    if (!password.contains(RegExp(r'[a-zA-Z]'))) {
      return 'Password must include at least one letter.';
    }
    if (!password.contains(RegExp(r'[0-9]'))) {
      return 'Password must include at least one number.';
    }
    return null;
  }

  Future<void> login(String email, String password) async {
    state = state.copyWith(status: AuthStatus.loading, errorMessage: null);
    final validationError = _validatePassword(password);

    if (validationError != null) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: 'Invalid password format.',
        passwordValidatinError: validationError,
      );
      return;
    }

    try {
      final result = await _loginUseCase.execute(email, password);
      state = state.copyWith(status: AuthStatus.success, authResponse: result);
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: e.toString(),
      );
    }
  }

  void clearErrorMessage() {
    state = state.copyWith(errorMessage: null);
  }
}
