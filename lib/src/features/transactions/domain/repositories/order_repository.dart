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

  Future<Either<Failure, void>> cashPayment(String orderId);

  Future<Either<Failure, void>> enrollSync(String orderId);
}

class OrderItemRequest {
  final String courseId;
  final int quantity;

  OrderItemRequest({
    required this.courseId,
    this.quantity = 1,
  });

  Map<String, dynamic> toJson() {
    final parsedId = int.tryParse(courseId) ?? 0;
    print('🔍 OrderItemRequest.toJson():');
    print('   courseId (String): "$courseId"');
    print('   parsedId (int): $parsedId');
    
    // Backend expects itemType and itemId instead of courseId
    return {
      'itemType': 'Course',
      'itemId': parsedId,
      'quantity': quantity,
    };
  }
}
