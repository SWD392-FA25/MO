import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../entities/auth_token.dart';
import '../entities/user.dart';

abstract class AuthRepository {
  Future<Either<Failure, AuthToken>> signIn({
    required String email,
    required String password,
  });

  Future<Either<Failure, AuthToken>> signUp({
    required String email,
    required String password,
    required String name,
    String? phoneNumber,
  });

  Future<Either<Failure, void>> signOut();

  Future<Either<Failure, User>> getCurrentUser();

  Future<Either<Failure, AuthToken>> refreshToken(String refreshToken);

  Future<Either<Failure, void>> forgotPassword(String email);

  Future<Either<Failure, void>> resetPassword({
    required String token,
    required String newPassword,
  });

  Future<Either<Failure, void>> verifyOtp({
    required String email,
    required String otp,
  });

  Future<bool> isLoggedIn();
}
