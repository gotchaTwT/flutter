
import '../database/database_helper.dart';
import '../models/section.dart';

class SectionRepository {
  final DatabaseHelper db;
  SectionRepository(this.db);

  Future<List<Section>> getAll() async {
    final rows = await db.query('sections', orderBy: 'year_level ASC, section_name ASC');
    return rows.map(Section.fromMap).toList();
  }

  Future<Section?> findById(int id) async {
    final rows = await db.query('sections', where: 'id = ?', whereArgs: [id]);
    return rows.isEmpty ? null : Section.fromMap(rows.first);
  }
}

