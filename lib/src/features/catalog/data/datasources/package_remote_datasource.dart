import '../../../../../core/error/exceptions.dart';
import '../../../../../core/network/api_client.dart';
import '../models/package_model.dart';

abstract class PackageRemoteDataSource {
  Future<List<PackageModel>> getPackages();
  
  Future<PackageModel> getPackageById(String id);
}

class PackageRemoteDataSourceImpl implements PackageRemoteDataSource {
  final ApiClient client;

  PackageRemoteDataSourceImpl(this.client);

  @override
  Future<List<PackageModel>> getPackages() async {
    try {
      final response = await client.get('/packages');

      if (response.data == null) {
        throw ServerException('No data received from server');
      }

      final data = response.data;
      List<dynamic> packagesJson;

      if (data is Map<String, dynamic>) {
        packagesJson = data['data'] ?? data['items'] ?? data['packages'] ?? [];
      } else if (data is List) {
        packagesJson = data;
      } else {
        throw ServerException('Unexpected response format');
      }

      return packagesJson
          .map((json) => PackageModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      if (e is ServerException || e is NetworkException) {
        rethrow;
      }
      throw ServerException('Failed to fetch packages: ${e.toString()}');
    }
  }

  @override
  Future<PackageModel> getPackageById(String id) async {
    try {
      final response = await client.get('/packages/$id');

      if (response.data == null) {
        throw ServerException('No data received from server');
      }

      final data = response.data;
      Map<String, dynamic> packageJson;

      if (data is Map<String, dynamic>) {
        packageJson = data['data'] ?? data;
      } else {
        throw ServerException('Unexpected response format');
      }

      return PackageModel.fromJson(packageJson);
    } catch (e) {
      if (e is ServerException || e is NetworkException) {
        rethrow;
      }
      throw ServerException('Failed to fetch package detail: ${e.toString()}');
    }
  }
}
