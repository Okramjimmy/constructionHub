/// Represents a form type returned by `/form-types/*` endpoints.
class FormTypeModel {
  const FormTypeModel({
    required this.formTypeId,
    required this.formName,
    required this.version,
    required this.createdAt,
    required this.updatedAt,
    this.description,
    this.schemaReference,
    this.workflowData,
    this.createdBy,
  });

  final String formTypeId;
  final String formName;
  final String? description;
  final String version;

  /// The JSON schema describing this form's fields. May be null on list endpoints.
  final Map<String, dynamic>? schemaReference;

  /// Workflow state-machine definition. May be null.
  final Map<String, dynamic>? workflowData;

  final String? createdBy;
  final DateTime createdAt;
  final DateTime updatedAt;

  // ── Helpers ───────────────────────────────────────────────────────────────

  /// Field definitions extracted from the schema (if present).
  List<Map<String, dynamic>> get fields {
    final raw = schemaReference?['fields'];
    if (raw is List) {
      return raw.cast<Map<String, dynamic>>();
    }
    return const [];
  }

  // ── Serialisation ─────────────────────────────────────────────────────────

  factory FormTypeModel.fromJson(Map<String, dynamic> json) => FormTypeModel(
        formTypeId: json['form_type_id'] as String,
        formName: json['form_name'] as String,
        description: json['description'] as String?,
        version: json['version'] as String? ?? '1.0.0',
        schemaReference: json['schema_reference'] as Map<String, dynamic>?,
        workflowData: json['workflow_data'] as Map<String, dynamic>?,
        createdBy: json['created_by'] as String?,
        createdAt: DateTime.parse(json['created_at'] as String),
        updatedAt: DateTime.parse(json['updated_at'] as String),
      );

  Map<String, dynamic> toJson() => {
        'form_type_id': formTypeId,
        'form_name': formName,
        'description': description,
        'version': version,
        'schema_reference': schemaReference,
        'workflow_data': workflowData,
        'created_by': createdBy,
        'created_at': createdAt.toIso8601String(),
        'updated_at': updatedAt.toIso8601String(),
      };
}
