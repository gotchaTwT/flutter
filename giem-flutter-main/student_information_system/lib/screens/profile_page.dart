
import 'package:flutter/material.dart';
import '../models/app_user.dart';
import '../services/auth_service.dart';

class ProfilePage extends StatelessWidget {
  final AppUser user;
  final AuthService authService;

  const ProfilePage({
    super.key,
    required this.user,
    required this.authService,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const CircleAvatar(
            radius: 42,
            child: Icon(Icons.person, size: 42),
          ),
          const SizedBox(height: 20),
          ListTile(
            title: const Text('Username'),
            subtitle: Text(user.username),
          ),
          ListTile(
            title: const Text('Role'),
            subtitle: Text(user.role.toUpperCase()),
          ),
          ListTile(
            title: const Text('User ID'),
            subtitle: Text('${user.id ?? '-'}'),
          ),
        ],
      ),
    );
  }
}

