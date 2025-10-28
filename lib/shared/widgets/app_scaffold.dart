import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../src/state/app_state.dart';

class AppScaffold extends StatelessWidget {
  final String title;
  final Widget body;
  final List<Widget>? actions;

  const AppScaffold({
    super.key,
    required this.title,
    required this.body,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(Icons.school, size: 24),
            const SizedBox(width: 8),
            Text(title),
          ],
        ),
        actions: actions,
      ),
      drawer: const _AppDrawer(),
      body: SafeArea(
        child: Padding(padding: const EdgeInsets.all(16.0), child: body),
      ),
    );
  }
}

class _AppDrawer extends StatelessWidget {
  const _AppDrawer();

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(appState.displayName ?? 'Guest'),
            accountEmail: const Text('learner@igcse.app'),
            currentAccountPicture: const CircleAvatar(
              child: Icon(Icons.person),
            ),
          ),
          _navItem(context, Icons.home, 'Home', () => context.go('/')),
          _navItem(
            context,
            Icons.menu_book,
            'Courses',
            () => context.go('/courses'),
          ),
          _navItem(
            context,
            Icons.quiz,
            'Practice',
            () => context.go('/practice'),
          ),
          _navItem(
            context,
            Icons.assignment_turned_in,
            'Mock Test',
            () => context.go('/mock-test'),
          ),
          _navItem(
            context,
            Icons.workspace_premium,
            'Membership',
            () => context.go('/membership'),
          ),
          _navItem(
            context,
            Icons.person,
            'Profile',
            () => context.go('/profile'),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () {
              context.read<AppState>().logout();
              context.go('/login');
            },
          ),
        ],
      ),
    );
  }

  Widget _navItem(
    BuildContext context,
    IconData icon,
    String label,
    VoidCallback onTap,
  ) {
    return ListTile(
      leading: Icon(icon),
      title: Text(label),
      onTap: () {
        Navigator.of(context).pop();
        onTap();
      },
    );
  }
}
