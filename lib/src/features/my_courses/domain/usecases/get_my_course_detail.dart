import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../repositories/my_course_repository.dart';

class GetMyCourseDetail {
  final MyCourseRepository repository;

  GetMyCourseDetail(this.repository);

  Future<Either<Failure, Map<String, dynamic>>> call(String courseId) async {
    return await repository.getMyCourseDetail(courseId);
  }
}
