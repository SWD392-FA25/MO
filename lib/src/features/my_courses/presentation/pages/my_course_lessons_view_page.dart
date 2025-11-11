import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../catalog/domain/entities/lesson.dart';
import '../providers/my_course_provider.dart';
import '../../domain/entities/course_progress.dart';
import '../../../../theme/design_tokens.dart';

class MyCourseLessonsViewPage extends StatefulWidget {
  const MyCourseLessonsViewPage({
    super.key,
    required this.courseId,
  });

  final String courseId;

  @override
  State<MyCourseLessonsViewPage> createState() => _MyCourseLessonsViewPageState();
}

class _MyCourseLessonsViewPageState extends State<MyCourseLessonsViewPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MyCourseProvider>().loadCourseLessons(widget.courseId);
      context.read<MyCourseProvider>().loadCourseProgress(widget.courseId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MyCourseProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading && provider.getLessons(widget.courseId).isEmpty) {
          return const Scaffold(
            backgroundColor: AppColors.background,
            body: Center(
              child: CircularProgressIndicator(
                color: AppColors.primary,
              ),
            ),
          );
        }

        if (provider.errorMessage != null && provider.getLessons(widget.courseId).isEmpty) {
          return Scaffold(
            backgroundColor: AppColors.background,
            appBar: AppBar(
              title: const Text('Bài học'),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded),
                onPressed: () => context.pop(),
              ),
            ),
            body: Center(
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
                    provider.errorMessage!,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => provider.loadCourseLessons(widget.courseId),
                    child: const Text('Thử lại'),
                  ),
                ],
              ),
            ),
          );
        }

        final lessons = provider.getLessons(widget.courseId);
        final progress = provider.getProgress(widget.courseId);

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            title: Text('Bài học'),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded),
              onPressed: () => context.pop(),
            ),
            actions: [
              if (progress != null)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '${progress.completedLessons}/${progress.totalLessons}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${progress.progressPercentage.toStringAsFixed(1)}%',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          body: Column(
            children: [
              // Progress bar
              if (progress != null)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tiến trình khóa học',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      const SizedBox(height: 8),
                      LinearProgressIndicator(
                        value: progress.progressPercentage / 100,
                        minHeight: 8,
                        backgroundColor: const Color(0xFFE8E7FF),
                        valueColor: const AlwaysStoppedAnimation(AppColors.primary),
                      ),
                    ],
                  ),
                ),
              
              // Lessons list
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    await provider.loadCourseLessons(widget.courseId);
                    await provider.loadCourseProgress(widget.courseId);
                  },
                  child: lessons.isEmpty
                      ? const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.menu_book_outlined,
                                size: 64,
                                color: AppColors.textSecondary,
                              ),
                              SizedBox(height: 16),
                              Text(
                                'Khóa học chưa có bài học nào',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(20),
                          itemCount: lessons.length,
                          itemBuilder: (context, index) {
                            final lesson = lessons[index];
                            return _LessonCard(
                              lesson: lesson,
                              onTap: () {
                                if (lesson.contentType?.toLowerCase() == 'quiz') {
                                  context.push('/quiz/lesson/${lesson.id}');
                                } else if (lesson.contentType?.toLowerCase() == 'assignment') {
                                  context.push('/assignment/${widget.courseId}/${lesson.id}');
                                } else {
                                  context.push('/lesson/${widget.courseId}/${lesson.id}');
                                }
                              },
                            );
                          },
                        ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _LessonCard extends StatelessWidget {
  const _LessonCard({
    required this.lesson,
    required this.onTap,
  });

  final Lesson lesson;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
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
                  // Content type icon
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      color: lesson.isCompleted
                          ? Colors.green.withAlpha(24)
                          : AppColors.primary.withAlpha(24),
                    ),
                    child: Icon(
                      _getContentTypeIcon(lesson.contentType ?? ''),
                      color: lesson.isCompleted
                          ? Colors.green
                          : AppColors.primary,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  
                  // Lesson info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          lesson.title,
                          style: textTheme.titleMedium?.copyWith(
                            color: lesson.isCompleted
                                ? AppColors.textSecondary
                                : Colors.black,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Text(
                              'Bài ${lesson.order}',
                              style: textTheme.bodySmall?.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                            if (lesson.durationMinutes != null && lesson.durationMinutes! > 0) ...[
                              const SizedBox(width: 8),
                              Icon(
                                Icons.schedule,
                                size: 12,
                                color: AppColors.textSecondary,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${lesson.durationMinutes} phút',
                                style: textTheme.bodySmall?.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                  
                  // Completion status
                  if (lesson.isCompleted)
                    const Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 24,
                    )
                  else
                    const Icon(
                      Icons.circle_outlined,
                      color: AppColors.border,
                      size: 24,
                    ),
                ],
              ),
              
              // Description if available
              if (lesson.description != null && lesson.description!.isNotEmpty) ...[
                const SizedBox(height: 12),
                Text(
                  lesson.description!,
                  style: textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  IconData _getContentTypeIcon(String contentType) {
    switch (contentType.toLowerCase()) {
      case 'video':
        return Icons.play_arrow;
      case 'quiz':
        return Icons.quiz;
      case 'assignment':
        return Icons.assignment;
      case 'document':
        return Icons.description;
      default:
        return Icons.article;
    }
  }
}
