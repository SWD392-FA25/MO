import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import '../../../../catalog/domain/entities/course_lesson.dart';
import '../../../../catalog/presentation/providers/course_provider.dart';
import '../../../../../theme/design_tokens.dart';

class CourseCurriculumPage extends StatefulWidget {
  const CourseCurriculumPage({super.key, required this.courseId});

  final String courseId;

  @override
  State<CourseCurriculumPage> createState() => _CourseCurriculumPageState();
}

class _CourseCurriculumPageState extends State<CourseCurriculumPage> {
  @override
  void initState() {
    super.initState();
    // Load lessons when page initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CourseProvider>().loadCourseLessons(widget.courseId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Curriculum'),
        actions: [
          IconButton(
            onPressed: () {
              context.read<CourseProvider>().loadCourseLessons(widget.courseId);
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Consumer<CourseProvider>(
        builder: (context, provider, child) {
          if (provider.isLessonsLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (provider.lessonsErrorMessage != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 64,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    provider.lessonsErrorMessage!,
                    style: const TextStyle(color: AppColors.textSecondary),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      provider.clearLessonsError();
                      provider.loadCourseLessons(widget.courseId);
                    },
                    child: const Text('Thử lại'),
                  ),
                ],
              ),
            );
          }

          final lessons = provider.courseLessons;
          
          if (lessons.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.video_library_outlined,
                    size: 64,
                    color: AppColors.textSecondary,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Chưa có bài học nào',
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              await provider.loadCourseLessons(widget.courseId);
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: lessons.length,
              itemBuilder: (context, index) {
                final lesson = lessons[index];
                return _LessonCard(lesson: lesson, courseId: widget.courseId);
              },
            ),
          );
        },
      ),
    );
  }
}

class _LessonCard extends StatelessWidget {
  const _LessonCard({required this.lesson, required this.courseId});

  final CourseLesson lesson;
  final String courseId;

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(bottom: 16),
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
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: lesson.contentType == 'video'
                      ? AppColors.primary.withAlpha(24)
                      : AppColors.accent.withAlpha(24),
                ),
                child: Icon(
                  lesson.contentType == 'video'
                      ? Icons.play_circle_filled
                      : Icons.article,
                  color: lesson.contentType == 'video'
                      ? AppColors.primary
                      : AppColors.accent,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        // We'll implement navigation later - for now just log
                        print('Navigate to lesson: ${lesson.id}');
                      },
                      child: Text(
                        lesson.title,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (lesson.description != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        lesson.description!,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
              if (lesson.isFree)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green.withAlpha(24),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Free',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Colors.green,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
          if (lesson.durationMinutes != null) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(
                  Icons.schedule,
                  size: 16,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(width: 4),
                Text(
                  '${lesson.durationMinutes} phút',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(width: 16),
                if (lesson.isCompleted) ...[
                  Icon(
                    Icons.check_circle,
                    size: 16,
                    color: Colors.green,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Đã hoàn thành',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.green,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ],
      ),
    );
  }
}
