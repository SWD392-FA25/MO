import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class GoogleSignIn extends UseCase<User, GoogleSignInParams> {
  final AuthRepository repository;

  GoogleSignIn(this.repository);

  @override
  Future<Either<Failure, User>> call(GoogleSignInParams params) async {
    return await repository.googleSignIn(
      idToken: params.idToken,
      accessToken: params.accessToken,
    );
  }
}

class GoogleSignInParams extends Equatable {
  final String idToken;
  final String accessToken;

  const GoogleSignInParams({
    required this.idToken,
    required this.accessToken,
  });

  @override
  List<Object?> get props => [idToken, accessToken];
}
