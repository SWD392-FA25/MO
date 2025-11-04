import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../../../../../core/validators/input_validators.dart';
import '../repositories/auth_repository.dart';

class ForgotPassword extends UseCase<void, ForgotPasswordParams> {
  final AuthRepository repository;

  ForgotPassword(this.repository);

  @override
  Future<Either<Failure, void>> call(ForgotPasswordParams params) async {
    final emailError = InputValidators.email(params.email);
    if (emailError != null) {
      return Left(ValidationFailure(emailError));
    }

    return await repository.forgotPassword(params.email);
  }
}

class ForgotPasswordParams extends Equatable {
  final String email;

  const ForgotPasswordParams(this.email);

  @override
  List<Object?> get props => [email];
}
