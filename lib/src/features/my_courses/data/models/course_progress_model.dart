import '../../domain/entities/course_progress.dart';

class CourseProgressModel extends CourseProgress {
  const CourseProgressModel({
    required super.courseId,
    required super.completedLessons,
    required super.totalLessons,
    required super.progressPercentage,
    super.lastAccessedAt,
    super.completedAt,
  });

  factory CourseProgressModel.fromJson(Map<String, dynamic> json) {
    return CourseProgressModel(
      courseId: json['courseId']?.toString() ?? '',
      completedLessons: json['completedLessons'] ?? json['completed'] ?? 0,
      totalLessons: json['totalLessons'] ?? json['total'] ?? 0,
      progressPercentage: (json['progressPercentage'] ?? json['progress'] ?? 0).toDouble(),
      lastAccessedAt: json['lastAccessedAt'] != null 
          ? DateTime.parse(json['lastAccessedAt']) 
          : null,
      completedAt: json['completedAt'] != null 
          ? DateTime.parse(json['completedAt']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'courseId': courseId,
      'completedLessons': completedLessons,
      'totalLessons': totalLessons,
      'progressPercentage': progressPercentage,
      'lastAccessedAt': lastAccessedAt?.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
    };
  }

  CourseProgress toEntity() => CourseProgress(
        courseId: courseId,
        completedLessons: completedLessons,
        totalLessons: totalLessons,
        progressPercentage: progressPercentage,
        lastAccessedAt: lastAccessedAt,
        completedAt: completedAt,
      );
}
