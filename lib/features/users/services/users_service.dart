import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_client.dart';
import '../../auth/models/user_model.dart';

/// Wraps all `/users/*` endpoints.
class UsersService {
  const UsersService(this._dio);

  final Dio _dio;

  // GET /users
  Future<List<UserModel>> list({int skip = 0, int limit = 50}) async {
    try {
      final r = await _dio.get<List<dynamic>>(
        '/users',
        queryParameters: {'skip': skip, 'limit': limit},
      );
      return r.data!
          .map((e) => UserModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw resolveError(e);
    }
  }

  // POST /users
  Future<UserModel> create({
    required String username,
    required String email,
    required String fullName,
    required String password,
    String? department,
    String? phone,
    String? managerId,
    List<String> roles = const [],
  }) async {
    try {
      final r = await _dio.post<Map<String, dynamic>>(
        '/users',
        data: {
          'username': username,
          'email': email,
          'full_name': fullName,
          'password': password,
          if (department != null) 'department': department,
          if (phone != null) 'phone': phone,
          if (managerId != null) 'manager_id': managerId,
          if (roles.isNotEmpty) 'roles': roles,
        },
      );
      return UserModel.fromJson(r.data!);
    } on DioException catch (e) {
      throw resolveError(e);
    }
  }

  // GET /users/{user_id}
  Future<UserModel> getById(String userId) async {
    try {
      final r = await _dio.get<Map<String, dynamic>>('/users/$userId');
      return UserModel.fromJson(r.data!);
    } on DioException catch (e) {
      throw resolveError(e);
    }
  }

  // PUT /users/{user_id}
  Future<UserModel> update(
    String userId, {
    String? fullName,
    String? email,
    String? department,
    String? phone,
  }) async {
    try {
      final r = await _dio.put<Map<String, dynamic>>(
        '/users/$userId',
        data: {
          if (fullName != null) 'full_name': fullName,
          if (email != null) 'email': email,
          if (department != null) 'department': department,
          if (phone != null) 'phone': phone,
        },
      );
      return UserModel.fromJson(r.data!);
    } on DioException catch (e) {
      throw resolveError(e);
    }
  }

  // PUT /users/{user_id}/password
  Future<void> changePassword(
    String userId, {
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    try {
      await _dio.put<void>(
        '/users/$userId/password',
        data: {
          'current_password': currentPassword,
          'password': newPassword,
          'confirm_password': confirmPassword,
        },
      );
    } on DioException catch (e) {
      throw resolveError(e);
    }
  }

  // PUT /users/{user_id}/status?is_active=
  Future<UserModel> setStatus(String userId, {required bool isActive}) async {
    try {
      final r = await _dio.put<Map<String, dynamic>>(
        '/users/$userId/status',
        queryParameters: {'is_active': isActive},
      );
      return UserModel.fromJson(r.data!);
    } on DioException catch (e) {
      throw resolveError(e);
    }
  }

  // POST /users/{user_id}/photo (multipart)
  Future<UserModel> uploadPhoto(String userId, String filePath) async {
    try {
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(filePath),
      });
      final r = await _dio.post<Map<String, dynamic>>(
        '/users/$userId/photo',
        data: formData,
        options: Options(contentType: 'multipart/form-data'),
      );
      return UserModel.fromJson(r.data!);
    } on DioException catch (e) {
      throw resolveError(e);
    }
  }

  // GET /users/{user_id}/photo
  Future<String> getPhotoUrl(String userId) async {
    try {
      final r =
          await _dio.get<Map<String, dynamic>>('/users/$userId/photo');
      return r.data!['url'] as String;
    } on DioException catch (e) {
      throw resolveError(e);
    }
  }

  // GET /users/{user_id}/roles
  Future<List<String>> getRoles(String userId) async {
    try {
      final r =
          await _dio.get<Map<String, dynamic>>('/users/$userId/roles');
      return List<String>.from(r.data!['roles'] as List? ?? []);
    } on DioException catch (e) {
      throw resolveError(e);
    }
  }

  // POST /users/{user_id}/roles
  Future<List<String>> assignRoles(String userId, List<String> roles) async {
    try {
      final r = await _dio.post<Map<String, dynamic>>(
        '/users/$userId/roles',
        data: roles,
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );
      return List<String>.from(r.data!['roles'] as List? ?? []);
    } on DioException catch (e) {
      throw resolveError(e);
    }
  }

  // DELETE /users/{user_id}/roles/{role_name}
  Future<void> revokeRole(String userId, String roleName) async {
    try {
      await _dio.delete<void>('/users/$userId/roles/$roleName');
    } on DioException catch (e) {
      throw resolveError(e);
    }
  }
}

// ── Provider ──────────────────────────────────────────────────────────────────

final usersServiceProvider = FutureProvider<UsersService>((ref) async {
  final dio = await ref.watch(dioProvider.future);
  return UsersService(dio);
});
