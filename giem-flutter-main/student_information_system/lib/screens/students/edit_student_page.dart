import 'package:flutter/material.dart';
import '../../database/database_helper.dart';
import '../../models/app_user.dart';
import '../../models/course.dart';
import '../../models/section.dart';
import '../../models/student.dart';
import '../../repositories/course_repository.dart';
import '../../repositories/section_repository.dart';
import '../../services/student_service.dart';
import '../../widgets/student_form.dart';

class EditStudentPage extends StatefulWidget {
  final AppUser user;
  final StudentService studentService;
  final Student student;

  const EditStudentPage({
    super.key,
    required this.user,
    required this.studentService,
    required this.student,
  });

  @override
  State<EditStudentPage> createState() => _EditStudentPageState();
}

class _EditStudentPageState extends State<EditStudentPage> {
  List<Course> _courses = [];
  List<Section> _sections = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadOptions();
  }

  Future<void> _loadOptions() async {
    try {
      _courses = await CourseRepository(DatabaseHelper.instance).getAll();
      _sections = await SectionRepository(DatabaseHelper.instance).getAll();
    } catch (e) {
      _error = e.toString();
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Student')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text(_error!))
              : StudentForm(
                  initialStudent: widget.student,
                  courses: _courses,
                  sections: _sections,
                  onSubmit: (student) =>
                      widget.studentService.updateStudent(student, widget.user),
                ),
    );
  }
}

