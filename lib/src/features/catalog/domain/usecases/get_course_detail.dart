import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../entities/course.dart';
import '../repositories/course_repository.dart';

class GetCourseDetail implements UseCase<Course, String> {
  final CourseRepository repository;

  GetCourseDetail(this.repository);

  @override
  Future<Either<Failure, Course>> call(String courseId) {
    return repository.getCourseById(courseId);
  }
}
