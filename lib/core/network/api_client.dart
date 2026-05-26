import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_config.dart';
import 'api_exception.dart';
import '../../features/auth/providers/auth_provider.dart';
// Conditional import: web stub vs native cookie jar.
import 'cookie_client_stub.dart'
    if (dart.library.io) 'cookie_client_native.dart'
    if (dart.library.html) 'cookie_client_web.dart';

// ── Dio Client Provider ───────────────────────────────────────────────────────

/// Provides a fully configured [Dio] instance.
///
/// - **Web**: Relies on the browser to send session cookies automatically
///   via `withCredentials: true`.
/// - **Native**: A [PersistCookieJar] is attached so session cookies survive
///   app restarts without requiring re-login.
final dioProvider = FutureProvider<Dio>((ref) async {
  final dio = Dio(
    BaseOptions(
      baseUrl: kBaseUrl,
      connectTimeout: kConnectTimeout,
      receiveTimeout: kReceiveTimeout,
      sendTimeout: kSendTimeout,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      followRedirects: true,
      maxRedirects: 5,
      // Required for browsers to send session cookies cross-origin.
      extra: {'withCredentials': true},
    ),
  );

  // Platform-specific cookie wiring (no-op on web).
  await attachCookieJar(dio, ref);

  // Debug logging.
  if (kDebugMode) {
    dio.interceptors.add(
      LogInterceptor(
        request: true,
        requestHeader: false,
        requestBody: true,
        responseHeader: false,
        responseBody: true,
        error: true,
        logPrint: (o) => debugPrint('[API] $o'),
      ),
    );
  }

  // Unified error conversion.
  dio.interceptors.add(
    InterceptorsWrapper(
      onError: (DioException e, ErrorInterceptorHandler handler) {
        if (e.response?.statusCode == 401) {
          // Session expired or unauthenticated: force logout to redirect back to Login screen
          ref.read(authProvider.notifier).logout();
        }
        handler.reject(
          DioException(
            requestOptions: e.requestOptions,
            response: e.response,
            type: e.type,
            error: ApiException.fromDioException(e),
            message: e.message,
          ),
        );
      },
    ),
  );

  return dio;
});

// ── Convenience helper ────────────────────────────────────────────────────────

/// Extracts an [ApiException] from a caught [Object].
ApiException resolveError(Object e) {
  if (e is DioException && e.error is ApiException) {
    return e.error as ApiException;
  }
  if (e is ApiException) return e;
  return ApiException.unknown(e.toString());
}
