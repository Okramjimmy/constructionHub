// ── Master Metadata ───────────────────────────────────────────────────────────

class MasterMetadata {
  const MasterMetadata({
    required this.version,
    required this.generatedAt,
    required this.statistics,
    required this.tree,
  });

  final String version;
  final DateTime generatedAt;
  final Map<String, dynamic> statistics;

  /// Hierarchical stage tree (same shape as GET /stages/tree).
  final List<Map<String, dynamic>> tree;

  int get totalStages =>
      statistics['total_stages'] as int? ?? 0;
  int get totalFormTypes =>
      statistics['total_form_types'] as int? ?? 0;

  factory MasterMetadata.fromJson(Map<String, dynamic> json) =>
      MasterMetadata(
        version: json['version'] as String? ?? '1.0',
        generatedAt: DateTime.parse(json['generated_at'] as String),
        statistics:
            Map<String, dynamic>.from(json['statistics'] as Map? ?? {}),
        tree: List<Map<String, dynamic>>.from(json['tree'] as List? ?? []),
      );
}

// ── Metadata Registry ─────────────────────────────────────────────────────────

class MetadataRegistry {
  const MetadataRegistry({
    required this.stages,
    required this.formTypes,
  });

  /// O(1) lookup: stageId → stage info map.
  final Map<String, dynamic> stages;

  /// O(1) lookup: formTypeId → form type info map.
  final Map<String, dynamic> formTypes;

  factory MetadataRegistry.fromJson(Map<String, dynamic> json) =>
      MetadataRegistry(
        stages:
            Map<String, dynamic>.from(json['stages'] as Map? ?? {}),
        formTypes:
            Map<String, dynamic>.from(json['form_types'] as Map? ?? {}),
      );
}

// ── Stage Metadata ────────────────────────────────────────────────────────────

class StageMetadata {
  const StageMetadata({
    required this.stageId,
    required this.stageName,
    required this.depthLevel,
    required this.formTypes,
  });

  final String stageId;
  final String stageName;
  final int depthLevel;
  final List<Map<String, dynamic>> formTypes;

  factory StageMetadata.fromJson(Map<String, dynamic> json) =>
      StageMetadata(
        stageId: json['stage_id'] as String,
        stageName: json['stage_name'] as String,
        depthLevel: json['depth_level'] as int? ?? 0,
        formTypes: List<Map<String, dynamic>>.from(
            json['form_types'] as List? ?? []),
      );
}

// ── Metadata Statistics ───────────────────────────────────────────────────────

class MetadataStatistics {
  const MetadataStatistics({
    required this.stageStats,
    required this.providerInfo,
  });

  final Map<String, dynamic> stageStats;
  final Map<String, dynamic> providerInfo;

  int get totalStages => stageStats['total_stages'] as int? ?? 0;
  int get rootStages => stageStats['root_stages'] as int? ?? 0;
  int get leafStages => stageStats['leaf_stages'] as int? ?? 0;

  factory MetadataStatistics.fromJson(Map<String, dynamic> json) =>
      MetadataStatistics(
        stageStats:
            Map<String, dynamic>.from(json['stages'] as Map? ?? {}),
        providerInfo:
            Map<String, dynamic>.from(json['provider'] as Map? ?? {}),
      );
}

// ── Validation Result ─────────────────────────────────────────────────────────

class MetadataValidationResult {
  const MetadataValidationResult({
    required this.valid,
    required this.issues,
    required this.checkedStages,
    required this.checkedFormTypes,
  });

  final bool valid;
  final List<String> issues;
  final int checkedStages;
  final int checkedFormTypes;

  factory MetadataValidationResult.fromJson(Map<String, dynamic> json) =>
      MetadataValidationResult(
        valid: json['valid'] as bool? ?? false,
        issues: List<String>.from(json['issues'] as List? ?? []),
        checkedStages: json['checked_stages'] as int? ?? 0,
        checkedFormTypes: json['checked_form_types'] as int? ?? 0,
      );
}
