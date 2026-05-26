import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_client.dart';
import '../models/form_type_model.dart';

/// Wraps all `/form-types/*` endpoints.
class FormTypesService {
  const FormTypesService(this._dio);

  final Dio _dio;

  // GET /form-types
  Future<List<FormTypeModel>> list({int skip = 0, int limit = 50}) async {
    try {
      final r = await _dio.get<List<dynamic>>(
        '/form-types',
        queryParameters: {'skip': skip, 'limit': limit},
      );
      return r.data!
          .map((e) => FormTypeModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw resolveError(e);
    }
  }

  // GET /form-types/with-schema
  Future<List<FormTypeModel>> listWithSchema({
    int skip = 0,
    int limit = 50,
  }) async {
    try {
      final r = await _dio.get<List<dynamic>>(
        '/form-types/with-schema',
        queryParameters: {'skip': skip, 'limit': limit},
      );
      return r.data!
          .map((e) => FormTypeModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw resolveError(e);
    }
  }

  // GET /form-types/search?q=
  Future<List<FormTypeModel>> search(String query, {int limit = 20}) async {
    try {
      final r = await _dio.get<List<dynamic>>(
        '/form-types/search',
        queryParameters: {'q': query, 'limit': limit},
      );
      return r.data!
          .map((e) => FormTypeModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw resolveError(e);
    }
  }

  // GET /form-types/stage/{stage_id}
  Future<List<FormTypeModel>> listByStage(
    String stageId, {
    int skip = 0,
    int limit = 50,
  }) async {
    try {
      final r = await _dio.get<List<dynamic>>(
        '/form-types/stage/$stageId',
        queryParameters: {'skip': skip, 'limit': limit},
      );
      return r.data!
          .map((e) => FormTypeModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw resolveError(e);
    }
  }

  // GET /form-types/{form_type_id}
  Future<FormTypeModel> getById(String formTypeId) async {
    try {
      final r =
          await _dio.get<Map<String, dynamic>>('/form-types/$formTypeId');
      return FormTypeModel.fromJson(r.data!);
    } on DioException catch (e) {
      throw resolveError(e);
    }
  }

  // GET /form-types/{form_type_id}/schema
  Future<FormTypeModel> getWithSchema(String formTypeId) async {
    try {
      final r = await _dio
          .get<Map<String, dynamic>>('/form-types/$formTypeId/schema');
      return FormTypeModel.fromJson(r.data!);
    } on DioException catch (e) {
      throw resolveError(e);
    }
  }

  // POST /form-types
  Future<FormTypeModel> create({
    required String formName,
    String? description,
    String version = '1.0.0',
    Map<String, dynamic>? schema,
    Map<String, dynamic>? workflowData,
  }) async {
    try {
      final r = await _dio.post<Map<String, dynamic>>(
        '/form-types',
        data: {
          'form_name': formName,
          if (description != null) 'description': description,
          'version': version,
          if (schema != null) 'schema': schema,
          if (workflowData != null) 'workflow_data': workflowData,
        },
      );
      return FormTypeModel.fromJson(r.data!);
    } on DioException catch (e) {
      throw resolveError(e);
    }
  }

  // PUT /form-types/{form_type_id}
  Future<FormTypeModel> update(
    String formTypeId, {
    String? formName,
    String? version,
    Map<String, dynamic>? schema,
    Map<String, dynamic>? workflowData,
  }) async {
    try {
      final r = await _dio.put<Map<String, dynamic>>(
        '/form-types/$formTypeId',
        data: {
          if (formName != null) 'form_name': formName,
          if (version != null) 'version': version,
          if (schema != null) 'schema': schema,
          if (workflowData != null) 'workflow_data': workflowData,
        },
      );
      return FormTypeModel.fromJson(r.data!);
    } on DioException catch (e) {
      throw resolveError(e);
    }
  }

  // DELETE /form-types/{form_type_id}
  Future<void> delete(String formTypeId) async {
    try {
      await _dio.delete<void>('/form-types/$formTypeId');
    } on DioException catch (e) {
      throw resolveError(e);
    }
  }

  // POST /form-types/{form_type_id}/link-stage/{stage_id}
  Future<Map<String, dynamic>> linkStage(
    String formTypeId,
    String stageId,
  ) async {
    try {
      final r = await _dio.post<Map<String, dynamic>>(
        '/form-types/$formTypeId/link-stage/$stageId',
      );
      return r.data!;
    } on DioException catch (e) {
      throw resolveError(e);
    }
  }

  // DELETE /form-types/{form_type_id}/link-stage/{stage_id}
  Future<void> unlinkStage(String formTypeId, String stageId) async {
    try {
      await _dio.delete<void>(
        '/form-types/$formTypeId/link-stage/$stageId',
      );
    } on DioException catch (e) {
      throw resolveError(e);
    }
  }
}

// ── Provider ──────────────────────────────────────────────────────────────────

final formTypesServiceProvider = FutureProvider<FormTypesService>((ref) async {
  final dio = await ref.watch(dioProvider.future);
  return FormTypesService(dio);
});
