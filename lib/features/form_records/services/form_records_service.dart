import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_client.dart';
import '../models/form_record_model.dart';

/// Wraps all `/form-records/*` endpoints.
class FormRecordsService {
  const FormRecordsService(this._dio);

  final Dio _dio;

  // POST /form-records
  Future<FormRecordModel> create({
    required String formTypeId,
    required Map<String, dynamic> data,
  }) async {
    try {
      final r = await _dio.post<Map<String, dynamic>>(
        '/form-records',
        data: {'form_type_id': formTypeId, 'data': data},
      );
      return FormRecordModel.fromJson(r.data!);
    } on DioException catch (e) {
      throw resolveError(e);
    }
  }

  // GET /form-records?form_type_id=
  Future<FormRecordPage> list({
    required String formTypeId,
    int skip = 0,
    int limit = 50,
  }) async {
    try {
      final r = await _dio.get<Map<String, dynamic>>(
        '/form-records',
        queryParameters: {
          'form_type_id': formTypeId,
          'skip': skip,
          'limit': limit,
        },
      );
      return FormRecordPage.fromJson(r.data!);
    } on DioException catch (e) {
      throw resolveError(e);
    }
  }

  // GET /form-records/{record_id}
  Future<FormRecordModel> getById(String recordId) async {
    try {
      final r =
          await _dio.get<Map<String, dynamic>>('/form-records/$recordId');
      return FormRecordModel.fromJson(r.data!);
    } on DioException catch (e) {
      throw resolveError(e);
    }
  }

  // PUT /form-records/{record_id}
  Future<FormRecordModel> update(
    String recordId, {
    required Map<String, dynamic> data,
  }) async {
    try {
      final r = await _dio.put<Map<String, dynamic>>(
        '/form-records/$recordId',
        data: {'data': data},
      );
      return FormRecordModel.fromJson(r.data!);
    } on DioException catch (e) {
      throw resolveError(e);
    }
  }

  // DELETE /form-records/{record_id}
  Future<void> delete(String recordId) async {
    try {
      await _dio.delete<void>('/form-records/$recordId');
    } on DioException catch (e) {
      throw resolveError(e);
    }
  }

  // GET /form-records/{record_id}/available-actions
  Future<List<String>> getAvailableActions(String recordId) async {
    try {
      final r =
          await _dio.get<List<dynamic>>('/form-records/$recordId/available-actions');
      return List<String>.from(r.data ?? []);
    } on DioException catch (e) {
      throw resolveError(e);
    }
  }

  // POST /form-records/{record_id}/transition
  Future<FormRecordModel> transition(
    String recordId, {
    required String trigger,
    String? remarks,
  }) async {
    try {
      final r = await _dio.post<Map<String, dynamic>>(
        '/form-records/$recordId/transition',
        data: {
          'trigger': trigger,
          if (remarks != null) 'remarks': remarks,
        },
      );
      return FormRecordModel.fromJson(r.data!);
    } on DioException catch (e) {
      throw resolveError(e);
    }
  }

  // POST /form-records/{record_id}/upload-attachment
  /// Uploads a file attachment for a specific [fieldName] on a record.
  ///
  /// [filePath] is the absolute path to the local file.
  /// [fileName] is the display name to send (defaults to basename of [filePath]).
  Future<FormRecordModel> uploadAttachment(
    String recordId, {
    required String filePath,
    required String fieldName,
    String? fileName,
  }) async {
    try {
      final formData = FormData.fromMap({
        'field_name': fieldName,
        'file': await MultipartFile.fromFile(
          filePath,
          filename: fileName,
        ),
      });
      final r = await _dio.post<Map<String, dynamic>>(
        '/form-records/$recordId/upload-attachment',
        data: formData,
        options: Options(contentType: 'multipart/form-data'),
      );
      return FormRecordModel.fromJson(r.data!);
    } on DioException catch (e) {
      throw resolveError(e);
    }
  }
}

// ── Provider ──────────────────────────────────────────────────────────────────

final formRecordsServiceProvider =
    FutureProvider<FormRecordsService>((ref) async {
  final dio = await ref.watch(dioProvider.future);
  return FormRecordsService(dio);
});
