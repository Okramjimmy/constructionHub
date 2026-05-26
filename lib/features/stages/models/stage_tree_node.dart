import 'stage_model.dart';

/// A summary of a form type as it appears inside a stage tree node.
class FormTypeSummary {
  const FormTypeSummary({
    required this.formTypeId,
    required this.formName,
    this.version,
  });

  final String formTypeId;
  final String formName;
  final String? version;

  factory FormTypeSummary.fromJson(Map<String, dynamic> json) =>
      FormTypeSummary(
        formTypeId: json['form_type_id'] as String,
        formName: json['form_name'] as String,
        version: json['version'] as String?,
      );
}

/// A recursive tree node returned by `GET /stages/tree`.
class StageTreeNode {
  const StageTreeNode({
    required this.stageId,
    required this.stageName,
    required this.depthLevel,
    required this.children,
    required this.formTypes,
    this.stagePath,
    this.visibilityScope,
  });

  final String stageId;
  final String stageName;
  final int depthLevel;
  final String? stagePath;
  final String? visibilityScope;
  final List<StageTreeNode> children;
  final List<FormTypeSummary> formTypes;

  /// Back-compat adapter: flat [StageModel] from this node.
  StageModel toStageModel(DateTime fallback) => StageModel(
        stageId: stageId,
        stageName: stageName,
        stagePath: stagePath ?? stageName,
        depthLevel: depthLevel,
        lineagePath: const [],
        childrenCount: children.length,
        formTypeCount: formTypes.length,
        isRoot: depthLevel == 0,
        isLeaf: children.isEmpty,
        visibilityScope: visibilityScope ?? 'private',
        createdAt: fallback,
        updatedAt: fallback,
      );

  factory StageTreeNode.fromJson(Map<String, dynamic> json) => StageTreeNode(
        stageId: json['stage_id'] as String,
        stageName: json['stage_name'] as String,
        depthLevel: json['depth_level'] as int? ?? 0,
        stagePath: json['stage_path'] as String?,
        visibilityScope: json['visibility_scope'] as String?,
        children: (json['children'] as List? ?? [])
            .map((c) => StageTreeNode.fromJson(c as Map<String, dynamic>))
            .toList(),
        formTypes: (json['form_types'] as List? ?? [])
            .map((f) => FormTypeSummary.fromJson(f as Map<String, dynamic>))
            .toList(),
      );
}
