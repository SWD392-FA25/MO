import '../../../../../core/error/exceptions.dart';
import '../../../../../core/network/api_client.dart';
import '../models/quiz_model.dart';

abstract class QuizRemoteDataSource {
  Future<QuizModel> getQuizForTake(String quizId);

  Future<QuizAttemptModel> createAttempt(String quizId);

  Future<QuizAttemptModel> submitAttempt({
    required String quizId,
    required String attemptId,
    required Map<String, String> answers,
  });

  Future<QuizAttemptModel> getAttempt({
    required String quizId,
    required String attemptId,
  });

  Future<List<QuizAttemptModel>> getMyAttempts();
}

class QuizRemoteDataSourceImpl implements QuizRemoteDataSource {
  final ApiClient client;

  QuizRemoteDataSourceImpl(this.client);

  @override
  Future<QuizModel> getQuizForTake(String quizId) async {
    try {
      final response = await client.get('/student/quizzes/$quizId/for-take');

      if (response.data == null) {
        throw ServerException('No data received from server');
      }

      final data = response.data;
      Map<String, dynamic> quizJson;

      if (data is Map<String, dynamic>) {
        quizJson = data['data'] ?? data;
      } else {
        throw ServerException('Unexpected response format');
      }

      return QuizModel.fromJson(quizJson);
    } catch (e) {
      if (e is ServerException || e is NetworkException) {
        rethrow;
      }
      throw ServerException('Failed to fetch quiz: ${e.toString()}');
    }
  }

  @override
  Future<QuizAttemptModel> createAttempt(String quizId) async {
    try {
      final response = await client.post('/student/quizzes/$quizId/attempts');

      if (response.data == null) {
        throw ServerException('No data received from server');
      }

      final data = response.data;
      Map<String, dynamic> attemptJson;

      if (data is Map<String, dynamic>) {
        attemptJson = data['data'] ?? data;
      } else {
        throw ServerException('Unexpected response format');
      }

      return QuizAttemptModel.fromJson(attemptJson);
    } catch (e) {
      if (e is ServerException || e is NetworkException) {
        rethrow;
      }
      throw ServerException('Failed to create quiz attempt: ${e.toString()}');
    }
  }

  @override
  Future<QuizAttemptModel> submitAttempt({
    required String quizId,
    required String attemptId,
    required Map<String, String> answers,
  }) async {
    try {
      final response = await client.post(
        '/student/quizzes/$quizId/attempts/$attemptId/submit',
        data: {
          'answers': answers,
        },
      );

      if (response.data == null) {
        throw ServerException('No data received from server');
      }

      final data = response.data;
      Map<String, dynamic> attemptJson;

      if (data is Map<String, dynamic>) {
        attemptJson = data['data'] ?? data;
      } else {
        throw ServerException('Unexpected response format');
      }

      return QuizAttemptModel.fromJson(attemptJson);
    } catch (e) {
      if (e is ServerException || e is NetworkException) {
        rethrow;
      }
      throw ServerException('Failed to submit quiz: ${e.toString()}');
    }
  }

  @override
  Future<QuizAttemptModel> getAttempt({
    required String quizId,
    required String attemptId,
  }) async {
    try {
      final response = await client.get('/student/quizzes/$quizId/attempts/$attemptId');

      if (response.data == null) {
        throw ServerException('No data received from server');
      }

      final data = response.data;
      Map<String, dynamic> attemptJson;

      if (data is Map<String, dynamic>) {
        attemptJson = data['data'] ?? data;
      } else {
        throw ServerException('Unexpected response format');
      }

      return QuizAttemptModel.fromJson(attemptJson);
    } catch (e) {
      if (e is ServerException || e is NetworkException) {
        rethrow;
      }
      throw ServerException('Failed to fetch quiz attempt: ${e.toString()}');
    }
  }

  @override
  Future<List<QuizAttemptModel>> getMyAttempts() async {
    try {
      final response = await client.get('/student/quiz-attempts');

      if (response.data == null) {
        throw ServerException('No data received from server');
      }

      final data = response.data;
      List<dynamic> attemptsJson;

      if (data is Map<String, dynamic>) {
        attemptsJson = data['data'] ?? data['items'] ?? data['attempts'] ?? [];
      } else if (data is List) {
        attemptsJson = data;
      } else {
        throw ServerException('Unexpected response format');
      }

      return attemptsJson
          .map((json) => QuizAttemptModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      if (e is ServerException || e is NetworkException) {
        rethrow;
      }
      throw ServerException('Failed to fetch quiz attempts: ${e.toString()}');
    }
  }
}
