import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_client.dart';
import '../models/stage_model.dart';
import '../models/stage_tree_node.dart';

// ── Request / Response helpers ─────────────────────────────────────────────

class StageMoveResult {
  const StageMoveResult({
    required this.stageId,
    required this.oldPath,
    required this.newPath,
    required this.affectedStagesCount,
    required this.movedStages,
  });

  final String stageId;
  final String oldPath;
  final String newPath;
  final int affectedStagesCount;
  final List<Map<String, dynamic>> movedStages;

  factory StageMoveResult.fromJson(Map<String, dynamic> json) =>
      StageMoveResult(
        stageId: json['stage_id'] as String,
        oldPath: json['old_path'] as String,
        newPath: json['new_path'] as String,
        affectedStagesCount: json['affected_stages_count'] as int? ?? 0,
        movedStages: List<Map<String, dynamic>>.from(
            json['moved_stages'] as List? ?? []),
      );
}

class StageDeleteResult {
  const StageDeleteResult({
    required this.deletedStages,
    required this.deletedFormTypes,
    required this.totalDeleted,
  });

  final List<String> deletedStages;
  final List<String> deletedFormTypes;
  final int totalDeleted;

  factory StageDeleteResult.fromJson(Map<String, dynamic> json) =>
      StageDeleteResult(
        deletedStages: List<String>.from(json['deleted_stages'] as List? ?? []),
        deletedFormTypes:
            List<String>.from(json['deleted_form_types'] as List? ?? []),
        totalDeleted: json['total_deleted'] as int? ?? 0,
      );
}

// ── Service ────────────────────────────────────────────────────────────────

/// Wraps all `/stages/*` endpoints.
class StagesService {
  const StagesService(this._dio);

  final Dio _dio;

  // GET /stages
  Future<List<StageModel>> listStages({int skip = 0, int limit = 50}) async {
    try {
      final r = await _dio.get<List<dynamic>>(
        '/stages',
        queryParameters: {'skip': skip, 'limit': limit},
      );
      return r.data!
          .map((e) => StageModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw resolveError(e);
    }
  }

  // GET /stages/tree
  Future<List<StageTreeNode>> getTree({
    String? rootStageId,
    int? maxDepth,
    String? userId,
  }) async {
    try {
      final r = await _dio.get<List<dynamic>>(
        '/stages/tree',
        queryParameters: {
          if (rootStageId != null) 'root_stage_id': rootStageId,
          if (maxDepth != null) 'max_depth': maxDepth,
          if (userId != null) 'user_id': userId,
        },
      );
      return r.data!
          .map((e) => StageTreeNode.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw resolveError(e);
    }
  }

  // GET /stages/search?q=
  Future<List<StageModel>> search(String query, {int limit = 20}) async {
    try {
      final r = await _dio.get<List<dynamic>>(
        '/stages/search',
        queryParameters: {'q': query, 'limit': limit},
      );
      return r.data!
          .map((e) => StageModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw resolveError(e);
    }
  }

  // GET /stages/{stage_id}
  Future<StageModel> getById(String stageId) async {
    try {
      final r = await _dio.get<Map<String, dynamic>>('/stages/$stageId');
      return StageModel.fromJson(r.data!);
    } on DioException catch (e) {
      throw resolveError(e);
    }
  }

  // GET /stages/{stage_id}/permissions
  Future<Map<String, dynamic>> getPermissions(String stageId) async {
    try {
      final r = await _dio
          .get<Map<String, dynamic>>('/stages/$stageId/permissions');
      return r.data!;
    } on DioException catch (e) {
      throw resolveError(e);
    }
  }

  // POST /stages
  Future<StageModel> create({
    required String stageName,
    String? parentStageId,
    String visibilityScope = 'private',
    String? wbsPrefix,
  }) async {
    try {
      final r = await _dio.post<Map<String, dynamic>>(
        '/stages',
        data: {
          'stage_name': stageName,
          if (parentStageId != null) 'parent_stage_id': parentStageId,
          'visibility_scope': visibilityScope,
          if (wbsPrefix != null) 'wbs_prefix': wbsPrefix,
        },
      );
      return StageModel.fromJson(r.data!);
    } on DioException catch (e) {
      throw resolveError(e);
    }
  }

  // PUT /stages/{stage_id}
  Future<StageModel> update(
    String stageId, {
    String? stageName,
    String? visibilityScope,
    String? wbsPrefix,
  }) async {
    try {
      final r = await _dio.put<Map<String, dynamic>>(
        '/stages/$stageId',
        data: {
          if (stageName != null) 'stage_name': stageName,
          if (visibilityScope != null) 'visibility_scope': visibilityScope,
          if (wbsPrefix != null) 'wbs_prefix': wbsPrefix,
        },
      );
      return StageModel.fromJson(r.data!);
    } on DioException catch (e) {
      throw resolveError(e);
    }
  }

  // POST /stages/{stage_id}/move
  Future<StageMoveResult> move(
    String stageId, {
    required String targetParentId,
    bool updateLineage = true,
    bool updateMasterMetadata = true,
  }) async {
    try {
      final r = await _dio.post<Map<String, dynamic>>(
        '/stages/$stageId/move',
        data: {
          'target_parent_id': targetParentId,
          'options': {
            'update_lineage': updateLineage,
            'update_master_metadata': updateMasterMetadata,
          },
        },
      );
      return StageMoveResult.fromJson(r.data!);
    } on DioException catch (e) {
      throw resolveError(e);
    }
  }

  // DELETE /stages/{stage_id}
  Future<StageDeleteResult> delete(
    String stageId, {
    bool recursive = true,
    bool preview = false,
  }) async {
    try {
      final r = await _dio.delete<Map<String, dynamic>>(
        '/stages/$stageId',
        queryParameters: {'recursive': recursive, 'preview': preview},
      );
      return StageDeleteResult.fromJson(r.data!);
    } on DioException catch (e) {
      throw resolveError(e);
    }
  }
}

// ── Provider ──────────────────────────────────────────────────────────────────

final stagesServiceProvider = FutureProvider<StagesService>((ref) async {
  final dio = await ref.watch(dioProvider.future);
  return StagesService(dio);
});
