
import '../database/database_helper.dart';
import '../models/app_user.dart';

class UserRepository {
  final DatabaseHelper db;
  UserRepository(this.db);

  Future<AppUser?> findByUsername(String username) async {
    final rows = await db.query(
      'users',
      where: 'username = ?',
      whereArgs: [username],
    );
    return rows.isEmpty ? null : AppUser.fromMap(rows.first);
  }
}

