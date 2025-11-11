import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../repositories/order_repository.dart';

class CheckoutOrder {
  final OrderRepository repository;

  CheckoutOrder(this.repository);

  Future<Either<Failure, String>> call(String orderId) async {
    return await repository.checkoutOrder(orderId);
  }
}
