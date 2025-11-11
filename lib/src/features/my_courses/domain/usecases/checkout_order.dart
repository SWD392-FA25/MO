import 'package:dartz/dartz.dart' hide Order;

import '../../../../../core/error/failures.dart';
import '../entities/order.dart';
import '../repositories/order_repository.dart';

class CheckoutOrder {
  final OrderRepository repository;

  CheckoutOrder(this.repository);

  Future<Either<Failure, Order>> call(String orderId) async {
    return await repository.checkoutOrder(orderId);
  }
}
