/// Represents the authenticated user returned by `POST /auth/login`
/// and `GET /auth/me`.
class UserModel {
  const UserModel({
    required this.userId,
    required this.username,
    required this.email,
    required this.fullName,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    required this.roles,
    this.department,
    this.phone,
    this.managerId,
    this.profilePhotoUrl,
  });

  final String userId;
  final String username;
  final String email;
  final String fullName;
  final String? department;
  final String? phone;
  final String? managerId;
  final String? profilePhotoUrl;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<String> roles;

  // ── Derived helpers ───────────────────────────────────────────────────────

  bool get isSuperAdmin => roles.contains('superadmin');
  String get displayName => fullName.isNotEmpty ? fullName : username;

  // ── Serialisation ─────────────────────────────────────────────────────────

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        userId: json['user_id'] as String,
        username: json['username'] as String,
        email: json['email'] as String,
        fullName: json['full_name'] as String? ?? '',
        department: json['department'] as String?,
        phone: json['phone'] as String?,
        managerId: json['manager_id'] as String?,
        profilePhotoUrl: json['profile_photo_url'] as String?,
        isActive: json['is_active'] as bool? ?? true,
        createdAt: DateTime.parse(json['created_at'] as String),
        updatedAt: DateTime.parse(json['updated_at'] as String),
        roles: List<String>.from(json['roles'] as List? ?? []),
      );

  Map<String, dynamic> toJson() => {
        'user_id': userId,
        'username': username,
        'email': email,
        'full_name': fullName,
        'department': department,
        'phone': phone,
        'manager_id': managerId,
        'profile_photo_url': profilePhotoUrl,
        'is_active': isActive,
        'created_at': createdAt.toIso8601String(),
        'updated_at': updatedAt.toIso8601String(),
        'roles': roles,
      };

  UserModel copyWith({
    String? fullName,
    String? email,
    String? department,
    String? phone,
    String? profilePhotoUrl,
    List<String>? roles,
  }) {
    return UserModel(
      userId: userId,
      username: username,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      department: department ?? this.department,
      phone: phone ?? this.phone,
      managerId: managerId,
      profilePhotoUrl: profilePhotoUrl ?? this.profilePhotoUrl,
      isActive: isActive,
      createdAt: createdAt,
      updatedAt: updatedAt,
      roles: roles ?? this.roles,
    );
  }
}
