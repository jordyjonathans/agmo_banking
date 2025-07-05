import 'dart:async';

import 'package:agmotest_banking/features/auth/presentation/providers/notifier/authNotifier.dart';
import 'package:agmotest_banking/features/auth/presentation/providers/state/authState.dart';
import 'package:agmotest_banking/shared/providers/state/sessionState.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const int _inactivityTimeoutSeconds = 30;
const int _warningDialogTimeoutSeconds = 5;

class SessionNotifier extends StateNotifier<SessionState> {
  Timer? _inactivityTimer;
  Timer? _warningDialogTimer;
  final AuthNotifier _authNotifier;

  int _currentInactivitySeconds = _inactivityTimeoutSeconds;

  SessionNotifier(this._authNotifier) : super(SessionState());

  void startMonitoring() {
    resetInactivityTimer();
  }

  void resetInactivityTimer() {
    if (_authNotifier.state.status == AuthStatus.success) {
      if (state.currentRoute == '/login') {
        _inactivityTimer?.cancel();
        _warningDialogTimer?.cancel();
        state = state.copyWith(
          showWarningDialog: false,
          inactivityRemainingSeconds: _inactivityTimeoutSeconds,
          warningDialogRemainingSeconds: _warningDialogTimeoutSeconds,
        );
        return;
      }

      _inactivityTimer?.cancel();
      _currentInactivitySeconds = _inactivityTimeoutSeconds;

      _inactivityTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (_currentInactivitySeconds > 0) {
          _currentInactivitySeconds--;
          state = state.copyWith(
            inactivityRemainingSeconds: _currentInactivitySeconds,
          );
        } else {
          timer.cancel();
          _onInactivityTimeout();
        }
      });

      if (state.showWarningDialog) {
        _warningDialogTimer?.cancel();
        state = state.copyWith(showWarningDialog: false);
      }
    } else {
      _inactivityTimer?.cancel();
      _warningDialogTimer?.cancel();
      state = state.copyWith(
        showWarningDialog: false,
        inactivityRemainingSeconds: _inactivityTimeoutSeconds,
        warningDialogRemainingSeconds: _warningDialogTimeoutSeconds,
      );
    }
  }

  void _onInactivityTimeout() {
    if (_authNotifier.state.status == AuthStatus.success &&
        state.currentRoute != '/login') {
      _performLogout();
    } else {
      _inactivityTimer?.cancel();
      _warningDialogTimer?.cancel();
      state = state.copyWith(showWarningDialog: false);
    }
  }

  void dismissWarningDialog() {
    if (state.showWarningDialog) {
      _warningDialogTimer?.cancel();
      state = state.copyWith(
        showWarningDialog: false,
        warningDialogRemainingSeconds: _warningDialogTimeoutSeconds,
      );
      resetInactivityTimer();
    }
  }

  void _performLogout() async {
    if (_authNotifier.state.status != AuthStatus.loggedOut &&
        _authNotifier.state.status != AuthStatus.loading) {
      await _authNotifier.logout(
        errorMessage: "Your session has timed out due to inactivity.",
      );
    }
    state = state.copyWith(
      showWarningDialog: false,
      inactivityRemainingSeconds: _inactivityTimeoutSeconds,
      warningDialogRemainingSeconds: _warningDialogTimeoutSeconds,
    );
  }

  void updateCurrentRoute(String? route) {
    if (state.currentRoute != route) {
      state = state.copyWith(currentRoute: route);
      if (route == '/login' ||
          _authNotifier.state.status != AuthStatus.success) {
        _inactivityTimer?.cancel();
        _warningDialogTimer?.cancel();
        state = state.copyWith(
          showWarningDialog: false,
          inactivityRemainingSeconds: _inactivityTimeoutSeconds,
          warningDialogRemainingSeconds: _warningDialogTimeoutSeconds,
        );
      } else {
        resetInactivityTimer();
      }
    }
  }

  @override
  void dispose() {
    _inactivityTimer?.cancel();
    _warningDialogTimer?.cancel();
    super.dispose();
  }
}
