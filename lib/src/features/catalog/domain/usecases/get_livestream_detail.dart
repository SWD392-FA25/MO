import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../entities/livestream.dart';
import '../repositories/livestream_repository.dart';

class GetLivestreamDetail implements UseCase<Livestream, String> {
  final LivestreamRepository repository;

  GetLivestreamDetail(this.repository);

  @override
  Future<Either<Failure, Livestream>> call(String livestreamId) {
    return repository.getLivestreamById(livestreamId);
  }
}
