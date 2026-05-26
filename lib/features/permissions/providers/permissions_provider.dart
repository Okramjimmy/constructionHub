import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/permission_models.dart';
import '../services/permissions_service.dart';

// ── Roles list ────────────────────────────────────────────────────────────────

final rolesProvider =
    AsyncNotifierProvider<RolesNotifier, List<RoleModel>>(
  RolesNotifier.new,
);

class RolesNotifier extends AsyncNotifier<List<RoleModel>> {
  @override
  Future<List<RoleModel>> build() => _fetch();

  Future<List<RoleModel>> _fetch() async {
    final svc = await ref.watch(permissionsServiceProvider.future);
    return svc.listRoles();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_fetch);
  }

  Future<RoleModel> create(String roleName, {String? description}) async {
    final svc = await ref.read(permissionsServiceProvider.future);
    final created = await svc.createRole(roleName, description: description);
    state = AsyncData([...state.value ?? [], created]);
    return created;
  }

  Future<void> delete(String roleName) async {
    final svc = await ref.read(permissionsServiceProvider.future);
    await svc.deleteRole(roleName);
    state = AsyncData(
      (state.value ?? []).where((r) => r.roleName != roleName).toList(),
    );
  }

  Future<void> rename(String oldName, String newName) async {
    final svc = await ref.read(permissionsServiceProvider.future);
    await svc.renameRole(oldName, newName);
    await refresh();
  }
}

// ── Stage permissions for a given stage ───────────────────────────────────────

final stagePermissionsBundleProvider =
    FutureProvider.family<StagePermissionsBundle, String>(
        (ref, stageId) async {
  final svc = await ref.watch(permissionsServiceProvider.future);
  return svc.getStagePermissions(stageId);
});

// ── Role permissions bundle ───────────────────────────────────────────────────

final rolePermissionsProvider =
    FutureProvider.family<RolePermissionsBundle, String>(
        (ref, roleName) async {
  final svc = await ref.watch(permissionsServiceProvider.future);
  return svc.getRolePermissions(roleName);
});

// ── User roles ────────────────────────────────────────────────────────────────

final userPermissionRolesProvider =
    FutureProvider.family<List<String>, String>((ref, userId) async {
  final svc = await ref.watch(permissionsServiceProvider.future);
  return svc.getUserRoles(userId);
});

// ── Accessible stages for a user ─────────────────────────────────────────────

final accessibleStagesProvider =
    FutureProvider.family<Map<String, dynamic>, String>((ref, userId) async {
  final svc = await ref.watch(permissionsServiceProvider.future);
  return svc.getAccessibleStages(userId);
});
