import 'package:dartz/dartz.dart';

import '../../../../../core/error/exceptions.dart';
import '../../../../../core/error/failures.dart';
import '../../../../../core/network/network_info.dart';
import '../../domain/entities/livestream.dart';
import '../../domain/repositories/livestream_repository.dart';
import '../datasources/livestream_remote_datasource.dart';

class LivestreamRepositoryImpl implements LivestreamRepository {
  final LivestreamRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  LivestreamRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<Livestream>>> getLivestreams() async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final livestreamModels = await remoteDataSource.getLivestreams();
      return Right(livestreamModels.map((model) => model.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Livestream>> getLivestreamById(String id) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final livestreamModel = await remoteDataSource.getLivestreamById(id);
      return Right(livestreamModel.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }
}
