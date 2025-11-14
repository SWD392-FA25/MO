import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../../../core/error/failures.dart';
import '../../../../../../core/usecases/usecase.dart';
import '../repositories/order_repository.dart';

class CashPayment extends UseCase<void, CashPaymentParams> {
  final OrderRepository repository;

  CashPayment(this.repository);

  @override
  Future<Either<Failure, void>> call(CashPaymentParams params) async {
    return await repository.cashPayment(params.orderId);
  }
}

class CashPaymentParams extends Equatable {
  final String orderId;

  const CashPaymentParams({required this.orderId});

  @override
  List<Object?> get props => [orderId];
}
