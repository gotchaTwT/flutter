
class AppUser {
  final int? id;
  final String username;
  final String passwordHash;
  final String role;
  final String createdAt;

  const AppUser({
    this.id,
    required this.username,
    required this.passwordHash,
    required this.role,
    required this.createdAt,
  });

  factory AppUser.fromMap(Map<String, dynamic> map) => AppUser(
        id: map['id'] as int?,
        username: map['username'] as String,
        passwordHash: map['password_hash'] as String,
        role: map['role'] as String,
        createdAt: map['created_at'] as String,
      );

  bool get isAdmin => role == 'admin';
  bool get isFaculty => role == 'faculty';
  bool get isStudent => role == 'student';
}

