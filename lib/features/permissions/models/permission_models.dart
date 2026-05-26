// ── Stage Permission ──────────────────────────────────────────────────────────

class StagePermission {
  const StagePermission({
    required this.permissionId,
    required this.stageId,
    required this.roleName,
    required this.canView,
    required this.canCreate,
    required this.canEdit,
    required this.canDelete,
    required this.canManagePermissions,
    required this.grantedAt,
    this.grantedBy,
  });

  final int permissionId;
  final String stageId;
  final String roleName;
  final bool canView;
  final bool canCreate;
  final bool canEdit;
  final bool canDelete;
  final bool canManagePermissions;
  final String? grantedBy;
  final DateTime grantedAt;

  factory StagePermission.fromJson(Map<String, dynamic> json) =>
      StagePermission(
        permissionId: json['permission_id'] as int,
        stageId: json['stage_id'] as String,
        roleName: json['role_name'] as String,
        canView: json['can_view'] as bool? ?? false,
        canCreate: json['can_create'] as bool? ?? false,
        canEdit: json['can_edit'] as bool? ?? false,
        canDelete: json['can_delete'] as bool? ?? false,
        canManagePermissions:
            json['can_manage_permissions'] as bool? ?? false,
        grantedBy: json['granted_by'] as String?,
        grantedAt: DateTime.parse(json['granted_at'] as String),
      );
}

// ── Form Type Permission ──────────────────────────────────────────────────────

class FormTypePermission {
  const FormTypePermission({
    required this.permissionId,
    required this.formTypeId,
    required this.roleName,
    required this.canView,
    required this.canCreate,
    required this.canEdit,
    required this.canDelete,
    required this.canSubmit,
    required this.canVerify,
    required this.canCancel,
    required this.canAmend,
    required this.canManagePermissions,
    required this.grantedAt,
    this.grantedBy,
  });

  final int permissionId;
  final String formTypeId;
  final String roleName;
  final bool canView;
  final bool canCreate;
  final bool canEdit;
  final bool canDelete;
  final bool canSubmit;
  final bool canVerify;
  final bool canCancel;
  final bool canAmend;
  final bool canManagePermissions;
  final String? grantedBy;
  final DateTime grantedAt;

  factory FormTypePermission.fromJson(Map<String, dynamic> json) =>
      FormTypePermission(
        permissionId: json['permission_id'] as int,
        formTypeId: json['form_type_id'] as String,
        roleName: json['role_name'] as String,
        canView: json['can_view'] as bool? ?? false,
        canCreate: json['can_create'] as bool? ?? false,
        canEdit: json['can_edit'] as bool? ?? false,
        canDelete: json['can_delete'] as bool? ?? false,
        canSubmit: json['can_submit'] as bool? ?? false,
        canVerify: json['can_verify'] as bool? ?? false,
        canCancel: json['can_cancel'] as bool? ?? false,
        canAmend: json['can_amend'] as bool? ?? false,
        canManagePermissions:
            json['can_manage_permissions'] as bool? ?? false,
        grantedBy: json['granted_by'] as String?,
        grantedAt: DateTime.parse(json['granted_at'] as String),
      );
}

// ── Role Model ────────────────────────────────────────────────────────────────

class RoleModel {
  const RoleModel({
    required this.roleName,
    this.description,
    this.createdAt,
  });

  final String roleName;
  final String? description;
  final DateTime? createdAt;

  factory RoleModel.fromJson(Map<String, dynamic> json) => RoleModel(
        roleName: json['role_name'] as String,
        description: json['description'] as String?,
        createdAt: json['created_at'] != null
            ? DateTime.parse(json['created_at'] as String)
            : null,
      );
}

// ── Stage Permissions Bundle ──────────────────────────────────────────────────

/// Result of `GET /permissions/stages/{stage_id}` — permissions for a stage
/// plus its linked form types.
class StagePermissionsBundle {
  const StagePermissionsBundle({
    required this.stagePermissions,
    required this.formTypePermissions,
  });

  final List<StagePermission> stagePermissions;
  final List<FormTypePermission> formTypePermissions;

  factory StagePermissionsBundle.fromJson(Map<String, dynamic> json) =>
      StagePermissionsBundle(
        stagePermissions: (json['stage_permissions'] as List? ?? [])
            .map((e) =>
                StagePermission.fromJson(e as Map<String, dynamic>))
            .toList(),
        formTypePermissions:
            (json['form_type_permissions'] as List? ?? [])
                .map((e) =>
                    FormTypePermission.fromJson(e as Map<String, dynamic>))
                .toList(),
      );
}

// ── User Role Assignment ──────────────────────────────────────────────────────

class UserRoleAssignment {
  const UserRoleAssignment({
    required this.userId,
    required this.roleName,
    required this.assignedAt,
  });

  final String userId;
  final String roleName;
  final DateTime assignedAt;

  factory UserRoleAssignment.fromJson(Map<String, dynamic> json) =>
      UserRoleAssignment(
        userId: json['user_id'] as String,
        roleName: json['role_name'] as String,
        assignedAt: DateTime.parse(json['assigned_at'] as String),
      );
}

// ── Role Permissions Bundle ───────────────────────────────────────────────────

class RolePermissionsBundle {
  const RolePermissionsBundle({
    required this.roleName,
    required this.stagePermissions,
    required this.formTypePermissions,
  });

  final String roleName;
  final List<StagePermission> stagePermissions;
  final List<FormTypePermission> formTypePermissions;

  factory RolePermissionsBundle.fromJson(Map<String, dynamic> json) =>
      RolePermissionsBundle(
        roleName: json['role_name'] as String,
        stagePermissions: (json['stage_permissions'] as List? ?? [])
            .map((e) =>
                StagePermission.fromJson(e as Map<String, dynamic>))
            .toList(),
        formTypePermissions:
            (json['form_type_permissions'] as List? ?? [])
                .map((e) =>
                    FormTypePermission.fromJson(e as Map<String, dynamic>))
                .toList(),
      );
}
