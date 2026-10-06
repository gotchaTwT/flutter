
import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/app_user.dart';
import '../repositories/student_repository.dart';
import '../services/auth_service.dart';
import '../services/student_service.dart';
import 'login_page.dart';
import 'profile_page.dart';
import 'students/student_list_page.dart';

class DashboardPage extends StatefulWidget {
  final AppUser user;
  final AuthService authService;

  const DashboardPage({
    super.key,
    required this.user,
    required this.authService,
  });

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late final StudentRepository _studentRepo;
  late final StudentService _studentService;

  int _total = 0;
  int _active = 0;
  int _inactive = 0;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _studentRepo = StudentRepository(DatabaseHelper.instance);
    _studentService = StudentService(_studentRepo, widget.authService);
    _loadStats();
  }

  Future<void> _loadStats() async {
    if (!widget.user.isAdmin && !widget.user.isFaculty) {
      setState(() => _loading = false);
      return;
    }
    try {
      _total = await _studentRepo.count();
      _active = await _studentRepo.countByStatus('Active');
      _inactive = await _studentRepo.countByStatus('Inactive');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _logout() async {
    await widget.authService.logout(widget.user);
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => LoginPage(authService: widget.authService),
      ),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final canView = widget.user.isAdmin || widget.user.isFaculty;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            tooltip: 'Profile',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ProfilePage(
                  user: widget.user,
                  authService: widget.authService,
                ),
              ),
            ),
            icon: const Icon(Icons.person),
          ),
          IconButton(
            tooltip: 'Logout',
            onPressed: _logout,
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadStats,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              'Welcome, ${widget.user.username}',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 4),
            Text('Role: ${widget.user.role.toUpperCase()}'),
            const SizedBox(height: 20),
            if (!canView)
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    'Student role is limited in this local SIS 2.0 demonstration.',
                  ),
                ),
              )
            else ...[
              if (_loading)
                const LinearProgressIndicator()
              else
                Row(
                  children: [
                    Expanded(child: _StatCard('Total', _total, Icons.people)),
                    const SizedBox(width: 10),
                    Expanded(child: _StatCard('Active', _active, Icons.check_circle)),
                    const SizedBox(width: 10),
                    Expanded(child: _StatCard('Inactive', _inactive, Icons.pause_circle)),
                  ],
                ),
              const SizedBox(height: 20),
              Card(
                child: ListTile(
                  leading: const Icon(Icons.people_alt),
                  title: const Text('Student Management'),
                  subtitle: const Text('Search, filter, sort, view and manage students'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => StudentListPage(
                        user: widget.user,
                        studentService: _studentService,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final int value;
  final IconData icon;

  const _StatCard(this.label, this.value, this.icon);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            Icon(icon),
            const SizedBox(height: 8),
            Text(
              '$value',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            Text(label),
          ],
        ),
      ),
    );
  }
}

