import '../../../../../core/error/exceptions.dart';
import '../../../../../core/network/api_client.dart';
import '../models/livestream_model.dart';

abstract class LivestreamRemoteDataSource {
  Future<List<LivestreamModel>> getLivestreams();
  
  Future<LivestreamModel> getLivestreamById(String id);
}

class LivestreamRemoteDataSourceImpl implements LivestreamRemoteDataSource {
  final ApiClient client;

  LivestreamRemoteDataSourceImpl(this.client);

  @override
  Future<List<LivestreamModel>> getLivestreams() async {
    try {
      final response = await client.get('/livestreams');

      if (response.data == null) {
        throw ServerException('No data received from server');
      }

      final data = response.data;
      List<dynamic> livestreamsJson;

      if (data is Map<String, dynamic>) {
        livestreamsJson = data['data'] ?? data['items'] ?? data['livestreams'] ?? [];
      } else if (data is List) {
        livestreamsJson = data;
      } else {
        throw ServerException('Unexpected response format');
      }

      return livestreamsJson
          .map((json) => LivestreamModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      if (e is ServerException || e is NetworkException) {
        rethrow;
      }
      throw ServerException('Failed to fetch livestreams: ${e.toString()}');
    }
  }

  @override
  Future<LivestreamModel> getLivestreamById(String id) async {
    try {
      final response = await client.get('/livestreams/$id');

      if (response.data == null) {
        throw ServerException('No data received from server');
      }

      final data = response.data;
      Map<String, dynamic> livestreamJson;

      if (data is Map<String, dynamic>) {
        livestreamJson = data['data'] ?? data;
      } else {
        throw ServerException('Unexpected response format');
      }

      return LivestreamModel.fromJson(livestreamJson);
    } catch (e) {
      if (e is ServerException || e is NetworkException) {
        rethrow;
      }
      throw ServerException('Failed to fetch livestream detail: ${e.toString()}');
    }
  }
}
