import 'package:dartz/dartz.dart' hide Order;

import '../../../../../core/error/failures.dart';
import '../entities/order.dart';
import '../repositories/order_repository.dart';

class GetMyOrders {
  final OrderRepository repository;

  GetMyOrders(this.repository);

  Future<Either<Failure, List<Order>>> call() async {
    return await repository.getMyOrders();
  }
}
