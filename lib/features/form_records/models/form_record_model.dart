/// Represents a form record (inspection / checklist instance) returned by
/// `/form-records/*` endpoints.
class FormRecordModel {
  const FormRecordModel({
    required this.recordId,
    required this.formTypeId,
    required this.docname,
    required this.status,
    required this.data,
    required this.createdAt,
    required this.updatedAt,
    this.assignedRole,
    this.assignedDepartment,
    this.amendedFrom,
    this.submittedBy,
    this.submittedAt,
    this.createdBy,
  });

  final String recordId;
  final String formTypeId;

  /// Human-readable document name (e.g. "PO-2025-001").
  final String docname;

  /// Current workflow status (e.g. "Draft", "Submitted", "Approved").
  final String status;

  final String? assignedRole;
  final String? assignedDepartment;

  /// Free-form field data as submitted.
  final Map<String, dynamic> data;

  final String? amendedFrom;
  final String? submittedBy;
  final DateTime? submittedAt;
  final String? createdBy;
  final DateTime createdAt;
  final DateTime updatedAt;

  // ── Helpers ───────────────────────────────────────────────────────────────

  bool get isDraft => status == 'Draft';
  bool get isSubmitted => status == 'Submitted';
  bool get isApproved => status == 'Approved';
  bool get isCancelled => status == 'Cancelled';

  // ── Serialisation ─────────────────────────────────────────────────────────

  factory FormRecordModel.fromJson(Map<String, dynamic> json) =>
      FormRecordModel(
        recordId: json['record_id'] as String,
        formTypeId: json['form_type_id'] as String,
        docname: json['docname'] as String? ?? '',
        status: json['status'] as String? ?? 'Draft',
        assignedRole: json['assigned_role'] as String?,
        assignedDepartment: json['assigned_department'] as String?,
        data: Map<String, dynamic>.from(json['data'] as Map? ?? {}),
        amendedFrom: json['amended_from'] as String?,
        submittedBy: json['submitted_by'] as String?,
        submittedAt: json['submitted_at'] != null
            ? DateTime.parse(json['submitted_at'] as String)
            : null,
        createdBy: json['created_by'] as String?,
        createdAt: DateTime.parse(json['created_at'] as String),
        updatedAt: DateTime.parse(json['updated_at'] as String),
      );

  Map<String, dynamic> toJson() => {
        'record_id': recordId,
        'form_type_id': formTypeId,
        'docname': docname,
        'status': status,
        'assigned_role': assignedRole,
        'assigned_department': assignedDepartment,
        'data': data,
        'amended_from': amendedFrom,
        'submitted_by': submittedBy,
        'submitted_at': submittedAt?.toIso8601String(),
        'created_by': createdBy,
        'created_at': createdAt.toIso8601String(),
        'updated_at': updatedAt.toIso8601String(),
      };
}

// ── Paginated wrapper ──────────────────────────────────────────────────────────

class FormRecordPage {
  const FormRecordPage({required this.items, required this.total});

  final List<FormRecordModel> items;
  final int total;

  factory FormRecordPage.fromJson(Map<String, dynamic> json) => FormRecordPage(
        items: (json['items'] as List? ?? [])
            .map((e) => FormRecordModel.fromJson(e as Map<String, dynamic>))
            .toList(),
        total: json['total'] as int? ?? 0,
      );
}
