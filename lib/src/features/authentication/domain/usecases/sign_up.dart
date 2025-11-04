import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../../../../../core/validators/input_validators.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class SignUp extends UseCase<User, SignUpParams> {
  final AuthRepository repository;

  SignUp(this.repository);

  @override
  Future<Either<Failure, User>> call(SignUpParams params) async {
    final emailError = InputValidators.email(params.email);
    if (emailError != null) {
      return Left(ValidationFailure(emailError));
    }

    final passwordError = InputValidators.password(params.password);
    if (passwordError != null) {
      return Left(ValidationFailure(passwordError));
    }

    final nameError = InputValidators.name(params.name);
    if (nameError != null) {
      return Left(ValidationFailure(nameError));
    }

    return await repository.signUp(
      email: params.email,
      password: params.password,
      name: params.name,
      phoneNumber: params.phoneNumber,
    );
  }
}

class SignUpParams extends Equatable {
  final String email;
  final String password;
  final String name;
  final String? phoneNumber;

  const SignUpParams({
    required this.email,
    required this.password,
    required this.name,
    this.phoneNumber,
  });

  @override
  List<Object?> get props => [email, password, name, phoneNumber];
}
