import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/models/user_model.dart';
import '../services/users_service.dart';

// ── Users list ────────────────────────────────────────────────────────────────

final usersListProvider =
    AsyncNotifierProvider<UsersListNotifier, List<UserModel>>(
  UsersListNotifier.new,
);

class UsersListNotifier extends AsyncNotifier<List<UserModel>> {
  @override
  Future<List<UserModel>> build() => _fetch();

  Future<List<UserModel>> _fetch() async {
    final svc = await ref.watch(usersServiceProvider.future);
    return svc.list(limit: 200);
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_fetch);
  }

  Future<UserModel> create({
    required String username,
    required String email,
    required String fullName,
    required String password,
    String? department,
    String? phone,
    List<String> roles = const [],
  }) async {
    final svc = await ref.read(usersServiceProvider.future);
    final created = await svc.create(
      username: username,
      email: email,
      fullName: fullName,
      password: password,
      department: department,
      phone: phone,
      roles: roles,
    );
    state = AsyncData([created, ...state.value ?? []]);
    return created;
  }

  Future<UserModel> updateUser(
    String userId, {
    String? fullName,
    String? email,
    String? department,
    String? phone,
  }) async {
    final svc = await ref.read(usersServiceProvider.future);
    final updated = await svc.update(
      userId,
      fullName: fullName,
      email: email,
      department: department,
      phone: phone,
    );
    state = AsyncData(
      (state.value ?? [])
          .map((u) => u.userId == userId ? updated : u)
          .toList(),
    );
    return updated;
  }

  Future<void> setStatus(String userId, {required bool isActive}) async {
    final svc = await ref.read(usersServiceProvider.future);
    final updated = await svc.setStatus(userId, isActive: isActive);
    state = AsyncData(
      (state.value ?? [])
          .map((u) => u.userId == userId ? updated : u)
          .toList(),
    );
  }
}

// ── Single user detail ────────────────────────────────────────────────────────

final userDetailProvider =
    FutureProvider.family<UserModel, String>((ref, userId) async {
  final svc = await ref.watch(usersServiceProvider.future);
  return svc.getById(userId);
});

// ── User roles ────────────────────────────────────────────────────────────────

final userRolesProvider =
    FutureProvider.family<List<String>, String>((ref, userId) async {
  final svc = await ref.watch(usersServiceProvider.future);
  return svc.getRoles(userId);
});
