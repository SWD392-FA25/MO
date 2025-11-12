import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../catalog/domain/entities/course_lesson.dart';
import '../../../catalog/presentation/providers/course_provider.dart';
import '../../../../theme/design_tokens.dart';

class LessonDetailPage extends StatefulWidget {
  const LessonDetailPage({
    super.key,
    required this.courseId,
    required this.lessonId,
  });

  final String courseId;
  final String lessonId;

  @override
  State<LessonDetailPage> createState() => _LessonDetailPageState();
}

class _LessonDetailPageState extends State<LessonDetailPage> {
  @override
  void initState() {
    super.initState();
    _loadLessonDetail();
  }

  Future<void> _loadLessonDetail() async {
    final provider = context.read<CourseProvider>();
    final result = await provider.getLessonDetail(widget.courseId, widget.lessonId);
    
    result.fold(
      (failure) {
        // Handle error
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(failure.message)),
          );
        }
      },
      (lesson) {
        // Lesson loaded successfully
        print('Lesson loaded: ${lesson.title}');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bài học'),
        elevation: 0,
      ),
      body: Consumer<CourseProvider>(
        builder: (context, provider, child) {
          final lessons = provider.courseLessons;
          final lesson = lessons.cast<CourseLesson?>().firstWhere(
            (l) => l?.id == widget.lessonId,
            orElse: () => null,
          );

          if (lesson == null) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Lesson Content
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Container(
                    color: AppColors.primary.withAlpha(24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.videocam_outlined,
                          size: 64,
                          color: AppColors.primary,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          lesson.contentType == 'video' ? 'Video Preview' : 'Content',
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (lesson.videoUrl != null)
                          const SizedBox(height: 8),
                        if (lesson.videoUrl != null)
                          Text(
                            'Video available',
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 12,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),

                // Lesson Content
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        lesson.title,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 12),
                      if (lesson.description != null) ...[
                        Text(
                          lesson.description!,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.textSecondary,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],

                      // Lesson Info
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.background,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          children: [
                            _InfoRow(
                              icon: Icons.schedule,
                              label: 'Thời lượng',
                              value: '${lesson.durationMinutes ?? '--'} phút',
                            ),
                            const SizedBox(height: 12),
                            _InfoRow(
                              icon: Icons.category,
                              label: 'Loại nội dung',
                              value: _getContentTypeName(lesson.contentType),
                            ),
                            const SizedBox(height: 12),
                            _InfoRow(
                              icon: Icons.numbers,
                              label: 'Thứ tự',
                              value: 'Bài ${lesson.order}',
                            ),
                            if (lesson.isFree) ...[
                              const SizedBox(height: 12),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.green.withAlpha(24),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Text(
                                  'Miễn phí',
                                  style: TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Mark as complete button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            // TODO: Implement mark as complete functionality
                          },
                          icon: const Icon(Icons.check_circle),
                          label: Text(
                            lesson.isCompleted ? 'Đã hoàn thành' : 'Đánh dấu hoàn thành',
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: lesson.isCompleted
                                ? Colors.green
                                : AppColors.primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  String _getContentTypeName(String? contentType) {
    switch (contentType) {
      case 'video':
        return 'Video';
      case 'text':
        return 'Văn bản';
      case 'quiz':
        return 'Quiz';
      default:
        return contentType?.toUpperCase() ?? 'Khác';
    }
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.primary),
        const SizedBox(width: 12),
        Text(
          '$label:',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
