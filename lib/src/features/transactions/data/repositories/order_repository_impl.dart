import 'package:dartz/dartz.dart';

import '../../../../../core/error/exceptions.dart';
import '../../../../../core/error/failures.dart';
import '../../../../../core/network/network_info.dart';
import '../../domain/entities/order.dart';
import '../../domain/repositories/order_repository.dart';
import '../datasources/order_remote_datasource.dart';

class OrderRepositoryImpl implements OrderRepository {
  final OrderRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  OrderRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, OrderEntity>> createOrder({
    required List<OrderItemRequest> items,
  }) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final orderModel = await remoteDataSource.createOrder(items: items);
      return Right(orderModel.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<OrderEntity>>> getMyOrders() async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final orderModels = await remoteDataSource.getMyOrders();
      return Right(orderModels.map((model) => model.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, OrderEntity>> getOrderById(String orderId) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final orderModel = await remoteDataSource.getOrderById(orderId);
      return Right(orderModel.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> getOrderStatus(String orderId) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final status = await remoteDataSource.getOrderStatus(orderId);
      return Right(status);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> checkoutOrder({
    required String orderId,
    required String paymentMethod,
  }) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final paymentUrl = await remoteDataSource.checkoutOrder(
        orderId: orderId,
        paymentMethod: paymentMethod,
      );
      return Right(paymentUrl);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> retryCheckout(String orderId) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final paymentUrl = await remoteDataSource.retryCheckout(orderId);
      return Right(paymentUrl);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }
}
