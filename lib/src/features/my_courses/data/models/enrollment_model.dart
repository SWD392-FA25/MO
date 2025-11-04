import '../../../catalog/data/models/course_model.dart';
import '../../domain/entities/enrollment.dart';

class EnrollmentModel extends Enrollment {
  const EnrollmentModel({
    required super.id,
    required super.courseId,
    super.course,
    required super.userId,
    required super.status,
    required super.enrolledAt,
    super.completedAt,
    super.expiresAt,
  });

  factory EnrollmentModel.fromJson(Map<String, dynamic> json) {
    return EnrollmentModel(
      id: json['id']?.toString() ?? '',
      courseId: json['courseId']?.toString() ?? '',
      course: json['course'] != null 
          ? CourseModel.fromJson(json['course'] as Map<String, dynamic>).toEntity()
          : null,
      userId: json['userId']?.toString() ?? json['studentId']?.toString() ?? '',
      status: json['status'] ?? 'active',
      enrolledAt: json['enrolledAt'] != null
          ? DateTime.parse(json['enrolledAt'])
          : json['createdAt'] != null
              ? DateTime.parse(json['createdAt'])
              : DateTime.now(),
      completedAt: json['completedAt'] != null 
          ? DateTime.parse(json['completedAt']) 
          : null,
      expiresAt: json['expiresAt'] != null 
          ? DateTime.parse(json['expiresAt']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'courseId': courseId,
      'userId': userId,
      'status': status,
      'enrolledAt': enrolledAt.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
      'expiresAt': expiresAt?.toIso8601String(),
    };
  }

  Enrollment toEntity() => Enrollment(
        id: id,
        courseId: courseId,
        course: course,
        userId: userId,
        status: status,
        enrolledAt: enrolledAt,
        completedAt: completedAt,
        expiresAt: expiresAt,
      );
}
