import '../../../../../core/error/exceptions.dart';
import '../../../../../core/network/api_client.dart';
import '../models/enrollment_model.dart';

abstract class EnrollmentRemoteDataSource {
  Future<List<EnrollmentModel>> getMyEnrollments();
  
  Future<EnrollmentModel> getEnrollmentById(String id);
}

class EnrollmentRemoteDataSourceImpl implements EnrollmentRemoteDataSource {
  final ApiClient client;

  EnrollmentRemoteDataSourceImpl(this.client);

  @override
  Future<List<EnrollmentModel>> getMyEnrollments() async {
    try {
      print('🔵 API Call: GET /me/enrollments');
      final response = await client.get('/me/enrollments');

      if (response.data == null) {
        throw ServerException('No data received from server');
      }

      final data = response.data;
      List<dynamic> enrollmentsJson;

      if (data is Map<String, dynamic>) {
        enrollmentsJson = data['data'] ?? data['items'] ?? data['enrollments'] ?? [];
      } else if (data is List) {
        enrollmentsJson = data;
      } else {
        throw ServerException('Unexpected response format');
      }

      return enrollmentsJson
          .map((json) => EnrollmentModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      if (e is ServerException || e is NetworkException) {
        rethrow;
      }
      throw ServerException('Failed to fetch enrollments: ${e.toString()}');
    }
  }

  @override
  Future<EnrollmentModel> getEnrollmentById(String id) async {
    try {
      final response = await client.get('/me/enrollments/$id');

      if (response.data == null) {
        throw ServerException('No data received from server');
      }

      final data = response.data;
      Map<String, dynamic> enrollmentJson;

      if (data is Map<String, dynamic>) {
        enrollmentJson = data['data'] ?? data;
      } else {
        throw ServerException('Unexpected response format');
      }

      return EnrollmentModel.fromJson(enrollmentJson);
    } catch (e) {
      if (e is ServerException || e is NetworkException) {
        rethrow;
      }
      throw ServerException('Failed to fetch enrollment: ${e.toString()}');
    }
  }
}
