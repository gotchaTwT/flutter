
import 'package:flutter/material.dart';
import '../../models/app_user.dart';
import '../../models/student.dart';
import '../../services/student_service.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/error_state.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/student_card.dart';
import 'add_student_page.dart';
import 'edit_student_page.dart';
import 'student_details_page.dart';

enum ViewState { loading, success, empty, error }

class StudentListPage extends StatefulWidget {
  final AppUser user;
  final StudentService studentService;

  const StudentListPage({
    super.key,
    required this.user,
    required this.studentService,
  });

  @override
  State<StudentListPage> createState() => _StudentListPageState();
}

class _StudentListPageState extends State<StudentListPage> {
  ViewState _state = ViewState.loading;
  List<Student> _students = [];
  String _query = '';
  String _status = 'All';
  String _sort = 'Name';

  @override
  void initState() {
    super.initState();
    _loadStudents();
  }

  Future<void> _loadStudents() async {
    setState(() => _state = ViewState.loading);
    try {
      _students = await widget.studentService.getStudents(widget.user);
      if (!mounted) return;
      setState(() {
        _state = _students.isEmpty ? ViewState.empty : ViewState.success;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _state = ViewState.error);
    }
  }

  List<Student> get _filtered {
    final q = _query.toLowerCase().trim();
    final list = _students.where((s) {
      final matchesQuery = q.isEmpty ||
          s.studentId.toLowerCase().contains(q) ||
          s.fullName.toLowerCase().contains(q) ||
          s.email.toLowerCase().contains(q);

      final matchesStatus = _status == 'All' || s.status == _status;
      return matchesQuery && matchesStatus;
    }).toList();

    if (_sort == 'Name') {
      list.sort((a, b) => a.fullName.compareTo(b.fullName));
    } else if (_sort == 'Student ID') {
      list.sort((a, b) => a.studentId.compareTo(b.studentId));
    } else if (_sort == 'Year') {
      list.sort((a, b) => a.yearLevel.compareTo(b.yearLevel));
    }

    return list;
  }

  Future<void> _add() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AddStudentPage(
          user: widget.user,
          studentService: widget.studentService,
        ),
      ),
    );
    if (result == true) _loadStudents();
  }

  Future<void> _edit(Student student) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EditStudentPage(
          user: widget.user,
          studentService: widget.studentService,
          student: student,
        ),
      ),
    );
    if (result == true) _loadStudents();
  }

  Future<void> _delete(Student student) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete student?'),
        content: Text(
          'Delete ${student.fullName}? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      await widget.studentService.deleteStudent(student, widget.user);
      await _loadStudents();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Student deleted successfully.')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final canManage = widget.studentService.canManage(widget.user);
    final visible = _filtered;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Students'),
        actions: [
          IconButton(onPressed: _loadStudents, icon: const Icon(Icons.refresh)),
        ],
      ),
      floatingActionButton: canManage
          ? FloatingActionButton.extended(
              onPressed: _add,
              icon: const Icon(Icons.add),
              label: const Text('Add Student'),
            )
          : null,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Search',
                hintText: 'Student ID, name or email',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (v) => setState(() => _query = v),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    initialValue: _status,
                    decoration: const InputDecoration(labelText: 'Status'),
                    items: const [
                      DropdownMenuItem(value: 'All', child: Text('All')),
                      DropdownMenuItem(value: 'Active', child: Text('Active')),
                      DropdownMenuItem(value: 'Inactive', child: Text('Inactive')),
                      DropdownMenuItem(value: 'Graduated', child: Text('Graduated')),
                      DropdownMenuItem(value: 'Dropped', child: Text('Dropped')),
                    ],
                    onChanged: (v) => setState(() => _status = v ?? 'All'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    initialValue: _sort,
                    decoration: const InputDecoration(labelText: 'Sort'),
                    items: const [
                      DropdownMenuItem(value: 'Name', child: Text('Name')),
                      DropdownMenuItem(value: 'Student ID', child: Text('Student ID')),
                      DropdownMenuItem(value: 'Year', child: Text('Year')),
                    ],
                    onChanged: (v) => setState(() => _sort = v ?? 'Name'),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: switch (_state) {
              ViewState.loading => const LoadingWidget(),
              ViewState.error => ErrorState(
                  message: 'Unable to load students.',
                  onRetry: _loadStudents,
                ),
              ViewState.empty => const EmptyState(message: 'No students found.'),
              ViewState.success => visible.isEmpty
                  ? const EmptyState(message: 'No students match your search.')
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
                      itemCount: visible.length,
                      itemBuilder: (_, index) {
                        final student = visible[index];
                        return StudentCard(
                          student: student,
                          onView: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => StudentDetailsPage(student: student),
                            ),
                          ),
                          onEdit: canManage ? () => _edit(student) : null,
                          onDelete: canManage ? () => _delete(student) : null,
                        );
                      },
                    ),
            },
          ),
        ],
      ),
    );
  }
}

