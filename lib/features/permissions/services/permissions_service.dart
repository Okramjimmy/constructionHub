import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_client.dart';
import '../models/permission_models.dart';

/// Wraps all `/permissions/*` endpoints.
class PermissionsService {
  const PermissionsService(this._dio);

  final Dio _dio;

  // ── Stage Permissions ─────────────────────────────────────────────────────

  // POST /permissions/stages/{stage_id}
  Future<StagePermission> grantStagePermission(
    String stageId, {
    required String roleName,
    bool canView = false,
    bool canCreate = false,
    bool canEdit = false,
    bool canDelete = false,
    bool canManagePermissions = false,
  }) async {
    try {
      final r = await _dio.post<Map<String, dynamic>>(
        '/permissions/stages/$stageId',
        data: {
          'role_name': roleName,
          'can_view': canView,
          'can_create': canCreate,
          'can_edit': canEdit,
          'can_delete': canDelete,
          'can_manage_permissions': canManagePermissions,
        },
      );
      return StagePermission.fromJson(r.data!);
    } on DioException catch (e) {
      throw resolveError(e);
    }
  }

  // DELETE /permissions/stages/{stage_id}/roles/{role_name}
  Future<void> revokeStagePermission(
      String stageId, String roleName) async {
    try {
      await _dio.delete<void>(
          '/permissions/stages/$stageId/roles/$roleName');
    } on DioException catch (e) {
      throw resolveError(e);
    }
  }

  // GET /permissions/stages/{stage_id}
  Future<StagePermissionsBundle> getStagePermissions(
      String stageId) async {
    try {
      final r = await _dio
          .get<Map<String, dynamic>>('/permissions/stages/$stageId');
      return StagePermissionsBundle.fromJson(r.data!);
    } on DioException catch (e) {
      throw resolveError(e);
    }
  }

  // GET /permissions/stages (list all, optional role filter)
  Future<List<StagePermission>> listStagePermissions(
      {String? roleName}) async {
    try {
      final r = await _dio.get<List<dynamic>>(
        '/permissions/stages',
        queryParameters: {if (roleName != null) 'role_name': roleName},
      );
      return r.data!
          .map((e) => StagePermission.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw resolveError(e);
    }
  }

  // ── Form Type Permissions ─────────────────────────────────────────────────

  // POST /permissions/form-types/{form_type_id}
  Future<FormTypePermission> grantFormTypePermission(
    String formTypeId, {
    required String roleName,
    bool canView = false,
    bool canCreate = false,
    bool canEdit = false,
    bool canDelete = false,
    bool canSubmit = false,
    bool canVerify = false,
    bool canCancel = false,
    bool canAmend = false,
    bool canManagePermissions = false,
  }) async {
    try {
      final r = await _dio.post<Map<String, dynamic>>(
        '/permissions/form-types/$formTypeId',
        data: {
          'role_name': roleName,
          'can_view': canView,
          'can_create': canCreate,
          'can_edit': canEdit,
          'can_delete': canDelete,
          'can_submit': canSubmit,
          'can_verify': canVerify,
          'can_cancel': canCancel,
          'can_amend': canAmend,
          'can_manage_permissions': canManagePermissions,
        },
      );
      return FormTypePermission.fromJson(r.data!);
    } on DioException catch (e) {
      throw resolveError(e);
    }
  }

  // DELETE /permissions/form-types/{form_type_id}/roles/{role_name}
  Future<void> revokeFormTypePermission(
      String formTypeId, String roleName) async {
    try {
      await _dio.delete<void>(
          '/permissions/form-types/$formTypeId/roles/$roleName');
    } on DioException catch (e) {
      throw resolveError(e);
    }
  }

  // GET /permissions/form-types (list all, optional role filter)
  Future<List<FormTypePermission>> listFormTypePermissions(
      {String? roleName}) async {
    try {
      final r = await _dio.get<List<dynamic>>(
        '/permissions/form-types',
        queryParameters: {if (roleName != null) 'role_name': roleName},
      );
      return r.data!
          .map((e) =>
              FormTypePermission.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw resolveError(e);
    }
  }

  // ── Roles ─────────────────────────────────────────────────────────────────

  // GET /permissions/roles
  Future<List<RoleModel>> listRoles() async {
    try {
      final r = await _dio.get<List<dynamic>>('/permissions/roles');
      return r.data!
          .map((e) => RoleModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw resolveError(e);
    }
  }

  // POST /permissions/roles
  Future<RoleModel> createRole(String roleName,
      {String? description}) async {
    try {
      final r = await _dio.post<Map<String, dynamic>>(
        '/permissions/roles',
        data: {
          'role_name': roleName,
          if (description != null) 'description': description,
        },
      );
      return RoleModel.fromJson(r.data!);
    } on DioException catch (e) {
      throw resolveError(e);
    }
  }

  // DELETE /permissions/roles/{role_name}
  Future<void> deleteRole(String roleName) async {
    try {
      await _dio.delete<void>('/permissions/roles/$roleName');
    } on DioException catch (e) {
      throw resolveError(e);
    }
  }

  // PUT /permissions/roles/{old_role_name}?new_role_name=
  Future<Map<String, dynamic>> renameRole(
      String oldRoleName, String newRoleName) async {
    try {
      final r = await _dio.put<Map<String, dynamic>>(
        '/permissions/roles/$oldRoleName',
        queryParameters: {'new_role_name': newRoleName},
      );
      return r.data!;
    } on DioException catch (e) {
      throw resolveError(e);
    }
  }

  // GET /permissions/roles/{role_name}
  Future<RolePermissionsBundle> getRolePermissions(
      String roleName) async {
    try {
      final r = await _dio
          .get<Map<String, dynamic>>('/permissions/roles/$roleName');
      return RolePermissionsBundle.fromJson(r.data!);
    } on DioException catch (e) {
      throw resolveError(e);
    }
  }

  // ── User-Role Assignments ─────────────────────────────────────────────────

  // POST /permissions/users/roles
  Future<UserRoleAssignment> assignRoleToUser(
      String userId, String roleName) async {
    try {
      final r = await _dio.post<Map<String, dynamic>>(
        '/permissions/users/roles',
        data: {'user_id': userId, 'role_name': roleName},
      );
      return UserRoleAssignment.fromJson(r.data!);
    } on DioException catch (e) {
      throw resolveError(e);
    }
  }

  // GET /permissions/users/{user_id}/roles
  Future<List<String>> getUserRoles(String userId) async {
    try {
      final r = await _dio
          .get<Map<String, dynamic>>('/permissions/users/$userId/roles');
      return List<String>.from(r.data!['roles'] as List? ?? []);
    } on DioException catch (e) {
      throw resolveError(e);
    }
  }

  // GET /permissions/users/{user_id}/accessible-stages
  Future<Map<String, dynamic>> getAccessibleStages(String userId) async {
    try {
      final r = await _dio.get<Map<String, dynamic>>(
          '/permissions/users/$userId/accessible-stages');
      return r.data!;
    } on DioException catch (e) {
      throw resolveError(e);
    }
  }

  // GET /permissions/users/{user_id}/check-stage/{stage_id}
  Future<bool> checkStagePermission(
    String userId,
    String stageId, {
    required String permissionType,
  }) async {
    try {
      final r = await _dio.get<Map<String, dynamic>>(
        '/permissions/users/$userId/check-stage/$stageId',
        queryParameters: {'permission_type': permissionType},
      );
      return r.data!['has_permission'] as bool? ?? false;
    } on DioException catch (e) {
      throw resolveError(e);
    }
  }
}

// ── Provider ──────────────────────────────────────────────────────────────────

final permissionsServiceProvider =
    FutureProvider<PermissionsService>((ref) async {
  final dio = await ref.watch(dioProvider.future);
  return PermissionsService(dio);
});
