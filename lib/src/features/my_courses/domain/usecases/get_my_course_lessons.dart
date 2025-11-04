import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../../../catalog/domain/entities/lesson.dart';
import '../repositories/my_course_repository.dart';

class GetMyCourseLessons implements UseCase<List<Lesson>, String> {
  final MyCourseRepository repository;

  GetMyCourseLessons(this.repository);

  @override
  Future<Either<Failure, List<Lesson>>> call(String courseId) {
    return repository.getMyCourseLessons(courseId);
  }
}
