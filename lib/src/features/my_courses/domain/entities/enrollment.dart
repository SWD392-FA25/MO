import 'package:equatable/equatable.dart';

import '../../../catalog/domain/entities/course.dart';

class Enrollment extends Equatable {
  final String id;
  final String courseId;
  final Course? course;
  final String userId;
  final String status;
  final DateTime enrolledAt;
  final DateTime? completedAt;
  final DateTime? expiresAt;

  const Enrollment({
    required this.id,
    required this.courseId,
    this.course,
    required this.userId,
    required this.status,
    required this.enrolledAt,
    this.completedAt,
    this.expiresAt,
  });

  bool get isActive => status == 'active' || status == 'Active';
  bool get isCompleted => status == 'completed' || status == 'Completed';

  @override
  List<Object?> get props => [
        id,
        courseId,
        course,
        userId,
        status,
        enrolledAt,
        completedAt,
        expiresAt,
      ];
}
