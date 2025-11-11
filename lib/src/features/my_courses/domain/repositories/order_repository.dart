import 'package:dartz/dartz.dart' hide Order;

import '../../../../../core/error/failures.dart';
import '../entities/order.dart';

abstract class OrderRepository {
  Future<Either<Failure, List<Order>>> getMyOrders();
  
  Future<Either<Failure, Order>> getOrderById(String orderId);
  
  Future<Either<Failure, Order>> getOrderStatus(String orderId);
  
  Future<Either<Failure, Order>> checkoutOrder(String orderId);
  
  Future<Either<Failure, Order>> retryCheckout(String orderId);
}
