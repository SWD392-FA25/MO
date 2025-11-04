import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../entities/order.dart';
import '../repositories/order_repository.dart';

class GetMyOrders implements UseCase<List<OrderEntity>, NoParams> {
  final OrderRepository repository;

  GetMyOrders(this.repository);

  @override
  Future<Either<Failure, List<OrderEntity>>> call(NoParams params) {
    return repository.getMyOrders();
  }
}
