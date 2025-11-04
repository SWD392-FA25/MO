import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../entities/course.dart';
import '../entities/lesson.dart';

abstract class CourseRepository {
  Future<Either<Failure, List<Course>>> getCourses({
    String? category,
    String? search,
    int? page,
    int? pageSize,
  });

  Future<Either<Failure, Course>> getCourseById(String id);

  Future<Either<Failure, List<Lesson>>> getCourseLessons(String courseId);

  Future<Either<Failure, Lesson>> getCourseLesson({
    required String courseId,
    required String lessonId,
  });
}
