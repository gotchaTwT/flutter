
import '../database/database_helper.dart';
import '../models/course.dart';

class CourseRepository {
  final DatabaseHelper db;
  CourseRepository(this.db);

  Future<List<Course>> getAll() async {
    final rows = await db.query('courses', orderBy: 'course_code ASC');
    return rows.map(Course.fromMap).toList();
  }

  Future<Course?> findById(int id) async {
    final rows = await db.query('courses', where: 'id = ?', whereArgs: [id]);
    return rows.isEmpty ? null : Course.fromMap(rows.first);
  }
}

