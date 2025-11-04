import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../entities/order.dart';

abstract class OrderRepository {
  Future<Either<Failure, OrderEntity>> createOrder({
    required List<OrderItemRequest> items,
  });

  Future<Either<Failure, List<OrderEntity>>> getMyOrders();

  Future<Either<Failure, OrderEntity>> getOrderById(String orderId);

  Future<Either<Failure, String>> getOrderStatus(String orderId);

  Future<Either<Failure, String>> checkoutOrder({
    required String orderId,
    required String paymentMethod,
  });

  Future<Either<Failure, String>> retryCheckout(String orderId);
}

class OrderItemRequest {
  final String itemType;
  final String itemId;
  final int quantity;

  OrderItemRequest({
    required this.itemType,
    required this.itemId,
    this.quantity = 1,
  });

  Map<String, dynamic> toJson() {
    return {
      'itemType': itemType,
      'itemId': itemId,
      'quantity': quantity,
    };
  }
}
