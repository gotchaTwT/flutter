
import 'dart:convert';
import 'package:crypto/crypto.dart';
import '../models/app_user.dart';
import '../repositories/user_repository.dart';
import '../database/database_helper.dart';

class AuthService {
  final UserRepository users;
  final DatabaseHelper db;

  AuthService(this.users, this.db);

  Future<AppUser?> login(String username, String password) async {
    final user = await users.findByUsername(username.trim());
    if (user == null) return null;

    final hash = sha256.convert(utf8.encode(password)).toString();

    // The seeded development accounts are intentionally created by the
    // database helper using a simple teaching hash. To keep the demo usable,
    // compare against both the secure SHA-256 form and the seeded teaching hash.
    final legacy = _teachingHash(password);
    if (user.passwordHash != hash && user.passwordHash != legacy) return null;

    await logAction(
      userId: user.id,
      action: 'LOGIN',
      entity: 'User',
      entityId: user.id?.toString(),
      details: 'Successful login',
    );

    return user;
  }

  Future<void> logout(AppUser user) async {
    await logAction(
      userId: user.id,
      action: 'LOGOUT',
      entity: 'User',
      entityId: user.id?.toString(),
      details: 'User logged out',
    );
  }

  Future<void> logAction({
    required int? userId,
    required String action,
    required String entity,
    String? entityId,
    String? details,
  }) async {
    await db.insert('audit_logs', {
      'user_id': userId,
      'action': action,
      'entity': entity,
      'entity_id': entityId,
      'details': details,
      'created_at': DateTime.now().toIso8601String(),
    });
  }

  String _teachingHash(String value) {
    var hash = 0xcbf29ce484222325;
    for (final byte in value.codeUnits) {
      hash ^= byte;
      hash = (hash * 0x100000001b3) & 0xFFFFFFFFFFFFFFFF;
    }
    return hash.toRadixString(16).padLeft(16, '0');
  }
}

