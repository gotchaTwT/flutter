
import '../database/database_helper.dart';
import '../models/student.dart';

class StudentRepository {
  final DatabaseHelper db;
  StudentRepository(this.db);

  Future<List<Student>> getAll() async {
    final rows = await db.rawQuery('''
      SELECT s.*
      FROM students s
      ORDER BY s.last_name ASC, s.first_name ASC
    ''');
    return rows.map(Student.fromMap).toList();
  }

  Future<Student?> findById(int id) async {
    final rows = await db.query('students', where: 'id = ?', whereArgs: [id]);
    return rows.isEmpty ? null : Student.fromMap(rows.first);
  }

  Future<Student?> findByStudentId(String studentId) async {
    final rows = await db.query(
      'students',
      where: 'student_id = ?',
      whereArgs: [studentId],
    );
    return rows.isEmpty ? null : Student.fromMap(rows.first);
  }

  Future<int> insert(Student student) => db.insert('students', student.toMap());

  Future<int> update(Student student) async {
    if (student.id == null) throw Exception('Student ID is missing.');
    return db.update(
      'students',
      student.toMap()..remove('id'),
      where: 'id = ?',
      whereArgs: [student.id],
    );
  }

  Future<int> delete(int id) => db.delete(
        'students',
        where: 'id = ?',
        whereArgs: [id],
      );

  Future<int> count() async {
    final rows = await db.rawQuery('SELECT COUNT(*) AS total FROM students');
    return (rows.first['total'] as int?) ?? 0;
  }

  Future<int> countByStatus(String status) async {
    final rows = await db.rawQuery(
      'SELECT COUNT(*) AS total FROM students WHERE status = ?',
      [status],
    );
    return (rows.first['total'] as int?) ?? 0;
  }
}

