import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widgets/app_scaffold.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Home',
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth > 800;
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _Banner(),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: [
                    _ShortcutCard(
                      icon: Icons.quiz,
                      label: 'Practice',
                      onTap: () => context.go('/practice'),
                    ),
                    _ShortcutCard(
                      icon: Icons.assignment_turned_in,
                      label: 'Mock Test',
                      onTap: () => context.go('/mock-test'),
                    ),
                    _ShortcutCard(
                      icon: Icons.menu_book,
                      label: 'Courses',
                      onTap: () => context.go('/courses'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  'Suggested Courses',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                _CourseSuggestionsGrid(isWide: isWide),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _Banner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.primary.withOpacity(0.9),
              Theme.of(context).colorScheme.secondary.withOpacity(0.8),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Master IGCSE at your pace',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Structured courses, practice, and mock tests to excel.',
              style: TextStyle(color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }
}

class _ShortcutCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _ShortcutCard({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 180,
      child: Card(
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Icon(
                  icon,
                  size: 36,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(height: 8),
                Text(label),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CourseSuggestionsGrid extends StatelessWidget {
  final bool isWide;
  const _CourseSuggestionsGrid({required this.isWide});

  @override
  Widget build(BuildContext context) {
    final courses = _mockCourses.take(4).toList();
    final crossAxisCount = isWide ? 4 : 2;
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.2,
      ),
      itemCount: courses.length,
      itemBuilder: (context, index) {
        final c = courses[index];
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  c['title']!,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Chip(label: Text(c['subject']!)),
                    Text(c['level']!),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

final List<Map<String, String>> _mockCourses = [
  {'title': 'IGCSE Mathematics Foundation', 'subject': 'Math', 'level': 'Core'},
  {
    'title': 'IGCSE Physics Essentials',
    'subject': 'Physics',
    'level': 'Extended',
  },
  {
    'title': 'IGCSE Chemistry Concepts',
    'subject': 'Chemistry',
    'level': 'Core',
  },
  {'title': 'IGCSE Biology Mastery', 'subject': 'Biology', 'level': 'Extended'},
  {'title': 'IGCSE English Language', 'subject': 'English', 'level': 'Core'},
];
