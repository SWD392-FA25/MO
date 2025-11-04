import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../entities/lesson.dart';
import '../repositories/course_repository.dart';

class GetCourseLessons implements UseCase<List<Lesson>, String> {
  final CourseRepository repository;

  GetCourseLessons(this.repository);

  @override
  Future<Either<Failure, List<Lesson>>> call(String courseId) {
    return repository.getCourseLessons(courseId);
  }
}
