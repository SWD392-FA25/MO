import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:igcse_learning_hub/src/data/mock_data.dart';
import 'package:igcse_learning_hub/src/models/course.dart';
import 'package:igcse_learning_hub/src/theme/design_tokens.dart';

class MyCourseLessonsPage extends StatelessWidget {
  const MyCourseLessonsPage({
    super.key,
    required this.courseId,
    required this.isCompleted,
  });

  final String courseId;
  final bool isCompleted;

  @override
  Widget build(BuildContext context) {
    final Course course =
        mockCourses.firstWhere((c) => c.id == courseId, orElse: () => mockCourses.first);
    final textTheme = Theme.of(context).textTheme;
    final lessons = _mockLessons;
    final title = isCompleted ? 'Bài học đã hoàn thành' : 'Bài học đang học';
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(title),
        actions: [
          if (!isCompleted)
            TextButton(
              onPressed: () => context.push('/quiz/detail'),
              child: const Text('Làm quiz'),
            ),
        ],
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(20),
        itemBuilder: (context, index) {
          final lesson = lessons[index];
          final status = isCompleted || index < 2
              ? LessonStatus.completed
              : index == 2
                  ? LessonStatus.inProgress
                  : LessonStatus.locked;
          return Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: const [
                BoxShadow(
                  color: AppColors.cardShadow,
                  blurRadius: 18,
                  offset: Offset(0, 12),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _StatusIcon(status: status),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Lesson ${index + 1}',
                            style: textTheme.bodySmall?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            lesson,
                            style: textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (!isCompleted && status != LessonStatus.locked)
                      IconButton(
                        onPressed: () => context.push('/my-courses/$courseId/video'),
                        icon: const Icon(Icons.play_circle_fill_rounded),
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  'Thời lượng: 15 phút • Tài liệu PDF và quiz cuối bài',
                  style: textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          );
        },
        separatorBuilder: (_, __) => const SizedBox(height: 16),
        itemCount: lessons.length,
      ),
      bottomNavigationBar: !isCompleted
          ? Padding(
              padding: const EdgeInsets.all(20),
              child: ElevatedButton(
                onPressed: () => context.push('/quiz'),
                child: Text('Ôn luyện quiz cho ${course.title}'),
              ),
            )
          : null,
    );
  }
}

class MyCourseVideoPage extends StatelessWidget {
  const MyCourseVideoPage({super.key, required this.courseId});

  final String courseId;

  @override
  Widget build(BuildContext context) {
    final Course course =
        mockCourses.firstWhere((c) => c.id == courseId, orElse: () => mockCourses.first);
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(course.title),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.settings_outlined),
          ),
        ],
      ),
      body: Stack(
        children: [
          Center(
            child: Container(
              width: double.infinity,
              margin: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(16),
              ),
              // TODO: Thay bằng video player thực tế theo thiết kế Figma.
              child: const Icon(
                Icons.play_circle_fill,
                size: 96,
                color: Colors.white,
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Advanced Composition Rules',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 12),
                  const LinearProgressIndicator(
                    value: 0.6,
                    backgroundColor: Color(0xFF2D2D2D),
                    valueColor: AlwaysStoppedAnimation(AppColors.primary),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      TextButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.picture_as_pdf_outlined),
                        label: const Text('Tài liệu PDF'),
                      ),
                      const Spacer(),
                      ElevatedButton(
                        onPressed: () => context.push('/my-courses/$courseId/completed'),
                        child: const Text('Đánh dấu hoàn thành'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CourseCompletionPage extends StatelessWidget {
  const CourseCompletionPage({super.key, required this.courseId});

  final String courseId;

  @override
  Widget build(BuildContext context) {
    final Course course =
        mockCourses.firstWhere((c) => c.id == courseId, orElse: () => mockCourses.first);
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary.withAlpha(36),
                ),
                child: const Icon(
                  Icons.emoji_events_rounded,
                  size: 64,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Chúc mừng bạn đã hoàn thành!',
                style: textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                'Bạn đã hoàn thành toàn bộ khoá học ${course.title}. Tiếp tục luyện tập với quiz để giữ phong độ nhé.',
                style: textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () => context.push('/quiz/detail'),
                icon: const Icon(Icons.quiz),
                label: const Text('Bắt đầu Quiz tổng ôn'),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => context.go('/dashboard'),
                child: const Text('Quay lại bảng điều khiển'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusIcon extends StatelessWidget {
  const _StatusIcon({required this.status});

  final LessonStatus status;

  @override
  Widget build(BuildContext context) {
    switch (status) {
      case LessonStatus.completed:
        return const Icon(Icons.check_circle_rounded, color: AppColors.primary);
      case LessonStatus.inProgress:
        return const Icon(Icons.play_circle_fill_rounded, color: AppColors.accent);
      case LessonStatus.locked:
        return const Icon(Icons.lock_outline_rounded, color: AppColors.textSecondary);
    }
  }
}

enum LessonStatus { completed, inProgress, locked }

const List<String> _mockLessons = [
  'Brand Positioning Fundamentals',
  'Color Psychology for Designers',
  'Advanced Composition Rules',
  'Typography Pairing in Branding',
  'Creative Direction Workshop',
  'Capstone Presentation',
];
