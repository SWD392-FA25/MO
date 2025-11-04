import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../../../catalog/domain/entities/lesson.dart';
import '../entities/course_progress.dart';

abstract class MyCourseRepository {
  Future<Either<Failure, List<Lesson>>> getMyCourseLessons(String courseId);

  Future<Either<Failure, Lesson>> getMyCourseLesson({
    required String courseId,
    required String lessonId,
  });

  Future<Either<Failure, void>> completeLesson({
    required String courseId,
    required String lessonId,
  });

  Future<Either<Failure, CourseProgress>> getCourseProgress(String courseId);

  Future<Either<Failure, CourseProgress>> updateCourseProgress({
    required String courseId,
    required int completedLessons,
  });
}
