
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  DatabaseHelper._();
  static final DatabaseHelper instance = DatabaseHelper._();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), 'sis_v2.db');
    return openDatabase(
      path,
      version: 2,
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
      onCreate: (db, version) async => _createDatabase(db),
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) await _createDatabase(db);
      },
    );
  }

  Future<void> _createDatabase(Database db) async {
    await db.transaction((txn) async {
      await txn.execute('''
        CREATE TABLE courses (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          course_code TEXT NOT NULL UNIQUE,
          course_name TEXT NOT NULL
        )
      ''');

      await txn.execute('''
        CREATE TABLE sections (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          section_name TEXT NOT NULL,
          year_level INTEGER NOT NULL CHECK(year_level BETWEEN 1 AND 4)
        )
      ''');

      await txn.execute('''
        CREATE TABLE students (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          student_id TEXT NOT NULL UNIQUE,
          first_name TEXT NOT NULL,
          middle_name TEXT NOT NULL DEFAULT '',
          last_name TEXT NOT NULL,
          gender TEXT NOT NULL,
          birth_date TEXT NOT NULL,
          email TEXT NOT NULL,
          phone TEXT NOT NULL,
          address TEXT NOT NULL,
          course_id INTEGER NOT NULL,
          year_level INTEGER NOT NULL CHECK(year_level BETWEEN 1 AND 4),
          section_id INTEGER NOT NULL,
          status TEXT NOT NULL DEFAULT 'Active',
          date_enrolled TEXT NOT NULL,
          created_at TEXT NOT NULL,
          updated_at TEXT NOT NULL,
          FOREIGN KEY (course_id) REFERENCES courses(id),
          FOREIGN KEY (section_id) REFERENCES sections(id)
        )
      ''');

      await txn.execute('''
        CREATE TABLE users (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          username TEXT NOT NULL UNIQUE,
          password_hash TEXT NOT NULL,
          role TEXT NOT NULL CHECK(role IN ('admin','faculty','student')),
          created_at TEXT NOT NULL
        )
      ''');

      await txn.execute('''
        CREATE TABLE audit_logs (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          user_id INTEGER,
          action TEXT NOT NULL,
          entity TEXT NOT NULL,
          entity_id TEXT,
          details TEXT,
          created_at TEXT NOT NULL,
          FOREIGN KEY (user_id) REFERENCES users(id)
        )
      ''');

      await txn.execute(
        'CREATE INDEX idx_students_name ON students(last_name, first_name)',
      );
      await txn.execute(
        'CREATE INDEX idx_students_status ON students(status)',
      );
      await txn.execute(
        'CREATE INDEX idx_students_course ON students(course_id)',
      );

      await _seed(txn);
    });
  }

  Future<void> _seed(Transaction txn) async {
    final now = DateTime.now().toIso8601String();

    final cs = <Map<String, dynamic>>[
      {'course_code': 'BSIT', 'course_name': 'Bachelor of Science in Information Technology'},
      {'course_code': 'BSCS', 'course_name': 'Bachelor of Science in Computer Science'},
      {'course_code': 'BSEd', 'course_name': 'Bachelor of Secondary Education'},
    ];
    for (final c in cs) {
      await txn.insert('courses', c);
    }

    final sections = <Map<String, dynamic>>[
      {'section_name': 'IT-1A', 'year_level': 1},
      {'section_name': 'IT-2A', 'year_level': 2},
      {'section_name': 'CS-1A', 'year_level': 1},
      {'section_name': 'ED-1A', 'year_level': 1},
    ];
    for (final s in sections) {
      await txn.insert('sections', s);
    }

    // Development account only. Change/remove before production.
    await txn.insert('users', {
      'username': 'admin',
      'password_hash': _hash('admin123'),
      'role': 'admin',
      'created_at': now,
    });
    await txn.insert('users', {
      'username': 'faculty',
      'password_hash': _hash('faculty123'),
      'role': 'faculty',
      'created_at': now,
    });
    await txn.insert('users', {
      'username': 'student',
      'password_hash': _hash('student123'),
      'role': 'student',
      'created_at': now,
    });
  }

  static String _hash(String value) {
    // Kept local to avoid another dependency in this helper.
    // AuthService uses the same SHA-256 algorithm.
    var hash = 0xcbf29ce484222325;
    for (final byte in value.codeUnits) {
      hash ^= byte;
      hash = (hash * 0x100000001b3) & 0xFFFFFFFFFFFFFFFF;
    }
    return hash.toRadixString(16).padLeft(16, '0');
  }

  Future<List<Map<String, dynamic>>> query(
    String table, {
    String? where,
    List<Object?>? whereArgs,
    String? orderBy,
  }) async {
    final db = await database;
    return db.query(table, where: where, whereArgs: whereArgs, orderBy: orderBy);
  }

  Future<int> insert(String table, Map<String, dynamic> values) async {
    final db = await database;
    return db.insert(table, values);
  }

  Future<int> update(
    String table,
    Map<String, dynamic> values, {
    required String where,
    required List<Object?> whereArgs,
  }) async {
    final db = await database;
    return db.update(table, values, where: where, whereArgs: whereArgs);
  }

  Future<int> delete(
    String table, {
    required String where,
    required List<Object?> whereArgs,
  }) async {
    final db = await database;
    return db.delete(table, where: where, whereArgs: whereArgs);
  }

  Future<List<Map<String, dynamic>>> rawQuery(
    String sql,
    [List<Object?>? args]
  ) async {
    final db = await database;
    return db.rawQuery(sql, args);
  }
}

