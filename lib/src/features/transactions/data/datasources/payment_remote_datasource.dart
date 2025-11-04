import '../../../../../core/error/exceptions.dart';
import '../../../../../core/network/api_client.dart';
import '../models/payment_model.dart';

abstract class PaymentRemoteDataSource {
  Future<PaymentModel> createVnPayCheckout({
    required String orderId,
    required double amount,
    required String returnUrl,
  });

  Future<VnPayCallbackModel> handleVnPayCallback(
    Map<String, String> params,
  );
}

class PaymentRemoteDataSourceImpl implements PaymentRemoteDataSource {
  final ApiClient client;

  PaymentRemoteDataSourceImpl(this.client);

  @override
  Future<PaymentModel> createVnPayCheckout({
    required String orderId,
    required double amount,
    required String returnUrl,
  }) async {
    try {
      final response = await client.post(
        '/vnpay/checkout',
        data: {
          'orderId': orderId,
          'amount': amount,
          'returnUrl': returnUrl,
        },
      );

      if (response.data == null) {
        throw ServerException('No data received from server');
      }

      final data = response.data;
      Map<String, dynamic> paymentJson;

      if (data is Map<String, dynamic>) {
        paymentJson = data['data'] ?? data;
      } else {
        throw ServerException('Unexpected response format');
      }

      return PaymentModel.fromJson(paymentJson);
    } catch (e) {
      if (e is ServerException || e is NetworkException) {
        rethrow;
      }
      throw ServerException('Failed to create VnPay checkout: ${e.toString()}');
    }
  }

  @override
  Future<VnPayCallbackModel> handleVnPayCallback(
    Map<String, String> params,
  ) async {
    try {
      final response = await client.get(
        '/vnpay/callback',
        queryParameters: params,
      );

      if (response.data == null) {
        throw ServerException('No data received from server');
      }

      final data = response.data;
      Map<String, dynamic> callbackJson;

      if (data is Map<String, dynamic>) {
        callbackJson = data['data'] ?? data;
      } else {
        throw ServerException('Unexpected response format');
      }

      return VnPayCallbackModel.fromJson(callbackJson);
    } catch (e) {
      if (e is ServerException || e is NetworkException) {
        rethrow;
      }
      throw ServerException('Failed to handle VnPay callback: ${e.toString()}');
    }
  }
}
