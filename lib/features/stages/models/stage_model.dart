/// Represents a Stage returned by `GET /stages/{stage_id}` and related endpoints.
class StageModel {
  const StageModel({
    required this.stageId,
    required this.stageName,
    required this.stagePath,
    required this.depthLevel,
    required this.lineagePath,
    required this.childrenCount,
    required this.formTypeCount,
    required this.isRoot,
    required this.isLeaf,
    required this.visibilityScope,
    required this.createdAt,
    required this.updatedAt,
    this.parentStageId,
    this.wbsPrefix,
    this.createdBy,
  });

  final String stageId;
  final String stageName;
  final String? parentStageId;
  final String stagePath;
  final int depthLevel;
  final List<String> lineagePath;
  final int childrenCount;
  final int formTypeCount;
  final bool isRoot;
  final bool isLeaf;

  /// One of: "public", "private", "restricted".
  final String visibilityScope;
  final String? wbsPrefix;
  final String? createdBy;
  final DateTime createdAt;
  final DateTime updatedAt;

  factory StageModel.fromJson(Map<String, dynamic> json) => StageModel(
        stageId: json['stage_id'] as String,
        stageName: json['stage_name'] as String,
        parentStageId: json['parent_stage_id'] as String?,
        stagePath: json['stage_path'] as String? ?? '',
        depthLevel: json['depth_level'] as int? ?? 0,
        lineagePath: List<String>.from(json['lineage_path'] as List? ?? []),
        childrenCount: json['children_count'] as int? ?? 0,
        formTypeCount: json['formtype_count'] as int? ?? 0,
        isRoot: json['is_root'] as bool? ?? false,
        isLeaf: json['is_leaf'] as bool? ?? false,
        visibilityScope: json['visibility_scope'] as String? ?? 'private',
        wbsPrefix: json['wbs_prefix'] as String?,
        createdBy: json['created_by'] as String?,
        createdAt: DateTime.parse(json['created_at'] as String),
        updatedAt: DateTime.parse(json['updated_at'] as String),
      );

  Map<String, dynamic> toJson() => {
        'stage_id': stageId,
        'stage_name': stageName,
        'parent_stage_id': parentStageId,
        'stage_path': stagePath,
        'depth_level': depthLevel,
        'lineage_path': lineagePath,
        'children_count': childrenCount,
        'formtype_count': formTypeCount,
        'is_root': isRoot,
        'is_leaf': isLeaf,
        'visibility_scope': visibilityScope,
        'wbs_prefix': wbsPrefix,
        'created_by': createdBy,
        'created_at': createdAt.toIso8601String(),
        'updated_at': updatedAt.toIso8601String(),
      };
}
