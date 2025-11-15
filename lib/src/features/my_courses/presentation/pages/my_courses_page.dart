import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../providers/enrollment_provider.dart';
import '../providers/my_course_provider.dart';
import '../../../../theme/design_tokens.dart';

class MyCoursesPage extends StatefulWidget {
  const MyCoursesPage({super.key});

  @override
  State<MyCoursesPage> createState() => _MyCoursesPageState();
}

class _MyCoursesPageState extends State<MyCoursesPage> {
  @override
  void initState() {
    super.initState();
    print('🔵 MyCoursesPage initState - Loading enrollments...');
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Load enrollments
      print('🔵 Calling EnrollmentProvider.loadEnrollments()');
      context.read<EnrollmentProvider>().loadEnrollments();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<EnrollmentProvider>(
      builder: (context, enrollmentProvider, child) {
        final enrollments = enrollmentProvider.enrollments;
        
        // Extract unique course IDs from enrollments
        final courseIds = enrollments.map((e) => e.courseId).toSet().toList();

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            title: const Text('My Courses'),
          ),
          body: enrollmentProvider.isLoading && enrollments.isEmpty
              ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
              : courseIds.isEmpty
                  ? _EmptyState()
                  : _CoursesList(courseIds: courseIds),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () => context.push('/transactions'),
            label: const Text('Xem đơn hàng'),
            icon: const Icon(Icons.receipt_long),
          ),
        );
      },
    );
  }
}



class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.school_outlined, size: 64, color: AppColors.textSecondary),
          const SizedBox(height: 16),
          const Text('Chưa có khóa học nào', style: TextStyle(fontSize: 16, color: AppColors.textSecondary)),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => context.go('/dashboard'),
            child: const Text('Khám phá khóa học'),
          ),
        ],
      ),
    );
  }
}

class _CoursesList extends StatelessWidget {
  const _CoursesList({required this.courseIds});

  final List<String> courseIds;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(20),
      itemCount: courseIds.length,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final courseId = courseIds[index];
        return _CourseCard(courseId: courseId);
      },
    );
  }
}

class _CourseCard extends StatefulWidget {
  const _CourseCard({required this.courseId});

  final String courseId;

  @override
  State<_CourseCard> createState() => _CourseCardState();
}

class _CourseCardState extends State<_CourseCard> {
  @override
  void initState() {
    super.initState();
    // Load course detail and progress
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MyCourseProvider>().loadMyCourseDetail(widget.courseId);
      context.read<MyCourseProvider>().loadCourseProgress(widget.courseId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MyCourseProvider>(
      builder: (context, provider, _) {
        final course = provider.getCourse(widget.courseId);
        final progress = provider.getProgress(widget.courseId);
        final textTheme = Theme.of(context).textTheme;

        if (course == null) {
          return Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
            ),
            child: const Center(child: CircularProgressIndicator(color: AppColors.primary)),
          );
        }

        return InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: () {
            context.read<MyCourseProvider>().loadCourseLessons(widget.courseId);
            context.push('/my-courses/ongoing/${widget.courseId}');
          },
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
                            course['title']?.toString() ?? 'Course',
                            style: textTheme.titleMedium,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            course['description']?.toString() ?? '',
                            style: textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                if (progress != null) ...[
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: LinearProgressIndicator(
                          value: progress.progressPercentage / 100,
                          minHeight: 6,
                          backgroundColor: const Color(0xFFE8E7FF),
                          valueColor: const AlwaysStoppedAnimation(AppColors.primary),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        '${progress.progressPercentage.toStringAsFixed(0)}%',
                        style: textTheme.bodySmall?.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}
