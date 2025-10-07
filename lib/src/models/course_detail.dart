import 'package:igcse_learning_hub/src/models/course.dart';

class CourseDetail {
  CourseDetail({
    required this.course,
    required this.headline,
    required this.description,
    required this.instructor,
    required this.duration,
    required this.lessonCount,
    required this.moduleCount,
    required this.language,
    required this.highlights,
    required this.curriculum,
  });

  final Course course;
  final String headline;
  final String description;
  final String instructor;
  final String duration;
  final int lessonCount;
  final int moduleCount;
  final String language;
  final List<String> highlights;
  final List<CurriculumSection> curriculum;
}

class CurriculumSection {
  CurriculumSection({
    required this.title,
    required this.lessons,
  });

  final String title;
  final List<String> lessons;
}
