
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:student_information_system/database/database_helper.dart';
import 'package:student_information_system/repositories/user_repository.dart';
import 'package:student_information_system/services/auth_service.dart';
import 'package:student_information_system/screens/login_page.dart';

void main() {
  testWidgets('login button is visible', (tester) async {
    final db = DatabaseHelper.instance;
    await db.database;
    final auth = AuthService(UserRepository(db), db);

    await tester.pumpWidget(
      MaterialApp(
        home: LoginPage(authService: auth),
      ),
    );

    expect(find.text('Login'), findsOneWidget);
  });
}

