import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../repositories/auth_repository.dart';

class ForgotPassword extends UseCase<void, ForgotPasswordParams> {
  final AuthRepository repository;

  ForgotPassword(this.repository);

  @override
  Future<Either<Failure, void>> call(ForgotPasswordParams params) async {
    if (params.userNameOrEmail.trim().isEmpty) {
      return const Left(ValidationFailure('Please enter your email or username'));
    }

    if (params.newPassword.length < 6) {
      return const Left(ValidationFailure('Password must be at least 6 characters'));
    }

    if (params.newPassword != params.confirmNewPassword) {
      return const Left(ValidationFailure('Passwords do not match'));
    }

    return await repository.forgotPassword(
      userNameOrEmail: params.userNameOrEmail,
      newPassword: params.newPassword,
      confirmNewPassword: params.confirmNewPassword,
    );
  }
}

class ForgotPasswordParams extends Equatable {
  final String userNameOrEmail;
  final String newPassword;
  final String confirmNewPassword;

  const ForgotPasswordParams({
    required this.userNameOrEmail,
    required this.newPassword,
    required this.confirmNewPassword,
  });

  @override
  List<Object?> get props => [userNameOrEmail, newPassword, confirmNewPassword];
}
