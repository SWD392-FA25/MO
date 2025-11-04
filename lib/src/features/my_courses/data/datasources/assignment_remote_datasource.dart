import '../../../../../core/error/exceptions.dart';
import '../../../../../core/network/api_client.dart';
import '../models/assignment_model.dart';

abstract class AssignmentRemoteDataSource {
  Future<AssignmentSubmissionModel> submitAssignment({
    required String assignmentId,
    required String content,
    String? fileUrl,
  });

  Future<List<AssignmentSubmissionModel>> getMySubmissions(String assignmentId);
}

class AssignmentRemoteDataSourceImpl implements AssignmentRemoteDataSource {
  final ApiClient client;

  AssignmentRemoteDataSourceImpl(this.client);

  @override
  Future<AssignmentSubmissionModel> submitAssignment({
    required String assignmentId,
    required String content,
    String? fileUrl,
  }) async {
    try {
      final response = await client.post(
        '/me/assignments/$assignmentId/submissions',
        data: {
          'content': content,
          if (fileUrl != null) 'fileUrl': fileUrl,
        },
      );

      if (response.data == null) {
        throw ServerException('No data received from server');
      }

      final data = response.data;
      Map<String, dynamic> submissionJson;

      if (data is Map<String, dynamic>) {
        submissionJson = data['data'] ?? data;
      } else {
        throw ServerException('Unexpected response format');
      }

      return AssignmentSubmissionModel.fromJson(submissionJson);
    } catch (e) {
      if (e is ServerException || e is NetworkException) {
        rethrow;
      }
      throw ServerException('Failed to submit assignment: ${e.toString()}');
    }
  }

  @override
  Future<List<AssignmentSubmissionModel>> getMySubmissions(String assignmentId) async {
    try {
      final response = await client.get('/me/assignments/$assignmentId/submissions');

      if (response.data == null) {
        throw ServerException('No data received from server');
      }

      final data = response.data;
      List<dynamic> submissionsJson;

      if (data is Map<String, dynamic>) {
        submissionsJson = data['data'] ?? data['items'] ?? data['submissions'] ?? [];
      } else if (data is List) {
        submissionsJson = data;
      } else {
        throw ServerException('Unexpected response format');
      }

      return submissionsJson
          .map((json) => AssignmentSubmissionModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      if (e is ServerException || e is NetworkException) {
        rethrow;
      }
      throw ServerException('Failed to fetch submissions: ${e.toString()}');
    }
  }
}
