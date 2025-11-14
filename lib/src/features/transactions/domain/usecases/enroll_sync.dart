import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../../../core/error/failures.dart';
import '../../../../../../core/usecases/usecase.dart';
import '../repositories/order_repository.dart';

class EnrollSync extends UseCase<void, EnrollSyncParams> {
  final OrderRepository repository;

  EnrollSync(this.repository);

  @override
  Future<Either<Failure, void>> call(EnrollSyncParams params) async {
    return await repository.enrollSync(params.orderId);
  }
}

class EnrollSyncParams extends Equatable {
  final String orderId;

  const EnrollSyncParams({required this.orderId});

  @override
  List<Object?> get props => [orderId];
}
