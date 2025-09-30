import 'package:flutter/material.dart';
import '../../data/mock_data.dart';
import '../widgets/app_scaffold.dart';

class CoursesPage extends StatelessWidget {
  const CoursesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final courses = MockData.courses;
    return AppScaffold(
      title: 'Courses',
      body: ListView.separated(
        itemCount: courses.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final c = courses[index];
          return Card(
            child: ListTile(
              title: Text(c.title),
              subtitle: Text('${c.subject} • ${c.level}'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {},
            ),
          );
        },
      ),
    );
  }
}
