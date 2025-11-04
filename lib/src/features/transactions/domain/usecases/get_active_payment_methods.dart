import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../entities/payment_method.dart';
import '../repositories/payment_method_repository.dart';

class GetActivePaymentMethods implements UseCase<List<PaymentMethod>, NoParams> {
  final PaymentMethodRepository repository;

  GetActivePaymentMethods(this.repository);

  @override
  Future<Either<Failure, List<PaymentMethod>>> call(NoParams params) {
    return repository.getActivePaymentMethods();
  }
}
