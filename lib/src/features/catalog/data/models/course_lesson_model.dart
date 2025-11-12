import '../../domain/entities/course_lesson.dart';

class CourseLessonModel extends CourseLesson {
  const CourseLessonModel({
    required super.id,
    required super.courseId,
    required super.title,
    super.description,
    required super.order,
    super.durationMinutes,
    super.videoUrl,
    super.thumbnailUrl,
    required super.contentType,
    super.isFree,
    super.isCompleted,
    super.createdAt,
    super.updatedAt,
  });

  factory CourseLessonModel.fromJson(Map<String, dynamic> json) {
    return CourseLessonModel(
      id: json['id']?.toString() ?? '',
      courseId: json['courseId']?.toString() ?? '',
      title: json['title'] ?? json['name'] ?? '',
      description: json['description'],
      order: json['order'] ?? json['orderNumber'] ?? 0,
      durationMinutes: json['durationMinutes'] ?? json['duration'],
      videoUrl: json['videoUrl'] ?? json['videoLink'],
      thumbnailUrl: json['thumbnailUrl'] ?? json['thumbnail'],
      contentType: json['contentType'] ?? json['type'] ?? 'video',
      isFree: json['isFree'] ?? false,
      isCompleted: json['isCompleted'] ?? false,
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'courseId': courseId,
      'title': title,
      'description': description,
      'order': order,
      'durationMinutes': durationMinutes,
      'videoUrl': videoUrl,
      'thumbnailUrl': thumbnailUrl,
      'contentType': contentType,
      'isFree': isFree,
      'isCompleted': isCompleted,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  CourseLesson toEntity() => CourseLesson(
        id: id,
        courseId: courseId,
        title: title,
        description: description,
        order: order,
        durationMinutes: durationMinutes,
        videoUrl: videoUrl,
        thumbnailUrl: thumbnailUrl,
        contentType: contentType,
        isFree: isFree,
        isCompleted: isCompleted,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
}
