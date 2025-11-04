import 'package:dartz/dartz.dart';

import '../../../../../core/error/exceptions.dart';
import '../../../../../core/error/failures.dart';
import '../../../../../core/network/network_info.dart';
import '../../../catalog/domain/entities/lesson.dart';
import '../../domain/entities/course_progress.dart';
import '../../domain/repositories/my_course_repository.dart';
import '../datasources/my_course_remote_datasource.dart';

class MyCourseRepositoryImpl implements MyCourseRepository {
  final MyCourseRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  MyCourseRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<Lesson>>> getMyCourseLessons(String courseId) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final lessonModels = await remoteDataSource.getMyCourseLessons(courseId);
      return Right(lessonModels.map((model) => model.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Lesson>> getMyCourseLesson({
    required String courseId,
    required String lessonId,
  }) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final lessonModel = await remoteDataSource.getMyCourseLesson(
        courseId: courseId,
        lessonId: lessonId,
      );
      return Right(lessonModel.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> completeLesson({
    required String courseId,
    required String lessonId,
  }) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      await remoteDataSource.completeLesson(
        courseId: courseId,
        lessonId: lessonId,
      );
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, CourseProgress>> getCourseProgress(String courseId) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final progressModel = await remoteDataSource.getCourseProgress(courseId);
      return Right(progressModel.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, CourseProgress>> updateCourseProgress({
    required String courseId,
    required int completedLessons,
  }) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final progressModel = await remoteDataSource.updateCourseProgress(
        courseId: courseId,
        completedLessons: completedLessons,
      );
      return Right(progressModel.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }
}
