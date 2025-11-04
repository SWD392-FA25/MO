import '../../../../../core/error/exceptions.dart';
import '../../../../../core/network/api_client.dart';
import '../../../catalog/data/models/lesson_model.dart';
import '../models/course_progress_model.dart';

abstract class MyCourseRemoteDataSource {
  Future<List<LessonModel>> getMyCourseLessons(String courseId);

  Future<LessonModel> getMyCourseLesson({
    required String courseId,
    required String lessonId,
  });

  Future<void> completeLesson({
    required String courseId,
    required String lessonId,
  });

  Future<CourseProgressModel> getCourseProgress(String courseId);

  Future<CourseProgressModel> updateCourseProgress({
    required String courseId,
    required int completedLessons,
  });
}

class MyCourseRemoteDataSourceImpl implements MyCourseRemoteDataSource {
  final ApiClient client;

  MyCourseRemoteDataSourceImpl(this.client);

  @override
  Future<List<LessonModel>> getMyCourseLessons(String courseId) async {
    try {
      final response = await client.get('/me/courses/$courseId/lessons');

      if (response.data == null) {
        throw ServerException('No data received from server');
      }

      final data = response.data;
      List<dynamic> lessonsJson;

      if (data is Map<String, dynamic>) {
        lessonsJson = data['data'] ?? data['items'] ?? data['lessons'] ?? [];
      } else if (data is List) {
        lessonsJson = data;
      } else {
        throw ServerException('Unexpected response format');
      }

      return lessonsJson
          .map((json) => LessonModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      if (e is ServerException || e is NetworkException) {
        rethrow;
      }
      throw ServerException('Failed to fetch my course lessons: ${e.toString()}');
    }
  }

  @override
  Future<LessonModel> getMyCourseLesson({
    required String courseId,
    required String lessonId,
  }) async {
    try {
      final response = await client.get('/me/courses/$courseId/lessons/$lessonId');

      if (response.data == null) {
        throw ServerException('No data received from server');
      }

      final data = response.data;
      Map<String, dynamic> lessonJson;

      if (data is Map<String, dynamic>) {
        lessonJson = data['data'] ?? data;
      } else {
        throw ServerException('Unexpected response format');
      }

      return LessonModel.fromJson(lessonJson);
    } catch (e) {
      if (e is ServerException || e is NetworkException) {
        rethrow;
      }
      throw ServerException('Failed to fetch lesson detail: ${e.toString()}');
    }
  }

  @override
  Future<void> completeLesson({
    required String courseId,
    required String lessonId,
  }) async {
    try {
      await client.patch(
        '/me/courses/$courseId/lessons/$lessonId/complete',
        data: {},
      );
    } catch (e) {
      if (e is ServerException || e is NetworkException) {
        rethrow;
      }
      throw ServerException('Failed to complete lesson: ${e.toString()}');
    }
  }

  @override
  Future<CourseProgressModel> getCourseProgress(String courseId) async {
    try {
      final response = await client.get('/me/courses/$courseId/progress');

      if (response.data == null) {
        throw ServerException('No data received from server');
      }

      final data = response.data;
      Map<String, dynamic> progressJson;

      if (data is Map<String, dynamic>) {
        progressJson = data['data'] ?? data;
      } else {
        throw ServerException('Unexpected response format');
      }

      return CourseProgressModel.fromJson(progressJson);
    } catch (e) {
      if (e is ServerException || e is NetworkException) {
        rethrow;
      }
      throw ServerException('Failed to fetch course progress: ${e.toString()}');
    }
  }

  @override
  Future<CourseProgressModel> updateCourseProgress({
    required String courseId,
    required int completedLessons,
  }) async {
    try {
      final response = await client.patch(
        '/me/courses/$courseId/progress',
        data: {
          'completedLessons': completedLessons,
        },
      );

      if (response.data == null) {
        throw ServerException('No data received from server');
      }

      final data = response.data;
      Map<String, dynamic> progressJson;

      if (data is Map<String, dynamic>) {
        progressJson = data['data'] ?? data;
      } else {
        throw ServerException('Unexpected response format');
      }

      return CourseProgressModel.fromJson(progressJson);
    } catch (e) {
      if (e is ServerException || e is NetworkException) {
        rethrow;
      }
      throw ServerException('Failed to update course progress: ${e.toString()}');
    }
  }
}
