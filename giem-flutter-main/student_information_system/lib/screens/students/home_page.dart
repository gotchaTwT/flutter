import 'package:flutter/material.dart';
import '../../database/database_helper.dart';
import '../../models/app_user.dart';
import '../../models/course.dart';
import '../../models/section.dart';
import '../../repositories/course_repository.dart';
import '../../repositories/section_repository.dart';
import '../../services/student_service.dart';
import '../../widgets/student_form.dart';

Future<void> loadStudent() async {
  try {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    // Load student data here

  } catch (e) {
    setState(() {
      errorMessage = e.toString();
    });
  } finally {
    setState(() {
      isLoading = false;
    });
  }
}