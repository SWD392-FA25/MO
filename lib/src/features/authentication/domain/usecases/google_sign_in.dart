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
      firebaseIdToken: params.firebaseIdToken,
    );
  }
}

class GoogleSignInParams extends Equatable {
  final String firebaseIdToken;

  const GoogleSignInParams({
    required this.firebaseIdToken,
  });

  @override
  List<Object?> get props => [firebaseIdToken];
}
