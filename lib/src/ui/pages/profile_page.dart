import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/mock_data.dart';
import '../../state/app_state.dart';
import '../widgets/app_scaffold.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final profile = MockData.profile;
    final name = context.watch<AppState>().displayName;
    return AppScaffold(
      title: 'Profile',
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 28,
                child: Icon(Icons.person, size: 28),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: Theme.of(context).textTheme.titleMedium),
                  Text('Membership: ${profile.membership}'),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Card(
            child: ListTile(
              leading: const Icon(Icons.timeline),
              title: const Text('Learning Progress'),
              subtitle: Text('Enrolled Courses: ${profile.enrolledCourses}'),
              trailing: ElevatedButton(
                onPressed: () {},
                child: const Text('Edit'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
