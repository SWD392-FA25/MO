import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../entities/payment.dart';
import '../repositories/payment_repository.dart';

class CreateVnPayCheckout implements UseCase<Payment, VnPayCheckoutParams> {
  final PaymentRepository repository;

  CreateVnPayCheckout(this.repository);

  @override
  Future<Either<Failure, Payment>> call(VnPayCheckoutParams params) {
    return repository.createVnPayCheckout(
      orderId: params.orderId,
      amount: params.amount,
      returnUrl: params.returnUrl,
    );
  }
}

class VnPayCheckoutParams {
  final String orderId;
  final double amount;
  final String returnUrl;

  VnPayCheckoutParams({
    required this.orderId,
    required this.amount,
    required this.returnUrl,
  });
}
