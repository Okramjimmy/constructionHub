import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/form_type_model.dart';
import '../services/form_types_service.dart';

// ── Form Types List ────────────────────────────────────────────────────────────

final formTypesProvider =
    AsyncNotifierProvider<FormTypesNotifier, List<FormTypeModel>>(
  FormTypesNotifier.new,
);

class FormTypesNotifier extends AsyncNotifier<List<FormTypeModel>> {
  @override
  Future<List<FormTypeModel>> build() => _fetch();

  Future<List<FormTypeModel>> _fetch() async {
    final svc = await ref.watch(formTypesServiceProvider.future);
    return svc.list(limit: 200);
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_fetch);
  }

  Future<FormTypeModel> create({
    required String formName,
    String? description,
    String version = '1.0.0',
    Map<String, dynamic>? schema,
    Map<String, dynamic>? workflowData,
  }) async {
    final svc = await ref.read(formTypesServiceProvider.future);
    final created = await svc.create(
      formName: formName,
      description: description,
      version: version,
      schema: schema,
      workflowData: workflowData,
    );
    state = AsyncData([created, ...state.value ?? []]);
    return created;
  }

  Future<void> updateFormType(
    String formTypeId, {
    String? formName,
    String? version,
    Map<String, dynamic>? schema,
    Map<String, dynamic>? workflowData,
  }) async {
    final svc = await ref.read(formTypesServiceProvider.future);
    final updated = await svc.update(
      formTypeId,
      formName: formName,
      version: version,
      schema: schema,
      workflowData: workflowData,
    );
    state = AsyncData(
      (state.value ?? [])
          .map((ft) => ft.formTypeId == formTypeId ? updated : ft)
          .toList(),
    );
  }

  Future<void> delete(String formTypeId) async {
    final svc = await ref.read(formTypesServiceProvider.future);
    await svc.delete(formTypeId);
    state = AsyncData(
      (state.value ?? [])
          .where((ft) => ft.formTypeId != formTypeId)
          .toList(),
    );
  }
}

// ── By-Stage Provider ─────────────────────────────────────────────────────────

/// Lists form types linked to a specific stage.
final formTypesByStageProvider =
    FutureProvider.family<List<FormTypeModel>, String>((ref, stageId) async {
  final svc = await ref.watch(formTypesServiceProvider.future);
  return svc.listByStage(stageId);
});

// ── Detail Provider ───────────────────────────────────────────────────────────

/// Full form type by ID (without schema).
final formTypeDetailProvider =
    FutureProvider.family<FormTypeModel, String>((ref, formTypeId) async {
  final svc = await ref.watch(formTypesServiceProvider.future);
  return svc.getById(formTypeId);
});

/// Full form type by ID (with schema included).
final formTypeWithSchemaProvider =
    FutureProvider.family<FormTypeModel, String>((ref, formTypeId) async {
  final svc = await ref.watch(formTypesServiceProvider.future);
  return svc.getWithSchema(formTypeId);
});

// ── Search Provider ───────────────────────────────────────────────────────────

final formTypeSearchProvider =
    FutureProvider.family<List<FormTypeModel>, String>((ref, query) async {
  if (query.trim().isEmpty) {
    return ref.watch(formTypesProvider).value ?? [];
  }
  final svc = await ref.watch(formTypesServiceProvider.future);
  return svc.search(query);
});
