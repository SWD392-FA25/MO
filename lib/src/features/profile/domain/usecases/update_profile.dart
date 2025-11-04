import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../entities/user_profile.dart';
import '../repositories/profile_repository.dart';

class UpdateProfile implements UseCase<UserProfile, UpdateProfileParams> {
  final ProfileRepository repository;

  UpdateProfile(this.repository);

  @override
  Future<Either<Failure, UserProfile>> call(UpdateProfileParams params) {
    return repository.updateProfile(
      userId: params.userId,
      data: params.data,
    );
  }
}

class UpdateProfileParams {
  final String userId;
  final Map<String, dynamic> data;

  UpdateProfileParams({
    required this.userId,
    required this.data,
  });
}
