import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../entities/course_progress.dart';
import '../repositories/my_course_repository.dart';

class GetCourseProgress implements UseCase<CourseProgress, String> {
  final MyCourseRepository repository;

  GetCourseProgress(this.repository);

  @override
  Future<Either<Failure, CourseProgress>> call(String courseId) {
    return repository.getCourseProgress(courseId);
  }
}
