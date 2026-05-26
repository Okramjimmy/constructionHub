import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/metadata_models.dart';
import '../services/metadata_service.dart';

// ── Master Metadata ───────────────────────────────────────────────────────────

final masterMetadataProvider =
    FutureProvider<MasterMetadata>((ref) async {
  final svc = await ref.watch(metadataServiceProvider.future);
  return svc.getMaster();
});

// ── Registry ──────────────────────────────────────────────────────────────────

final metadataRegistryProvider =
    FutureProvider<MetadataRegistry>((ref) async {
  final svc = await ref.watch(metadataServiceProvider.future);
  return svc.getRegistry();
});

// ── Statistics ────────────────────────────────────────────────────────────────

final metadataStatisticsProvider =
    FutureProvider<MetadataStatistics>((ref) async {
  final svc = await ref.watch(metadataServiceProvider.future);
  return svc.getStatistics();
});

// ── Stage metadata ────────────────────────────────────────────────────────────

final stageMetadataProvider =
    FutureProvider.family<StageMetadata, String>((ref, stageId) async {
  final svc = await ref.watch(metadataServiceProvider.future);
  return svc.getStageMetadata(stageId);
});

// ── Validation ────────────────────────────────────────────────────────────────

final metadataValidationProvider =
    FutureProvider<MetadataValidationResult>((ref) async {
  final svc = await ref.watch(metadataServiceProvider.future);
  return svc.validate();
});
