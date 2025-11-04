import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../entities/payment.dart';

abstract class PaymentRepository {
  Future<Either<Failure, Payment>> createVnPayCheckout({
    required String orderId,
    required double amount,
    required String returnUrl,
  });

  Future<Either<Failure, VnPayCallback>> handleVnPayCallback(
    Map<String, String> params,
  );
}
