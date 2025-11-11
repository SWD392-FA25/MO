import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../catalog/domain/entities/course.dart';
import '../../domain/entities/enrollment.dart';
import '../providers/my_course_provider.dart';
import '../providers/enrollment_provider.dart';
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<EnrollmentProvider>().loadEnrollments();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<EnrollmentProvider>(
      builder: (context, enrollmentProvider, child) {
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
                _CoursesTab(
                  enrollments: enrollmentProvider.activeEnrollments,
                  onTap: (enrollment) {
                    // Load course lessions and navigate
                    context.read<MyCourseProvider>().loadCourseLessons(enrollment.courseId);
                    context.read<MyCourseProvider>().loadCourseProgress(enrollment.courseId);
                    context.push('/my-courses/ongoing/${enrollment.courseId}');
                  },
                  progressBuilder: (enrollment) => Consumer<MyCourseProvider>(
                    builder: (context, courseProvider, _) {
                      final progress = courseProvider.getProgress(enrollment.courseId);
                      if (progress != null) {
                        return LinearProgressIndicator(
                          value: progress.progressPercentage / 100,
                          minHeight: 6,
                          backgroundColor: const Color(0xFFE8E7FF),
                          valueColor: const AlwaysStoppedAnimation(AppColors.primary),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ),
                _CoursesTab(
                  enrollments: enrollmentProvider.completedEnrollments,
                  onTap: (enrollment) =>
                      context.push('/my-courses/completed/${enrollment.courseId}'),
                  actionBuilder: (enrollment) => OutlinedButton.icon(
                    onPressed: () => context.push('/quiz'),
                    icon: const Icon(Icons.quiz),
                    label: const Text('Làm quiz'),
                  ),
                ),
              ],
            ),
            floatingActionButton: FloatingActionButton.extended(
              onPressed: () => context.push('/transactions'),
              label: const Text('Xem đơn hàng'),
              icon: const Icon(Icons.receipt_long),
            ),
          ),
        );
      },
    );
  }
}



class _CoursesTab extends StatelessWidget {
  const _CoursesTab({
    required this.enrollments,
    required this.onTap,
    this.progressBuilder,
    this.actionBuilder,
  });

  final List<Enrollment> enrollments;
  final ValueChanged<Enrollment> onTap;
  final Widget Function(Enrollment enrollment)? progressBuilder;
  final Widget Function(Enrollment enrollment)? actionBuilder;

  @override
  Widget build(BuildContext context) {
    if (enrollments.isEmpty) {
      return const Center(child: Text('Chưa có khóa học nào ở danh mục này.'));
    }
    final textTheme = Theme.of(context).textTheme;
    return ListView.separated(
      padding: const EdgeInsets.all(20),
      itemCount: enrollments.length,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final enrollment = enrollments[index];
        final course = enrollment.course;
        
        // Handle null course
        if (course == null) {
          return const SizedBox.shrink();
        }
        
        return InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: () => onTap(enrollment),
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
                      // TODO: Thay bằng thumbnail khóa học từ Figma khi có asset.
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
                if (progressBuilder != null) progressBuilder!(enrollment),
                if (actionBuilder != null) ...[
                  const SizedBox(height: 12),
                  actionBuilder!(enrollment),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}
