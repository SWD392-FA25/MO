import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../entities/livestream.dart';

abstract class LivestreamRepository {
  Future<Either<Failure, List<Livestream>>> getLivestreams();
  
  Future<Either<Failure, Livestream>> getLivestreamById(String id);
}
