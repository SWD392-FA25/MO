import 'package:dartz/dartz.dart' hide Order;

import '../../../../../core/error/failures.dart';
import '../entities/order.dart';
import '../repositories/order_repository.dart';

class GetOrderById {
  final OrderRepository repository;

  GetOrderById(this.repository);

  Future<Either<Failure, Order>> call(String orderId) async {
    return await repository.getOrderById(orderId);
  }
}
