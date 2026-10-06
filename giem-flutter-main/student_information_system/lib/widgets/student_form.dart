
import 'package:flutter/material.dart';
import '../models/course.dart';
import '../models/section.dart';
import '../models/student.dart';
import '../utils/constants.dart';
import '../utils/validators.dart';

class StudentForm extends StatefulWidget {
  final Student? initialStudent;
  final List<Course> courses;
  final List<Section> sections;
  final Future<void> Function(Student student) onSubmit;

  const StudentForm({
    super.key,
    this.initialStudent,
    required this.courses,
    required this.sections,
    required this.onSubmit,
  });

  @override
  State<StudentForm> createState() => _StudentFormState();
}

class _StudentFormState extends State<StudentForm> {
  final _formKey = GlobalKey<FormState>();
  final _studentId = TextEditingController();
  final _first = TextEditingController();
  final _middle = TextEditingController();
  final _last = TextEditingController();
  final _birth = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  final _address = TextEditingController();
  final _year = TextEditingController();

  String? _gender;
  String? _status;
  int? _courseId;
  int? _sectionId;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final s = widget.initialStudent;
    if (s != null) {
      _studentId.text = s.studentId;
      _first.text = s.firstName;
      _middle.text = s.middleName;
      _last.text = s.lastName;
      _birth.text = s.birthDate;
      _email.text = s.email;
      _phone.text = s.phone;
      _address.text = s.address;
      _year.text = s.yearLevel.toString();
      _gender = s.gender;
      _status = s.status;
      _courseId = s.courseId;
      _sectionId = s.sectionId;
    } else {
      _status = 'Active';
    }
  }

  @override
  void dispose() {
    for (final c in [
      _studentId, _first, _middle, _last, _birth, _email, _phone, _address, _year
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (_gender == null || _courseId == null || _sectionId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please complete all selections.')),
      );
      return;
    }

    setState(() => _saving = true);
    final now = DateTime.now().toIso8601String();
    final old = widget.initialStudent;

    final student = Student(
      id: old?.id,
      studentId: _studentId.text.trim(),
      firstName: _first.text.trim(),
      middleName: _middle.text.trim(),
      lastName: _last.text.trim(),
      gender: _gender!,
      birthDate: _birth.text.trim(),
      email: _email.text.trim(),
      phone: _phone.text.trim(),
      address: _address.text.trim(),
      courseId: _courseId!,
      yearLevel: int.parse(_year.text.trim()),
      sectionId: _sectionId!,
      status: _status ?? 'Active',
      dateEnrolled: old?.dateEnrolled ?? now.substring(0, 10),
      createdAt: old?.createdAt ?? now,
      updatedAt: now,
    );

    try {
      await widget.onSubmit(student);
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final editing = widget.initialStudent != null;

    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextFormField(
            controller: _studentId,
            decoration: const InputDecoration(labelText: 'Student ID'),
            validator: Validators.studentId,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _first,
            decoration: const InputDecoration(labelText: 'First Name'),
            validator: (v) => Validators.required(v, 'First name'),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _middle,
            decoration: const InputDecoration(labelText: 'Middle Name'),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _last,
            decoration: const InputDecoration(labelText: 'Last Name'),
            validator: (v) => Validators.required(v, 'Last name'),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            initialValue: _gender,
            decoration: const InputDecoration(labelText: 'Gender'),
            items: AppConstants.genders
                .map((x) => DropdownMenuItem(value: x, child: Text(x)))
                .toList(),
            onChanged: (v) => setState(() => _gender = v),
            validator: (v) => v == null ? 'Select gender.' : null,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _birth,
            decoration: const InputDecoration(
              labelText: 'Birth Date',
              hintText: 'YYYY-MM-DD',
            ),
            validator: (v) => Validators.required(v, 'Birth date'),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _email,
            decoration: const InputDecoration(labelText: 'Email'),
            keyboardType: TextInputType.emailAddress,
            validator: Validators.email,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _phone,
            decoration: const InputDecoration(labelText: 'Phone'),
            validator: (v) => Validators.required(v, 'Phone'),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _address,
            decoration: const InputDecoration(labelText: 'Address'),
            maxLines: 2,
            validator: (v) => Validators.required(v, 'Address'),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<int>(
            initialValue: _courseId,
            decoration: const InputDecoration(labelText: 'Course'),
            items: widget.courses
                .where((c) => c.id != null)
                .map((c) => DropdownMenuItem(
                      value: c.id,
                      child: Text('${c.code} - ${c.name}'),
                    ))
                .toList(),
            onChanged: (v) => setState(() => _courseId = v),
            validator: (v) => v == null ? 'Select course.' : null,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _year,
            decoration: const InputDecoration(labelText: 'Year Level'),
            keyboardType: TextInputType.number,
            validator: Validators.yearLevel,
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<int>(
            initialValue: _sectionId,
            decoration: const InputDecoration(labelText: 'Section'),
            items: widget.sections
                .where((s) => s.id != null)
                .map((s) => DropdownMenuItem(
                      value: s.id,
                      child: Text('${s.name} - Year ${s.yearLevel}'),
                    ))
                .toList(),
            onChanged: (v) => setState(() => _sectionId = v),
            validator: (v) => v == null ? 'Select section.' : null,
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            initialValue: _status,
            decoration: const InputDecoration(labelText: 'Status'),
            items: AppConstants.statuses
                .map((x) => DropdownMenuItem(value: x, child: Text(x)))
                .toList(),
            onChanged: (v) => setState(() => _status = v),
          ),
          const SizedBox(height: 20),
          FilledButton.icon(
            onPressed: _saving ? null : _save,
            icon: _saving
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.save),
            label: Text(_saving ? 'Saving...' : editing ? 'Update Student' : 'Save Student'),
          ),
        ],
      ),
    );
  }
}

