import 'package:dartz/dartz.dart';

import '../../../../../core/error/exceptions.dart';
import '../../../../../core/error/failures.dart';
import '../../../../../core/network/api_client.dart';
import '../../../../../core/network/network_info.dart';
import '../../domain/entities/auth_token.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_datasource.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;
  final NetworkInfo networkInfo;
  final ApiClient apiClient;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
    required this.apiClient,
  });

  @override
  Future<Either<Failure, AuthToken>> signIn({
    required String email,
    required String password,
  }) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final tokenModel = await remoteDataSource.signIn(
        email: email,
        password: password,
      );

      await localDataSource.cacheAuthToken(tokenModel);
      apiClient.setAuthToken(tokenModel.accessToken);

      // User data is in login response, no need to call getCurrentUser
      // TODO: Parse user from login response and cache it
      // For now, just return token
      // await localDataSource.cacheUserId(user.id);

      return Right(tokenModel.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, AuthToken>> signUp({
    required String email,
    required String password,
    required String name,
    String? phoneNumber,
  }) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final tokenModel = await remoteDataSource.signUp(
        email: email,
        password: password,
        name: name,
        phoneNumber: phoneNumber,
      );

      await localDataSource.cacheAuthToken(tokenModel);
      apiClient.setAuthToken(tokenModel.accessToken);

      // User data is in register response, no need to call getCurrentUser
      // TODO: Parse user from register response and cache it
      // For now, just return token
      // await localDataSource.cacheUserId(user.id);

      return Right(tokenModel.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      if (await networkInfo.isConnected) {
        await remoteDataSource.signOut();
      }

      await localDataSource.clearAuthToken();
      apiClient.removeAuthToken();

      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> getCurrentUser() async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final userModel = await remoteDataSource.getCurrentUser();
      return Right(userModel.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, AuthToken>> refreshToken(String refreshToken) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final tokenModel = await remoteDataSource.refreshToken(refreshToken);
      await localDataSource.cacheAuthToken(tokenModel);
      apiClient.setAuthToken(tokenModel.accessToken);

      return Right(tokenModel.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> forgotPassword(String email) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      await remoteDataSource.forgotPassword(email);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> resetPassword({
    required String token,
    required String newPassword,
  }) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      await remoteDataSource.resetPassword(
        token: token,
        newPassword: newPassword,
      );
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> verifyOtp({
    required String email,
    required String otp,
  }) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      await remoteDataSource.verifyOtp(email: email, otp: otp);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<bool> isLoggedIn() async {
    try {
      final token = await localDataSource.getCachedAuthToken();
      return token != null && !token.isExpired;
    } catch (e) {
      return false;
    }
  }
}
