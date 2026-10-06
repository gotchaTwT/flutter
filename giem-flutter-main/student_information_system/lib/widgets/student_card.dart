
import 'package:flutter/material.dart';
import '../models/student.dart';

class StudentCard extends StatelessWidget {
  final Student student;
  final VoidCallback onView;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const StudentCard({
    super.key,
    required this.student,
    required this.onView,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          child: Text(
            student.firstName.isEmpty ? '?' : student.firstName[0].toUpperCase(),
          ),
        ),
        title: Text(student.fullName),
        subtitle: Text('${student.studentId} • Year ${student.yearLevel}'),
        onTap: onView,
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'view') onView();
            if (value == 'edit' && onEdit != null) onEdit!();
            if (value == 'delete' && onDelete != null) onDelete!();
          },
          itemBuilder: (_) => [
            const PopupMenuItem(value: 'view', child: Text('View')),
            if (onEdit != null)
              const PopupMenuItem(value: 'edit', child: Text('Edit')),
            if (onDelete != null)
              const PopupMenuItem(value: 'delete', child: Text('Delete')),
          ],
        ),
      ),
    );
  }
}

