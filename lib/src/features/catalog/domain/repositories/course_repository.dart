import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../entities/course.dart';
import '../entities/course_lesson.dart';
import '../entities/lesson.dart';

abstract class CourseRepository {
  Future<Either<Failure, List<Course>>> getCourses({
    String? q,
    int? page,
    int? pageSize,
  });

  Future<Either<Failure, Course>> getCourseById(String id);

  Future<Either<Failure, List<CourseLesson>>> getCourseLessons(String courseId);

  Future<Either<Failure, CourseLesson>> getLessonDetail(
    String courseId,
    String lessonId,
  );
}
