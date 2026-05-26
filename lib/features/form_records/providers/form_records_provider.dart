import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/form_record_model.dart';
import '../services/form_records_service.dart';

// ── Records list per form-type ─────────────────────────────────────────────────

/// Paginates form records for a given [formTypeId].
///
/// Usage:
/// ```dart
/// final page = ref.watch(formRecordsProvider('ft1'));
/// ```
final formRecordsProvider =
    AsyncNotifierProvider.family<FormRecordsNotifier, FormRecordPage, String>(
  FormRecordsNotifier.new,
);

class FormRecordsNotifier
    extends FamilyAsyncNotifier<FormRecordPage, String> {
  @override
  Future<FormRecordPage> build(String formTypeId) => _fetch(formTypeId);

  Future<FormRecordPage> _fetch(String formTypeId) async {
    final svc = await ref.watch(formRecordsServiceProvider.future);
    return svc.list(formTypeId: formTypeId);
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _fetch(arg));
  }

  /// Creates a new record and prepends it to the local cache.
  Future<FormRecordModel> create(Map<String, dynamic> data) async {
    final svc = await ref.read(formRecordsServiceProvider.future);
    final created = await svc.create(formTypeId: arg, data: data);
    final current = state.value ?? const FormRecordPage(items: [], total: 0);
    state = AsyncData(FormRecordPage(
      items: [created, ...current.items],
      total: current.total + 1,
    ));
    return created;
  }

  /// Updates a record in the local cache.
  Future<FormRecordModel> updateRecord(
    String recordId,
    Map<String, dynamic> data,
  ) async {
    final svc = await ref.read(formRecordsServiceProvider.future);
    final updated = await svc.update(recordId, data: data);
    _replaceInCache(updated);
    return updated;
  }

  /// Executes a workflow transition on a record.
  Future<FormRecordModel> transition(
    String recordId, {
    required String trigger,
    String? remarks,
  }) async {
    final svc = await ref.read(formRecordsServiceProvider.future);
    final updated = await svc.transition(
      recordId,
      trigger: trigger,
      remarks: remarks,
    );
    _replaceInCache(updated);
    return updated;
  }

  /// Deletes a record from the server and removes it from the cache.
  Future<void> delete(String recordId) async {
    final svc = await ref.read(formRecordsServiceProvider.future);
    await svc.delete(recordId);
    final current = state.value ?? const FormRecordPage(items: [], total: 0);
    state = AsyncData(FormRecordPage(
      items: current.items.where((r) => r.recordId != recordId).toList(),
      total: (current.total - 1).clamp(0, 999999),
    ));
  }

  void _replaceInCache(FormRecordModel updated) {
    final current = state.value ?? const FormRecordPage(items: [], total: 0);
    state = AsyncData(FormRecordPage(
      items: current.items
          .map((r) => r.recordId == updated.recordId ? updated : r)
          .toList(),
      total: current.total,
    ));
  }
}

// ── Single record detail ───────────────────────────────────────────────────────

final formRecordDetailProvider =
    FutureProvider.family<FormRecordModel, String>((ref, recordId) async {
  final svc = await ref.watch(formRecordsServiceProvider.future);
  return svc.getById(recordId);
});

// ── Available workflow actions ─────────────────────────────────────────────────

/// Returns the list of valid trigger names for a record (e.g. ["submit", "cancel"]).
final formRecordActionsProvider =
    FutureProvider.family<List<String>, String>((ref, recordId) async {
  final svc = await ref.watch(formRecordsServiceProvider.future);
  return svc.getAvailableActions(recordId);
});
