import '../../../../../core/error/exceptions.dart';
import '../../../../../core/network/api_client.dart';
import '../../domain/repositories/order_repository.dart';
import '../models/order_model.dart';

abstract class OrderRemoteDataSource {
  Future<OrderModel> createOrder({required List<OrderItemRequest> items});

  Future<List<OrderModel>> getMyOrders();

  Future<OrderModel> getOrderById(String orderId);

  Future<String> getOrderStatus(String orderId);

  Future<String> checkoutOrder({
    required String orderId,
    required String paymentMethod,
  });

  Future<String> retryCheckout(String orderId);

  Future<void> cashPayment(String orderId);

  Future<void> enrollSync(String orderId);
}

class OrderRemoteDataSourceImpl implements OrderRemoteDataSource {
  final ApiClient client;

  OrderRemoteDataSourceImpl(this.client);

  @override
  Future<OrderModel> createOrder({required List<OrderItemRequest> items}) async {
    try {
      final response = await client.post(
        '/me/orders',
        data: {
          'items': items.map((item) => item.toJson()).toList(),
        },
      );

      if (response.data == null) {
        throw ServerException('No data received from server');
      }

      final data = response.data;
      print('🔍 Create Order Response:');
      print('   Full response: $data');
      
      Map<String, dynamic> orderJson;

      if (data is Map<String, dynamic>) {
        orderJson = data['data'] ?? data;
        print('   Order JSON: $orderJson');
        print('   Order ID from response: ${orderJson['id']}');
      } else {
        throw ServerException('Unexpected response format');
      }

      final orderModel = OrderModel.fromJson(orderJson);
      print('   Parsed Order ID: "${orderModel.id}"');
      
      return orderModel;
    } catch (e) {
      if (e is ServerException || e is NetworkException) {
        rethrow;
      }
      throw ServerException('Failed to create order: ${e.toString()}');
    }
  }

  @override
  Future<List<OrderModel>> getMyOrders() async {
    try {
      final response = await client.get('/me/orders');

      if (response.data == null) {
        throw ServerException('No data received from server');
      }

      final data = response.data;
      List<dynamic> ordersJson;

      if (data is Map<String, dynamic>) {
        ordersJson = data['data'] ?? data['items'] ?? data['orders'] ?? [];
      } else if (data is List) {
        ordersJson = data;
      } else {
        throw ServerException('Unexpected response format');
      }

      return ordersJson
          .map((json) => OrderModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      if (e is ServerException || e is NetworkException) {
        rethrow;
      }
      throw ServerException('Failed to fetch orders: ${e.toString()}');
    }
  }

  @override
  Future<OrderModel> getOrderById(String orderId) async {
    try {
      final response = await client.get('/me/orders/$orderId');

      if (response.data == null) {
        throw ServerException('No data received from server');
      }

      final data = response.data;
      Map<String, dynamic> orderJson;

      if (data is Map<String, dynamic>) {
        orderJson = data['data'] ?? data;
      } else {
        throw ServerException('Unexpected response format');
      }

      return OrderModel.fromJson(orderJson);
    } catch (e) {
      if (e is ServerException || e is NetworkException) {
        rethrow;
      }
      throw ServerException('Failed to fetch order: ${e.toString()}');
    }
  }

  @override
  Future<String> getOrderStatus(String orderId) async {
    try {
      final response = await client.get('/me/orders/$orderId/status');

      if (response.data == null) {
        throw ServerException('No data received from server');
      }

      final data = response.data;
      
      if (data is Map<String, dynamic>) {
        return data['status'] ?? data['data']?['status'] ?? 'unknown';
      } else if (data is String) {
        return data;
      }

      throw ServerException('Unexpected response format');
    } catch (e) {
      if (e is ServerException || e is NetworkException) {
        rethrow;
      }
      throw ServerException('Failed to get order status: ${e.toString()}');
    }
  }

  @override
  Future<String> checkoutOrder({
    required String orderId,
    required String paymentMethod,
  }) async {
    try {
      final response = await client.post(
        '/me/orders/$orderId/checkout',
        data: {
          'paymentMethod': paymentMethod,
        },
      );

      if (response.data == null) {
        throw ServerException('No data received from server');
      }

      final data = response.data;

      if (data is Map<String, dynamic>) {
        return data['paymentUrl'] ?? 
               data['checkoutUrl'] ?? 
               data['url'] ?? 
               data['redirectUrl'] ?? 
               '';
      } else if (data is String) {
        return data;
      }

      throw ServerException('Unexpected response format');
    } catch (e) {
      if (e is ServerException || e is NetworkException) {
        rethrow;
      }
      throw ServerException('Failed to checkout order: ${e.toString()}');
    }
  }

  @override
  Future<String> retryCheckout(String orderId) async {
    try {
      final response = await client.post('/me/orders/$orderId/retry-checkout');

      if (response.data == null) {
        throw ServerException('No data received from server');
      }

      final data = response.data;

      if (data is Map<String, dynamic>) {
        return data['paymentUrl'] ?? 
               data['checkoutUrl'] ?? 
               data['url'] ?? 
               '';
      } else if (data is String) {
        return data;
      }

      throw ServerException('Unexpected response format');
    } catch (e) {
      if (e is ServerException || e is NetworkException) {
        rethrow;
      }
      throw ServerException('Failed to retry checkout: ${e.toString()}');
    }
  }

  @override
  Future<void> cashPayment(String orderId) async {
    try {
      await client.post('/admin/orders/$orderId/cash-payment');
    } catch (e) {
      if (e is ServerException || e is NetworkException) {
        rethrow;
      }
      throw ServerException('Failed to process cash payment: ${e.toString()}');
    }
  }

  @override
  Future<void> enrollSync(String orderId) async {
    try {
      await client.post('/admin/orders/$orderId/enroll-sync');
    } catch (e) {
      if (e is ServerException || e is NetworkException) {
        rethrow;
      }
      throw ServerException('Failed to sync enrollment: ${e.toString()}');
    }
  }
}
