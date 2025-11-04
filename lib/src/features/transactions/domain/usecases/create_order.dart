import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../entities/order.dart';
import '../repositories/order_repository.dart';

class CreateOrder implements UseCase<OrderEntity, CreateOrderParams> {
  final OrderRepository repository;

  CreateOrder(this.repository);

  @override
  Future<Either<Failure, OrderEntity>> call(CreateOrderParams params) {
    return repository.createOrder(items: params.items);
  }
}

class CreateOrderParams {
  final List<OrderItemRequest> items;

  CreateOrderParams({required this.items});
}
