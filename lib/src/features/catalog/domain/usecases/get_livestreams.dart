import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../entities/livestream.dart';
import '../repositories/livestream_repository.dart';

class GetLivestreams implements UseCase<List<Livestream>, NoParams> {
  final LivestreamRepository repository;

  GetLivestreams(this.repository);

  @override
  Future<Either<Failure, List<Livestream>>> call(NoParams params) {
    return repository.getLivestreams();
  }
}
