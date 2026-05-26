import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_client.dart';

// ── Response models ───────────────────────────────────────────────────────────

class UploadResult {
  const UploadResult({
    required this.status,
    required this.message,
    required this.objectName,
    required this.size,
    required this.contentType,
  });

  final String status;
  final String message;
  final String objectName;
  final int size;
  final String contentType;

  factory UploadResult.fromJson(Map<String, dynamic> json) => UploadResult(
        status: json['status'] as String? ?? 'success',
        message: json['message'] as String? ?? '',
        objectName: json['object_name'] as String,
        size: json['size'] as int? ?? 0,
        contentType: json['content_type'] as String? ?? '',
      );
}

class PresignedUrlResult {
  const PresignedUrlResult({
    required this.status,
    required this.url,
    required this.expiresInHours,
    required this.objectName,
  });

  final String status;
  final String url;
  final int expiresInHours;
  final String objectName;

  factory PresignedUrlResult.fromJson(Map<String, dynamic> json) =>
      PresignedUrlResult(
        status: json['status'] as String? ?? 'success',
        url: json['url'] as String,
        expiresInHours: json['expires_in_hours'] as int? ?? 1,
        objectName: json['object_name'] as String,
      );
}

// ── Service ────────────────────────────────────────────────────────────────────

/// Wraps all MinIO storage endpoints (`/upload`, `/list`, `/download`, etc.).
class StorageService {
  const StorageService(this._dio);

  final Dio _dio;

  // POST /upload
  Future<UploadResult> upload(
    String filePath, {
    String? storagePath,
    void Function(int sent, int total)? onProgress,
  }) async {
    try {
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(filePath),
        if (storagePath != null) 'path': storagePath,
      });
      final r = await _dio.post<Map<String, dynamic>>(
        '/upload',
        data: formData,
        options: Options(contentType: 'multipart/form-data'),
        onSendProgress: onProgress,
      );
      return UploadResult.fromJson(r.data!);
    } on DioException catch (e) {
      throw resolveError(e);
    }
  }

  // GET /list (with optional query prefix)
  Future<List<String>> listFiles({String? prefix}) async {
    try {
      final r = await _dio.get<Map<String, dynamic>>(
        '/list',
        queryParameters: {if (prefix != null) 'prefix': prefix},
      );
      return List<String>.from(r.data!['files'] as List? ?? []);
    } on DioException catch (e) {
      throw resolveError(e);
    }
  }

  // GET /list/{prefix}
  Future<List<String>> listByPrefix(String prefix) async {
    try {
      final r =
          await _dio.get<Map<String, dynamic>>('/list/$prefix');
      return List<String>.from(r.data!['files'] as List? ?? []);
    } on DioException catch (e) {
      throw resolveError(e);
    }
  }

  // GET /url/{file_name}
  Future<PresignedUrlResult> getPresignedUrl(
    String fileName, {
    int expiresHours = 1,
  }) async {
    try {
      final r = await _dio.get<Map<String, dynamic>>(
        '/url/$fileName',
        queryParameters: {'expires_hours': expiresHours},
      );
      return PresignedUrlResult.fromJson(r.data!);
    } on DioException catch (e) {
      throw resolveError(e);
    }
  }

  // GET /download/{formtype_id}/{form_record_id}/{field_name}/{file_name}
  /// Returns the final redirect URL after following the 307 redirect.
  Future<String> getDownloadUrl(
    String formTypeId,
    String formRecordId,
    String fieldName,
    String fileName, {
    bool download = false,
  }) async {
    try {
      // The endpoint returns a 307 redirect; Dio follows it.
      // We capture the final URL from the response.
      final r = await _dio.get<dynamic>(
        '/download/$formTypeId/$formRecordId/$fieldName/$fileName',
        queryParameters: {'download': download ? 1 : 0},
      );
      // Return the resolved URL.
      return r.realUri.toString();
    } on DioException catch (e) {
      throw resolveError(e);
    }
  }

  // DELETE /delete/{file_name}
  Future<Map<String, dynamic>> deleteFile(String fileName) async {
    try {
      final r =
          await _dio.delete<Map<String, dynamic>>('/delete/$fileName');
      return r.data!;
    } on DioException catch (e) {
      throw resolveError(e);
    }
  }
}

// ── Provider ──────────────────────────────────────────────────────────────────

final storageServiceProvider = FutureProvider<StorageService>((ref) async {
  final dio = await ref.watch(dioProvider.future);
  return StorageService(dio);
});
