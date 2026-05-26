import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_exception.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

// ── Auth State ────────────────────────────────────────────────────────────────

enum AuthStatus { idle, loading, authenticated, unauthenticated, error }

class AuthState {
  const AuthState({
    this.status = AuthStatus.idle,
    this.user,
    this.errorMessage,
  });

  final AuthStatus status;

  /// Populated once the user is authenticated.
  final UserModel? user;

  /// Non-null only when [status] == [AuthStatus.error].
  final String? errorMessage;

  bool get isAuthenticated => status == AuthStatus.authenticated;
  bool get isLoading => status == AuthStatus.loading;

  // Convenient getters used by legacy UI that expected email/name strings.
  String? get userEmail => user?.email;
  String? get userName => user?.displayName;

  AuthState copyWith({
    AuthStatus? status,
    UserModel? user,
    String? errorMessage,
    bool clearUser = false,
    bool clearError = false,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: clearUser ? null : (user ?? this.user),
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

// ── Auth Notifier ─────────────────────────────────────────────────────────────

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier(this._ref) : super(const AuthState()) {
    _restoreSession();
  }

  final Ref _ref;

  // ── Session restore on startup ────────────────────────────────────────────

  /// Attempts to restore an existing session using `GET /auth/me`.
  /// If the cookie jar has a valid session cookie the user is silently
  /// marked as authenticated — no credentials required.
  Future<void> _restoreSession() async {
    state = state.copyWith(status: AuthStatus.loading);
    try {
      final service = await _ref.read(authServiceProvider.future);
      final user = await service.me();
      state = state.copyWith(
        status: AuthStatus.authenticated,
        user: user,
        clearError: true,
      );
    } on ApiException catch (e) {
      // 401 = no session yet; any other error = show idle (not error).
      state = AuthState(
        status: e.isUnauthorised
            ? AuthStatus.unauthenticated
            : AuthStatus.unauthenticated,
      );
    } catch (_) {
      state = const AuthState(status: AuthStatus.unauthenticated);
    }
  }

  // ── Login ─────────────────────────────────────────────────────────────────

  /// Authenticates with username + password.
  ///
  /// Returns `true` on success, `false` on failure (state holds error message).
  Future<bool> login(String username, String password) async {
    state = state.copyWith(status: AuthStatus.loading, clearError: true);
    try {
      final service = await _ref.read(authServiceProvider.future);
      final user = await service.login(
        username: username,
        password: password,
      );
      state = state.copyWith(
        status: AuthStatus.authenticated,
        user: user,
        clearError: true,
      );
      return true;
    } on ApiException catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: e.message,
        clearUser: true,
      );
      return false;
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: 'Unexpected error. Please try again.',
        clearUser: true,
      );
      return false;
    }
  }

  // ── Logout ────────────────────────────────────────────────────────────────

  Future<void> logout() async {
    try {
      final service = await _ref.read(authServiceProvider.future);
      await service.logout();
    } catch (_) {
      // Even if the server call fails, clear local state.
    } finally {
      state = const AuthState(status: AuthStatus.unauthenticated);
    }
  }

  // ── Refresh current user ──────────────────────────────────────────────────

  /// Refreshes the user profile from the server (e.g. after profile update).
  Future<void> refresh() async {
    try {
      final service = await _ref.read(authServiceProvider.future);
      final user = await service.me();
      state = state.copyWith(user: user);
    } catch (_) {
      // Silently ignore; current state remains intact.
    }
  }
}

// ── Provider ──────────────────────────────────────────────────────────────────

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>(
  (ref) => AuthNotifier(ref),
);

/// Convenience provider — exposes the authenticated [UserModel] or null.
final currentUserProvider = Provider<UserModel?>((ref) {
  return ref.watch(authProvider).user;
});
