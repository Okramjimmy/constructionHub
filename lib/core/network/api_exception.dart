import 'package:dio/dio.dart';

/// A typed API error that wraps DioException / HTTP responses into
/// a single, consistent exception class used across all services.
class ApiException implements Exception {
  const ApiException({
    required this.message,
    this.statusCode,
    this.isNetworkError = false,
    this.data,
  });

  /// HTTP status code, if available (e.g. 400, 401, 403, 404, 422, 500).
  final int? statusCode;

  /// Human-readable error description (may come from server `detail` field).
  final String message;

  /// True when there is no server response at all (offline / timeout).
  final bool isNetworkError;

  /// Raw response body, if available (useful for 422 validation errors).
  final Object? data;

  // ── Factory constructors ──────────────────────────────────────────────────

  factory ApiException.fromDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        return const ApiException(
          message: 'Request timed out. Check your connection.',
          isNetworkError: true,
        );

      case DioExceptionType.connectionError:
        return const ApiException(
          message: 'Cannot reach the server. Check your network.',
          isNetworkError: true,
        );

      case DioExceptionType.badResponse:
        final response = e.response;
        final statusCode = response?.statusCode;
        final body = response?.data;

        // Try to extract server-provided `detail` message.
        String message = _extractDetail(body, statusCode);

        return ApiException(
          statusCode: statusCode,
          message: message,
          data: body,
        );

      case DioExceptionType.cancel:
        return const ApiException(message: 'Request was cancelled.');

      default:
        return ApiException(
          message: e.message ?? 'An unexpected error occurred.',
        );
    }
  }

  factory ApiException.unknown(String detail) =>
      ApiException(message: detail);

  // ── Helpers ───────────────────────────────────────────────────────────────

  static String _extractDetail(Object? body, int? statusCode) {
    if (body is Map<String, dynamic>) {
      final detail = body['detail'];
      if (detail is String && detail.isNotEmpty) return detail;
      // FastAPI 422 validation errors have a list in `detail`.
      if (detail is List && detail.isNotEmpty) {
        final first = detail.first;
        if (first is Map) {
          final msg = first['msg'] ?? first['message'];
          if (msg != null) return msg.toString();
        }
      }
    }
    return _statusMessage(statusCode);
  }

  static String _statusMessage(int? code) => switch (code) {
        400 => 'Bad request.',
        401 => 'Unauthorised. Please log in.',
        403 => 'You do not have permission to perform this action.',
        404 => 'The requested resource was not found.',
        409 => 'Conflict — the resource already exists.',
        422 => 'Validation error. Check your input.',
        429 => 'Too many requests. Please slow down.',
        500 => 'Internal server error. Try again later.',
        502 => 'Bad gateway.',
        503 => 'Service temporarily unavailable.',
        _ => 'Something went wrong (HTTP $code).',
      };

  // ── Accessors ─────────────────────────────────────────────────────────────

  bool get isUnauthorised => statusCode == 401;
  bool get isForbidden => statusCode == 403;
  bool get isNotFound => statusCode == 404;
  bool get isValidationError => statusCode == 422;
  bool get isServerError => (statusCode ?? 0) >= 500;

  @override
  String toString() => 'ApiException($statusCode): $message';
}
