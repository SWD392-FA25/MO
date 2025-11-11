import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../repositories/order_repository.dart';

class RetryCheckout {
  final OrderRepository repository;

  RetryCheckout(this.repository);

  Future<Either<Failure, String>> call(String orderId) async {
    return await repository.retryCheckout(orderId);
  }
}
