import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../../../../../core/validators/input_validators.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class SignIn extends UseCase<User, SignInParams> {
  final AuthRepository repository;

  SignIn(this.repository);

  @override
  Future<Either<Failure, User>> call(SignInParams params) async {
    final emailError = InputValidators.email(params.email);
    if (emailError != null) {
      return Left(ValidationFailure(emailError));
    }

    final passwordError = InputValidators.password(params.password);
    if (passwordError != null) {
      return Left(ValidationFailure(passwordError));
    }

    return await repository.signIn(
      email: params.email,
      password: params.password,
    );
  }
}

class SignInParams extends Equatable {
  final String email;
  final String password;

  const SignInParams({
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [email, password];
}
