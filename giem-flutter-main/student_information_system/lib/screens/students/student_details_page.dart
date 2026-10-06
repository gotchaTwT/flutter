
import 'package:flutter/material.dart';
import '../../models/student.dart';

class StudentDetailsPage extends StatelessWidget {
  final Student student;

  const StudentDetailsPage({super.key, required this.student});

  Widget _item(String label, String value) {
    return ListTile(
      title: Text(label),
      subtitle: Text(value.isEmpty ? '-' : value),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Student Details')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Center(
            child: CircleAvatar(
              radius: 42,
              child: Text(
                student.firstName.isEmpty ? '?' : student.firstName[0].toUpperCase(),
                style: const TextStyle(fontSize: 28),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Center(
            child: Text(
              student.fullName,
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Column(
              children: [
                _item('Student ID', student.studentId),
                _item('Gender', student.gender),
                _item('Birth Date', student.birthDate),
                _item('Email', student.email),
                _item('Phone', student.phone),
                _item('Address', student.address),
                _item('Year Level', '${student.yearLevel}'),
                _item('Status', student.status),
                _item('Enrollment Date', student.dateEnrolled),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

