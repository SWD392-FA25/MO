import '../../../../../core/error/exceptions.dart';
import '../../../../../core/network/api_client.dart';
import '../models/course_lesson_model.dart';
import '../models/course_model.dart';

abstract class CourseRemoteDataSource {
  Future<List<CourseModel>> getCourses({
    String? q,
    int? page,
    int? pageSize,
  });

  Future<CourseModel> getCourseById(String id);

  Future<List<CourseLessonModel>> getCourseLessons(String courseId);

  Future<CourseLessonModel> getLessonDetail(
    String courseId,
    String lessonId,
  );
}

class CourseRemoteDataSourceImpl implements CourseRemoteDataSource {
  final ApiClient client;

  CourseRemoteDataSourceImpl(this.client);

  @override
  Future<List<CourseModel>> getCourses({
    String? q,
    int? page,
    int? pageSize,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (q != null && q.isNotEmpty) queryParams['q'] = q;
      if (page != null) queryParams['pageNumber'] = page;
      if (pageSize != null) queryParams['pageSize'] = pageSize;

      final response = await client.get(
        '/courses',
        queryParameters: queryParams,
      );

      if (response.data == null) {
        throw ServerException('No data received from server');
      }

      final data = response.data;
      List<dynamic> coursesJson;

      if (data is Map<String, dynamic>) {
        coursesJson = data['data'] ?? data['items'] ?? data['courses'] ?? [];
      } else if (data is List) {
        coursesJson = data;
      } else {
        throw ServerException('Unexpected response format');
      }

      return coursesJson
          .map((json) => CourseModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      if (e is ServerException || e is NetworkException) {
        rethrow;
      }
      throw ServerException('Failed to fetch courses: ${e.toString()}');
    }
  }

  @override
  Future<CourseModel> getCourseById(String id) async {
    try {
      final response = await client.get('/courses/$id');

      if (response.data == null) {
        throw ServerException('No data received from server');
      }

      final data = response.data;
      Map<String, dynamic> courseJson;

      if (data is Map<String, dynamic>) {
        courseJson = data['data'] ?? data;
      } else {
        throw ServerException('Unexpected response format');
      }

      return CourseModel.fromJson(courseJson);
    } catch (e) {
      if (e is ServerException || e is NetworkException) {
        rethrow;
      }
      throw ServerException('Failed to fetch course detail: ${e.toString()}');
    }
  }

  @override
  Future<List<CourseLessonModel>> getCourseLessons(String courseId) async {
    try {
      print('🔍 [DATASOURCE] Fetching lessons for course: $courseId');
      final response = await client.get('/courses/$courseId/lessons');

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

      print('🔍 [DATASOURCE] Found ${lessonsJson.length} lessons');
      return lessonsJson
          .map((json) => CourseLessonModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('🔍 [DATASOURCE] Error fetching course lessons: ${e.toString()}');
      if (e is ServerException || e is NetworkException) {
        rethrow;
      }
      throw ServerException('Failed to fetch course lessons: ${e.toString()}');
    }
  }

  @override
  Future<CourseLessonModel> getLessonDetail(
    String courseId,
    String lessonId,
  ) async {
    try {
      print('🔍 [DATASOURCE] Fetching lesson detail for: course=$courseId, lesson=$lessonId');
      final response = await client.get('/courses/$courseId/lessons/$lessonId');

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

      print('🔍 [DATASOURCE] Lesson detail fetched successfully');
      return CourseLessonModel.fromJson(lessonJson);
    } catch (e) {
      print('🔍 [DATASOURCE] Error fetching lesson detail: ${e.toString()}');
      if (e is ServerException || e is NetworkException) {
        rethrow;
      }
      throw ServerException('Failed to fetch lesson detail: ${e.toString()}');
    }
  }
}
