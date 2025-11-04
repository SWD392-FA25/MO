import 'package:equatable/equatable.dart';

class CourseProgress extends Equatable {
  final String courseId;
  final int completedLessons;
  final int totalLessons;
  final double progressPercentage;
  final DateTime? lastAccessedAt;
  final DateTime? completedAt;

  const CourseProgress({
    required this.courseId,
    required this.completedLessons,
    required this.totalLessons,
    required this.progressPercentage,
    this.lastAccessedAt,
    this.completedAt,
  });

  bool get isCompleted => completedAt != null || progressPercentage >= 100.0;

  @override
  List<Object?> get props => [
        courseId,
        completedLessons,
        totalLessons,
        progressPercentage,
        lastAccessedAt,
        completedAt,
      ];
}
