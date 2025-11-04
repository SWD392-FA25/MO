import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../entities/enrollment.dart';
import '../repositories/enrollment_repository.dart';

class GetMyEnrollments implements UseCase<List<Enrollment>, NoParams> {
  final EnrollmentRepository repository;

  GetMyEnrollments(this.repository);

  @override
  Future<Either<Failure, List<Enrollment>>> call(NoParams params) {
    return repository.getMyEnrollments();
  }
}
