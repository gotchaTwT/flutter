
import 'package:sqflite/sqflite.dart';
import '../models/app_user.dart';
import '../models/student.dart';
import '../repositories/student_repository.dart';
import 'auth_service.dart';

class StudentService {
  final StudentRepository repository;
  final AuthService auth;

  StudentService(this.repository, this.auth);

  bool canView(AppUser user) => user.role == 'admin' || user.role == 'faculty';
  bool canManage(AppUser user) => user.role == 'admin';
  bool canDelete(AppUser user) => user.role == 'admin';

  Future<List<Student>> getStudents(AppUser user) {
    if (!canView(user)) {
      throw Exception('You do not have permission to view students.');
    }
    return repository.getAll();
  }

  Future<void> createStudent(Student student, AppUser user) async {
    if (!canManage(user)) {
      throw Exception('Only administrators can add students.');
    }
    try {
      await repository.insert(student);
      await auth.logAction(
        userId: user.id,
        action: 'CREATE',
        entity: 'Student',
        entityId: student.studentId,
        details: 'Student record created',
      );
    } on DatabaseException catch (e) {
      if (e.toString().contains('UNIQUE')) {
        throw Exception('Student ID already exists.');
      }
      rethrow;
    }
  }

  Future<void> updateStudent(Student student, AppUser user) async {
    if (!canManage(user)) {
      throw Exception('Only administrators can edit students.');
    }
    try {
      await repository.update(student);
      await auth.logAction(
        userId: user.id,
        action: 'UPDATE',
        entity: 'Student',
        entityId: student.studentId,
        details: 'Student record updated',
      );
    } on DatabaseException catch (e) {
      if (e.toString().contains('UNIQUE')) {
        throw Exception('Student ID already exists.');
      }
      rethrow;
    }
  }

  Future<void> deleteStudent(Student student, AppUser user) async {
    if (!canDelete(user)) {
      throw Exception('Only administrators can delete students.');
    }
    if (student.id == null) throw Exception('Student ID is missing.');

    await repository.delete(student.id!);
    await auth.logAction(
      userId: user.id,
      action: 'DELETE',
      entity: 'Student',
      entityId: student.studentId,
      details: 'Student record deleted',
    );
  }
}

