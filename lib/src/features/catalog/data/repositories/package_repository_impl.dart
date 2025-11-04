import 'package:dartz/dartz.dart';

import '../../../../../core/error/exceptions.dart';
import '../../../../../core/error/failures.dart';
import '../../../../../core/network/network_info.dart';
import '../../domain/entities/package.dart';
import '../../domain/repositories/package_repository.dart';
import '../datasources/package_remote_datasource.dart';

class PackageRepositoryImpl implements PackageRepository {
  final PackageRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  PackageRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<Package>>> getPackages() async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final packageModels = await remoteDataSource.getPackages();
      return Right(packageModels.map((model) => model.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Package>> getPackageById(String id) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final packageModel = await remoteDataSource.getPackageById(id);
      return Right(packageModel.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }
}
