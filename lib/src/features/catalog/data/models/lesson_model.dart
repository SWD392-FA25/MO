import '../../domain/entities/lesson.dart';

class LessonModel extends Lesson {
  const LessonModel({
    required super.id,
    required super.courseId,
    required super.title,
    super.description,
    required super.order,
    super.durationMinutes,
    super.videoUrl,
    super.contentType,
    super.isFree,
    super.isCompleted,
    super.createdAt,
  });

  factory LessonModel.fromJson(Map<String, dynamic> json) {
    return LessonModel(
      id: json['id']?.toString() ?? '',
      courseId: json['courseId']?.toString() ?? '',
      title: json['title'] ?? json['name'] ?? '',
      description: json['description'],
      order: json['order'] ?? json['orderNumber'] ?? 0,
      durationMinutes: json['durationMinutes'] ?? json['duration'],
      videoUrl: json['videoUrl'] ?? json['videoLink'],
      contentType: json['contentType'] ?? json['type'],
      isFree: json['isFree'] ?? false,
      isCompleted: json['isCompleted'] ?? false,
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
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
      'contentType': contentType,
      'isFree': isFree,
      'isCompleted': isCompleted,
      'createdAt': createdAt?.toIso8601String(),
    };
  }

  Lesson toEntity() => Lesson(
        id: id,
        courseId: courseId,
        title: title,
        description: description,
        order: order,
        durationMinutes: durationMinutes,
        videoUrl: videoUrl,
        contentType: contentType,
        isFree: isFree,
        isCompleted: isCompleted,
        createdAt: createdAt,
      );
}
