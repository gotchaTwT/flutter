
import 'package:flutter/material.dart';
import 'database/database_helper.dart';
import 'repositories/user_repository.dart';
import 'services/auth_service.dart';
import 'screens/login_page.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final db = DatabaseHelper.instance;
  await db.database;

  final authService = AuthService(
    UserRepository(db),
    db,
  );

  runApp(StudentInformationSystem(authService: authService));
}

class StudentInformationSystem extends StatelessWidget {
  final AuthService authService;

  const StudentInformationSystem({
    super.key,
    required this.authService,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Student Information System',
      theme: AppTheme.light(),
      home: LoginPage(authService: authService),
    );
  }
}

