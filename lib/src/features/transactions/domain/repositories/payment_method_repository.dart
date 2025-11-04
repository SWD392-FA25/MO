import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../entities/payment_method.dart';

abstract class PaymentMethodRepository {
  Future<Either<Failure, List<PaymentMethod>>> getPaymentMethods();
  
  Future<Either<Failure, List<PaymentMethod>>> getActivePaymentMethods();
}
