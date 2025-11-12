import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../catalog/domain/entities/lesson.dart';
import '../providers/my_course_provider.dart';
import '../../../../theme/design_tokens.dart';

class LessonDetailPage extends StatelessWidget {
  const LessonDetailPage({
    super.key,
    required this.courseId,
    required this.lessonId,
  });

  final String courseId;
  final String lessonId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Chi tiết bài học'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: FutureBuilder<Lesson>(
        future: _loadLesson(context),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppColors.primary,
              ),
            );
          }

          if (snapshot.hasError) {
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
                    'Đã có lỗi xảy ra: ${snapshot.error}',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.pushReplacement(
                      '/my-courses/ongoing/$courseId',
                    ),
                    child: const Text('Quay lại khóa học'),
                  ),
                ],
              ),
            );
          }

          if (!snapshot.hasData) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.article_outlined,
                    size: 64,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Không tìm thấy bài học',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.pushReplacement(
                      '/my-courses/ongoing/$courseId',
                    ),
                    child: const Text('Quay lại khóa học'),
                  ),
                ],
              ),
            );
          }

          final lesson = snapshot.data!;
          return Consumer<MyCourseProvider>(
            builder: (context, provider, _) {
              return _LessonContent(
                lesson: lesson,
                courseId: courseId,
                onComplete: () async {
                  final success = await provider.completeLesson(courseId, lessonId);
                  if (success) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Đã hoàn thành bài học!')),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(provider.errorMessage ?? 'Không thể hoàn thành bài học'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                isCompleting: provider.isLoading,
              );
            },
          );
        },
      ),
    );
  }

  Future<Lesson> _loadLesson(BuildContext context) async {
    final provider = context.read<MyCourseProvider>();
    final lessons = provider.getLessons(courseId);
    
    // If lessons are already loaded, return the requested one
    if (lessons.isNotEmpty) {
      final lesson = lessons.firstWhere(
        (l) => l.id == lessonId,
        orElse: () => throw Exception('Lesson not found'),
      );
      return lesson;
    }
    
    // Load lessons if not available
    await provider.loadCourseLessons(courseId);
    final updatedLessons = provider.getLessons(courseId);
    
    return updatedLessons.firstWhere(
      (l) => l.id == lessonId,
      orElse: () => throw Exception('Lesson not found'),
    );
  }
}

class _LessonContent extends StatelessWidget {
  const _LessonContent({
    required this.lesson,
    required this.courseId,
    required this.onComplete,
    required this.isCompleting,
  });

  final Lesson lesson;
  final String courseId;
  final VoidCallback onComplete;
  final bool isCompleting;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Lesson Header Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
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
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        color: AppColors.primary.withAlpha(24),
                      ),
                      child: Icon(
                        _getContentTypeIcon(lesson.contentType ?? ''),
                        color: AppColors.primary,
                        size: 32,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            lesson.title,
                            style: textTheme.titleMedium,
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: lesson.isCompleted
                                      ? Colors.green.withAlpha(24)
                                      : AppColors.primary.withAlpha(24),
                                ),
                                child: Text(
                                  lesson.isCompleted ? 'Đã hoàn thành' : 'Chưa hoàn thành',
                                  style: textTheme.bodySmall?.copyWith(
                                    color: lesson.isCompleted
                                        ? Colors.green
                                        : AppColors.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              if (lesson.durationMinutes != null && lesson.durationMinutes! > 0) ...[
                                const SizedBox(width: 8),
                                Icon(
                                  Icons.schedule,
                                  size: 16,
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
                  ],
                ),
                if (lesson.description != null && lesson.description!.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Text(
                    lesson.description!,
                    style: textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                      height: 1.5,
                    ),
                  ),
                ],
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Content Area
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
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
                Text(
                  'Nội dung bài học',
                  style: textTheme.titleMedium,
                ),
                const SizedBox(height: 16),
                _LessonContentView(lesson: lesson),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Complete Button
          if (!lesson.isCompleted)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: isCompleting ? null : onComplete,
                icon: isCompleting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.check_circle),
                label: Text(isCompleting ? 'Đang hoàn thành...' : 'Đánh dấu hoàn thành'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            )
          else
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.withAlpha(24),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.check_circle,
                    color: Colors.green,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Bài học đã hoàn thành',
                    style: textTheme.titleMedium?.copyWith(
                      color: Colors.green,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _LessonContentView extends StatelessWidget {
  const _LessonContentView({
    required this.lesson,
  });

  final Lesson lesson;

  @override
  Widget build(BuildContext context) {
    switch (lesson.contentType?.toLowerCase() ?? '') {
      case 'video':
        return _VideoContentView(lesson: lesson);
      case 'quiz':
        return _QuizContentView(lesson: lesson);
      case 'assignment':
        return _AssignmentContentView(lesson: lesson);
      case 'document':
        return _DocumentContentView(lesson: lesson);
      default:
        return _DefaultContentView(lesson: lesson);
    }
  }
}

class _VideoContentView extends StatelessWidget {
  const _VideoContentView({
    required this.lesson,
  });

  final Lesson lesson;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 200,
          decoration: BoxDecoration(
            color: Colors.black.withAlpha(24),
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Icon(
            Icons.play_circle_filled,
            size: 64,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Nội dung video sẽ được hiển thị ở đây.',
          style: Theme.of(context).textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _QuizContentView extends StatelessWidget {
  const _QuizContentView({
    required this.lesson,
  });

  final Lesson lesson;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          Icons.quiz,
          size: 64,
          color: AppColors.primary,
        ),
        const SizedBox(height: 16),
        Text(
          'Bài kiểm tra sẽ được hiển thị ở đây.',
          style: Theme.of(context).textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        ElevatedButton.icon(
          onPressed: () {
            // Navigate to quiz screen
            // Assuming lesson.id is the quiz ID
            context.push('/quiz/${lesson.id}');
          },
          icon: const Icon(Icons.quiz),
          label: const Text('Bắt đầu làm bài'),
        ),
      ],
    );
  }
}

class _AssignmentContentView extends StatelessWidget {
  const _AssignmentContentView({
    required this.lesson,
  });

  final Lesson lesson;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          Icons.assignment,
          size: 64,
          color: AppColors.primary,
        ),
        const SizedBox(height: 16),
        Text(
          'Bài tập sẽ được hiển thị ở đây.',
          style: Theme.of(context).textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        ElevatedButton.icon(
          onPressed: () {
            // TODO: Navigate to assignment screen
          },
          icon: const Icon(Icons.assignment),
          label: const Text('Xem bài tập'),
        ),
      ],
    );
  }
}

class _DocumentContentView extends StatelessWidget {
  const _DocumentContentView({
    required this.lesson,
  });

  final Lesson lesson;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          Icons.description,
          size: 64,
          color: AppColors.primary,
        ),
        const SizedBox(height: 16),
        Text(
          'Tài liệu sẽ được hiển thị ở đây.',
          style: Theme.of(context).textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        ElevatedButton.icon(
          onPressed: () {
            // TODO: Open document
          },
          icon: const Icon(Icons.open_in_browser),
          label: const Text('Mở tài liệu'),
        ),
      ],
    );
  }
}

class _DefaultContentView extends StatelessWidget {
  const _DefaultContentView({
    required this.lesson,
  });

  final Lesson lesson;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          Icons.article,
          size: 64,
          color: AppColors.primary,
        ),
        const SizedBox(height: 16),
        Text(
          'Nội dung bài học sẽ được hiển thị ở đây.',
          style: Theme.of(context).textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
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
