import '../../../../../core/error/exceptions.dart';
import '../../../../../core/network/api_client.dart';
import '../models/payment_method_model.dart';

abstract class PaymentMethodRemoteDataSource {
  Future<List<PaymentMethodModel>> getPaymentMethods();
  
  Future<List<PaymentMethodModel>> getActivePaymentMethods();
}

class PaymentMethodRemoteDataSourceImpl implements PaymentMethodRemoteDataSource {
  final ApiClient client;

  PaymentMethodRemoteDataSourceImpl(this.client);

  @override
  Future<List<PaymentMethodModel>> getPaymentMethods() async {
    try {
      final response = await client.get('/payment-methods');

      if (response.data == null) {
        throw ServerException('No data received from server');
      }

      final data = response.data;
      List<dynamic> methodsJson;

      if (data is Map<String, dynamic>) {
        methodsJson = data['data'] ?? data['items'] ?? data['methods'] ?? [];
      } else if (data is List) {
        methodsJson = data;
      } else {
        throw ServerException('Unexpected response format');
      }

      return methodsJson
          .map((json) => PaymentMethodModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      if (e is ServerException || e is NetworkException) {
        rethrow;
      }
      throw ServerException('Failed to fetch payment methods: ${e.toString()}');
    }
  }

  @override
  Future<List<PaymentMethodModel>> getActivePaymentMethods() async {
    try {
      final response = await client.get('/payment-methods/active');

      if (response.data == null) {
        throw ServerException('No data received from server');
      }

      final data = response.data;
      List<dynamic> methodsJson;

      if (data is Map<String, dynamic>) {
        methodsJson = data['data'] ?? data['items'] ?? data['methods'] ?? [];
      } else if (data is List) {
        methodsJson = data;
      } else {
        throw ServerException('Unexpected response format');
      }

      return methodsJson
          .map((json) => PaymentMethodModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      if (e is ServerException || e is NetworkException) {
        rethrow;
      }
      throw ServerException('Failed to fetch active payment methods: ${e.toString()}');
    }
  }
}
