import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../entities/user_profile.dart';

abstract class ProfileRepository {
  Future<Either<Failure, UserProfile>> getProfile(String userId);
  
  Future<Either<Failure, UserProfile>> updateProfile({
    required String userId,
    required Map<String, dynamic> data,
  });

  Future<Either<Failure, bool>> checkEmailExists(String email);
}
