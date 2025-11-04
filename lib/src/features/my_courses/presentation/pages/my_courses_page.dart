import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:igcse_learning_hub/src/data/mock_data.dart';
import 'package:igcse_learning_hub/src/models/course.dart';
import 'package:igcse_learning_hub/src/theme/design_tokens.dart';

class MyCoursesPage extends StatelessWidget {
  const MyCoursesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ongoing = mockCourses.take(3).toList();
    final completed = mockCourses.reversed.toList();
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: const Text('My Courses'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Đang học'),
              Tab(text: 'Hoàn thành'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _MyCourseList(
              courses: ongoing,
              onTap: (course) => context.push('/my-courses/ongoing/${course.id}'),
              progressBuilder: (course) => const LinearProgressIndicator(
                value: 0.45,
                minHeight: 6,
                backgroundColor: Color(0xFFE8E7FF),
                valueColor: AlwaysStoppedAnimation(AppColors.primary),
              ),
            ),
            _MyCourseList(
              courses: completed,
              onTap: (course) =>
                  context.push('/my-courses/completed/${course.id}'),
              actionBuilder: (course) => OutlinedButton.icon(
                onPressed: () => context.push('/quiz'),
                icon: const Icon(Icons.quiz),
                label: const Text('Làm quiz'),
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => context.push('/quiz'),
          label: const Text('Vào phòng Quiz'),
          icon: const Icon(Icons.quiz),
        ),
      ),
    );
  }
}

class _MyCourseList extends StatelessWidget {
  const _MyCourseList({
    required this.courses,
    required this.onTap,
    this.progressBuilder,
    this.actionBuilder,
  });

  final List<Course> courses;
  final ValueChanged<Course> onTap;
  final Widget Function(Course course)? progressBuilder;
  final Widget Function(Course course)? actionBuilder;

  @override
  Widget build(BuildContext context) {
    if (courses.isEmpty) {
      return const Center(child: Text('Chưa có khóa học nào ở danh mục này.'));
    }
    final textTheme = Theme.of(context).textTheme;
    return ListView.separated(
      padding: const EdgeInsets.all(20),
      itemCount: courses.length,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final course = courses[index];
        return InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: () => onTap(course),
          child: Ink(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: const [
                BoxShadow(
                  color: AppColors.cardShadow,
                  offset: Offset(0, 10),
                  blurRadius: 24,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        color: AppColors.primary.withAlpha(20),
                      ),
                      // TODO: Thay bằng thumbnail khoá học từ Figma khi có asset.
                      child: const Icon(
                        Icons.play_circle_fill_rounded,
                        color: AppColors.primary,
                        size: 32,
                      ),
                    ),
                    const SizedBox(width: 18),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            course.title,
                            style: textTheme.titleMedium,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            '24 bài học • 12 giờ học',
                            style: textTheme.bodySmall?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                if (progressBuilder != null) progressBuilder!(course),
                if (actionBuilder != null) ...[
                  const SizedBox(height: 12),
                  actionBuilder!(course),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}
