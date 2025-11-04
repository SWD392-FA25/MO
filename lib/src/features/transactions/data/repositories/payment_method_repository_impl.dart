import 'package:dartz/dartz.dart';

import '../../../../../core/error/exceptions.dart';
import '../../../../../core/error/failures.dart';
import '../../../../../core/network/network_info.dart';
import '../../domain/entities/payment_method.dart';
import '../../domain/repositories/payment_method_repository.dart';
import '../datasources/payment_method_remote_datasource.dart';

class PaymentMethodRepositoryImpl implements PaymentMethodRepository {
  final PaymentMethodRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  PaymentMethodRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<PaymentMethod>>> getPaymentMethods() async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final methodModels = await remoteDataSource.getPaymentMethods();
      return Right(methodModels.map((model) => model.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<PaymentMethod>>> getActivePaymentMethods() async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final methodModels = await remoteDataSource.getActivePaymentMethods();
      return Right(methodModels.map((model) => model.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }
}
