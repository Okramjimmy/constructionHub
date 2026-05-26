import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_exception.dart';
import '../models/stage_model.dart';
import '../models/stage_tree_node.dart';
import '../services/stages_service.dart';

// ── Stages List Provider ───────────────────────────────────────────────────────

/// Async list of all stages from the server, paginated (first 100).
final stagesListProvider =
    AsyncNotifierProvider<StagesListNotifier, List<StageModel>>(
  StagesListNotifier.new,
);

class StagesListNotifier extends AsyncNotifier<List<StageModel>> {
  @override
  Future<List<StageModel>> build() => _fetch();

  Future<List<StageModel>> _fetch() async {
    final service = await ref.watch(stagesServiceProvider.future);
    return service.listStages(limit: 100);
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_fetch);
  }

  /// Creates a new stage and prepends it to the local list.
  Future<StageModel> create({
    required String stageName,
    String? parentStageId,
    String visibilityScope = 'private',
    String? wbsPrefix,
  }) async {
    final service = await ref.read(stagesServiceProvider.future);
    final created = await service.create(
      stageName: stageName,
      parentStageId: parentStageId,
      visibilityScope: visibilityScope,
      wbsPrefix: wbsPrefix,
    );
    state = AsyncData([created, ...state.value ?? []]);
    return created;
  }

  /// Updates a stage in-place and refreshes from the server.
  Future<void> updateStage(
    String stageId, {
    String? stageName,
    String? visibilityScope,
    String? wbsPrefix,
  }) async {
    final service = await ref.read(stagesServiceProvider.future);
    final updated = await service.update(
      stageId,
      stageName: stageName,
      visibilityScope: visibilityScope,
      wbsPrefix: wbsPrefix,
    );
    state = AsyncData(
      (state.value ?? [])
          .map((s) => s.stageId == stageId ? updated : s)
          .toList(),
    );
  }

  /// Deletes a stage and removes it from the local list.
  Future<void> delete(String stageId) async {
    final service = await ref.read(stagesServiceProvider.future);
    await service.delete(stageId);
    state = AsyncData(
      (state.value ?? []).where((s) => s.stageId != stageId).toList(),
    );
  }
}

// ── Stage Tree Provider ────────────────────────────────────────────────────────

/// Full hierarchical stage tree from `GET /stages/tree`.
final stageTreeProvider =
    AsyncNotifierProvider<StageTreeNotifier, List<StageTreeNode>>(
  StageTreeNotifier.new,
);

class StageTreeNotifier extends AsyncNotifier<List<StageTreeNode>> {
  @override
  Future<List<StageTreeNode>> build() => _fetch();

  Future<List<StageTreeNode>> _fetch() async {
    final service = await ref.watch(stagesServiceProvider.future);
    return service.getTree();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_fetch);
  }
}

// ── Stage Detail Provider ─────────────────────────────────────────────────────

/// Fetches a single stage by ID.
final stageDetailProvider =
    FutureProvider.family<StageModel, String>((ref, stageId) async {
  final service = await ref.watch(stagesServiceProvider.future);
  return service.getById(stageId);
});

// ── Stage Search Provider ─────────────────────────────────────────────────────

/// Search stages by query string.
final stageSearchProvider =
    FutureProvider.family<List<StageModel>, String>((ref, query) async {
  if (query.trim().isEmpty) {
    return ref.watch(stagesListProvider).value ?? [];
  }
  final service = await ref.watch(stagesServiceProvider.future);
  return service.search(query);
});

// ── Stage Permissions Provider ────────────────────────────────────────────────

final stagePermissionsProvider =
    FutureProvider.family<Map<String, dynamic>, String>((ref, stageId) async {
  final service = await ref.watch(stagesServiceProvider.future);
  return service.getPermissions(stageId);
});

// ── Error helper ──────────────────────────────────────────────────────────────

extension StageAsyncError on AsyncValue {
  /// Returns an [ApiException] if available, else the raw error.
  ApiException? get apiError {
    if (this case AsyncError(:final error)) {
      if (error is ApiException) return error;
    }
    return null;
  }
}
