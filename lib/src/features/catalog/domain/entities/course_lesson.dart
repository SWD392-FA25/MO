import 'package:equatable/equatable.dart';

class CourseLesson extends Equatable {
  final String id;
  final String courseId;
  final String title;
  final String? description;
  final int order;
  final int? durationMinutes;
  final String? videoUrl;
  final String? thumbnailUrl;
  final String contentType;
  final bool isFree;
  final bool isCompleted;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const CourseLesson({
    required this.id,
    required this.courseId,
    required this.title,
    this.description,
    required this.order,
    this.durationMinutes,
    this.videoUrl,
    this.thumbnailUrl,
    required this.contentType,
    this.isFree = false,
    this.isCompleted = false,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        courseId,
        title,
        description,
        order,
        durationMinutes,
        videoUrl,
        thumbnailUrl,
        contentType,
        isFree,
        isCompleted,
        createdAt,
        updatedAt,
      ];
}
