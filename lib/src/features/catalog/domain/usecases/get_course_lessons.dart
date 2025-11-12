import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../entities/course_lesson.dart';
import '../repositories/course_repository.dart';

class GetCourseLessons implements UseCase<List<CourseLesson>, String> {
  final CourseRepository repository;

  GetCourseLessons(this.repository);

  @override
  Future<Either<Failure, List<CourseLesson>>> call(String courseId) {
    return repository.getCourseLessons(courseId);
  }
}

class GetLessonDetail implements UseCase<CourseLesson, GetLessonDetailParams> {
  final CourseRepository repository;

  GetLessonDetail(this.repository);

  @override
  Future<Either<Failure, CourseLesson>> call(GetLessonDetailParams params) {
    return repository.getLessonDetail(params.courseId, params.lessonId);
  }
}

class GetLessonDetailParams extends Equatable {
  final String courseId;
  final String lessonId;

  const GetLessonDetailParams({
    required this.courseId,
    required this.lessonId,
  });

  @override
  List<Object?> get props => [courseId, lessonId];
}
