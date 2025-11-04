import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../repositories/my_course_repository.dart';

class CompleteLesson implements UseCase<void, CompleteLessonParams> {
  final MyCourseRepository repository;

  CompleteLesson(this.repository);

  @override
  Future<Either<Failure, void>> call(CompleteLessonParams params) {
    return repository.completeLesson(
      courseId: params.courseId,
      lessonId: params.lessonId,
    );
  }
}

class CompleteLessonParams {
  final String courseId;
  final String lessonId;

  CompleteLessonParams({
    required this.courseId,
    required this.lessonId,
  });
}
