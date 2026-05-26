import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_client.dart';
import '../../../core/network/api_exception.dart';
import '../models/user_model.dart';

/// Service wrapping all `/auth/*` endpoints.
class AuthService {
  const AuthService(this._dio);

  final Dio _dio;

  // ── POST /auth/login ──────────────────────────────────────────────────────

  /// Authenticates with [username] and [password].
  ///
  /// On success the backend sets an HTTP-only session cookie which is
  /// persisted by [PersistCookieJar] for future requests.
  ///
  /// Throws [ApiException] on failure.
  Future<UserModel> login({
    required String username,
    required String password,
  }) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '/auth/login',
        data: {'username': username, 'password': password},
      );
      return UserModel.fromJson(response.data!);
    } on DioException catch (e) {
      throw resolveError(e);
    }
  }

  // ── POST /auth/logout ─────────────────────────────────────────────────────

  /// Clears the server-side session.
  ///
  /// Returns silently even if the server returns 204.
  Future<void> logout() async {
    try {
      await _dio.post<void>('/auth/logout');
    } on DioException catch (e) {
      // A 401 during logout means the session was already gone — ignore it.
      final apiEx = resolveError(e);
      if (!apiEx.isUnauthorised) throw apiEx;
    }
  }

  // ── GET /auth/me ──────────────────────────────────────────────────────────

  /// Returns the currently authenticated user, or throws [ApiException]
  /// with `statusCode == 401` if no valid session exists.
  Future<UserModel> me() async {
    try {
      final response = await _dio.get<Map<String, dynamic>>('/auth/me');
      return UserModel.fromJson(response.data!);
    } on DioException catch (e) {
      throw resolveError(e);
    }
  }
}

// ── Provider ─────────────────────────────────────────────────────────────────

final authServiceProvider = FutureProvider<AuthService>((ref) async {
  final dio = await ref.watch(dioProvider.future);
  return AuthService(dio);
});
