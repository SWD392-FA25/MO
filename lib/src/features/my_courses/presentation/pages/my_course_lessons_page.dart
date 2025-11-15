import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../providers/my_course_provider.dart';
import 'package:igcse_learning_hub/src/theme/design_tokens.dart';

class MyCourseLessonsPage extends StatefulWidget {
  const MyCourseLessonsPage({
    super.key,
    required this.courseId,
    required this.isCompleted,
  });

  final String courseId;
  final bool isCompleted;

  @override
  State<MyCourseLessonsPage> createState() => _MyCourseLessonsPageState();
}

class _MyCourseLessonsPageState extends State<MyCourseLessonsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MyCourseProvider>().loadCourseLessons(widget.courseId);
      context.read<MyCourseProvider>().loadMyCourseDetail(widget.courseId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final title = widget.isCompleted ? 'Bài học đã hoàn thành' : 'Bài học đang học';
    
    return Consumer<MyCourseProvider>(
      builder: (context, provider, _) {
        final lessons = provider.getLessons(widget.courseId);
        final course = provider.getCourse(widget.courseId);
        
        if (provider.isLoading && lessons.isEmpty) {
          return Scaffold(
            appBar: AppBar(title: Text(title)),
            body: const Center(child: CircularProgressIndicator(color: AppColors.primary)),
          );
        }

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            title: Text(title),
            actions: [
              if (!widget.isCompleted)
                TextButton(
                  onPressed: () => context.push('/quiz/detail'),
                  child: const Text('Làm quiz'),
                ),
            ],
          ),
          body: lessons.isEmpty
              ? const Center(child: Text('Chưa có bài học nào'))
              : ListView.separated(
                  padding: const EdgeInsets.all(20),
                  itemBuilder: (context, index) {
                    final lesson = lessons[index];
                    final status = lesson.isCompleted
                        ? LessonStatus.completed
                        : index == 0
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
                                'Lesson ${lesson.order}',
                                style: textTheme.bodySmall?.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                lesson.title,
                                style: textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                      ),
                    ),
                        if (!widget.isCompleted && status != LessonStatus.locked)
                          IconButton(
                            onPressed: () => context.push('/lesson/${widget.courseId}/${lesson.id}'),
                            icon: const Icon(Icons.play_circle_fill_rounded),
                          ),
                  ],
                ),
                    const SizedBox(height: 12),
                    Text(
                      lesson.description ?? 'Bài học ${lesson.order}',
                      style: textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
              ],
            ),
          );
        },
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                  itemCount: lessons.length,
                ),
          bottomNavigationBar: !widget.isCompleted && course != null
              ? Padding(
                  padding: const EdgeInsets.all(20),
                  child: ElevatedButton(
                    onPressed: () => context.push('/quiz'),
                    child: Text('Ôn luyện quiz cho ${course['title'] ?? 'khóa học'}'),
                  ),
                )
              : null,
        );
      },
    );
  }
}

class MyCourseVideoPage extends StatelessWidget {
  const MyCourseVideoPage({super.key, required this.courseId});

  final String courseId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Video Lesson'),
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
                'Bạn đã hoàn thành toàn bộ khóa học. Tiếp tục luyện tập với quiz để giữ phong độ nhé.',
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


