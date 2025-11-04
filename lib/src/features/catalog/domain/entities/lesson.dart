import 'package:equatable/equatable.dart';

class Lesson extends Equatable {
  final String id;
  final String courseId;
  final String title;
  final String? description;
  final int order;
  final int? durationMinutes;
  final String? videoUrl;
  final String? contentType;
  final bool isFree;
  final bool isCompleted;
  final DateTime? createdAt;

  const Lesson({
    required this.id,
    required this.courseId,
    required this.title,
    this.description,
    required this.order,
    this.durationMinutes,
    this.videoUrl,
    this.contentType,
    this.isFree = false,
    this.isCompleted = false,
    this.createdAt,
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
        contentType,
        isFree,
        isCompleted,
        createdAt,
      ];
}
