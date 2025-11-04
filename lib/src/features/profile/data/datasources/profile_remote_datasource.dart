import '../../../../../core/error/exceptions.dart';
import '../../../../../core/network/api_client.dart';
import '../models/user_profile_model.dart';

abstract class ProfileRemoteDataSource {
  Future<UserProfileModel> getProfile(String userId);
  
  Future<UserProfileModel> updateProfile({
    required String userId,
    required Map<String, dynamic> data,
  });

  Future<bool> checkEmailExists(String email);
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final ApiClient client;

  ProfileRemoteDataSourceImpl(this.client);

  @override
  Future<UserProfileModel> getProfile(String userId) async {
    try {
      final response = await client.get('/Accounts/$userId');

      if (response.data == null) {
        throw ServerException('No data received from server');
      }

      final data = response.data;
      Map<String, dynamic> profileJson;

      if (data is Map<String, dynamic>) {
        profileJson = data['data'] ?? data;
      } else {
        throw ServerException('Unexpected response format');
      }

      return UserProfileModel.fromJson(profileJson);
    } catch (e) {
      if (e is ServerException || e is NetworkException) {
        rethrow;
      }
      throw ServerException('Failed to fetch profile: ${e.toString()}');
    }
  }

  @override
  Future<UserProfileModel> updateProfile({
    required String userId,
    required Map<String, dynamic> data,
  }) async {
    try {
      final response = await client.put('/Accounts/$userId', data: data);

      if (response.data == null) {
        throw ServerException('No data received from server');
      }

      final responseData = response.data;
      Map<String, dynamic> profileJson;

      if (responseData is Map<String, dynamic>) {
        profileJson = responseData['data'] ?? responseData;
      } else {
        throw ServerException('Unexpected response format');
      }

      return UserProfileModel.fromJson(profileJson);
    } catch (e) {
      if (e is ServerException || e is NetworkException) {
        rethrow;
      }
      throw ServerException('Failed to update profile: ${e.toString()}');
    }
  }

  @override
  Future<bool> checkEmailExists(String email) async {
    try {
      final response = await client.get(
        '/Accounts/check-exists',
        queryParameters: {'email': email},
      );

      if (response.data == null) {
        return false;
      }

      final data = response.data;
      
      if (data is Map<String, dynamic>) {
        return data['exists'] ?? data['data']?['exists'] ?? false;
      } else if (data is bool) {
        return data;
      }

      return false;
    } catch (e) {
      if (e is ServerException || e is NetworkException) {
        rethrow;
      }
      throw ServerException('Failed to check email: ${e.toString()}');
    }
  }
}
