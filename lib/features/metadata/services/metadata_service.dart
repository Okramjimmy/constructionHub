import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_client.dart';
import '../models/metadata_models.dart';

/// Wraps all `/metadata/*` endpoints.
class MetadataService {
  const MetadataService(this._dio);

  final Dio _dio;

  // GET /metadata/master
  Future<MasterMetadata> getMaster({bool force = false}) async {
    try {
      final r = await _dio.get<Map<String, dynamic>>(
        '/metadata/master',
        queryParameters: {'force': force},
      );
      return MasterMetadata.fromJson(r.data!);
    } on DioException catch (e) {
      throw resolveError(e);
    }
  }

  // GET /metadata/registry
  Future<MetadataRegistry> getRegistry({bool force = false}) async {
    try {
      final r = await _dio.get<Map<String, dynamic>>(
        '/metadata/registry',
        queryParameters: {'force': force},
      );
      return MetadataRegistry.fromJson(r.data!);
    } on DioException catch (e) {
      throw resolveError(e);
    }
  }

  // GET /metadata/stages/{stage_id}
  Future<StageMetadata> getStageMetadata(String stageId) async {
    try {
      final r = await _dio
          .get<Map<String, dynamic>>('/metadata/stages/$stageId');
      return StageMetadata.fromJson(r.data!);
    } on DioException catch (e) {
      throw resolveError(e);
    }
  }

  // POST /metadata/regenerate
  Future<Map<String, dynamic>> regenerate() async {
    try {
      final r =
          await _dio.post<Map<String, dynamic>>('/metadata/regenerate');
      return r.data!;
    } on DioException catch (e) {
      throw resolveError(e);
    }
  }

  // GET /metadata/validate
  Future<MetadataValidationResult> validate() async {
    try {
      final r =
          await _dio.get<Map<String, dynamic>>('/metadata/validate');
      return MetadataValidationResult.fromJson(r.data!);
    } on DioException catch (e) {
      throw resolveError(e);
    }
  }

  // GET /metadata/statistics
  Future<MetadataStatistics> getStatistics() async {
    try {
      final r =
          await _dio.get<Map<String, dynamic>>('/metadata/statistics');
      return MetadataStatistics.fromJson(r.data!);
    } on DioException catch (e) {
      throw resolveError(e);
    }
  }
}

// ── Provider ──────────────────────────────────────────────────────────────────

final metadataServiceProvider = FutureProvider<MetadataService>((ref) async {
  final dio = await ref.watch(dioProvider.future);
  return MetadataService(dio);
});
