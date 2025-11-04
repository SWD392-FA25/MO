import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../repositories/order_repository.dart';

class CheckoutOrder implements UseCase<String, CheckoutOrderParams> {
  final OrderRepository repository;

  CheckoutOrder(this.repository);

  @override
  Future<Either<Failure, String>> call(CheckoutOrderParams params) {
    return repository.checkoutOrder(
      orderId: params.orderId,
      paymentMethod: params.paymentMethod,
    );
  }
}

class CheckoutOrderParams {
  final String orderId;
  final String paymentMethod;

  CheckoutOrderParams({
    required this.orderId,
    required this.paymentMethod,
  });
}
