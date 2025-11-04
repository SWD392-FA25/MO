import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../entities/course.dart';
import '../repositories/course_repository.dart';

class GetCourses implements UseCase<List<Course>, GetCoursesParams> {
  final CourseRepository repository;

  GetCourses(this.repository);

  @override
  Future<Either<Failure, List<Course>>> call(GetCoursesParams params) {
    return repository.getCourses(
      category: params.category,
      search: params.search,
      page: params.page,
      pageSize: params.pageSize,
    );
  }
}

class GetCoursesParams {
  final String? category;
  final String? search;
  final int? page;
  final int? pageSize;

  GetCoursesParams({
    this.category,
    this.search,
    this.page,
    this.pageSize,
  });
}
