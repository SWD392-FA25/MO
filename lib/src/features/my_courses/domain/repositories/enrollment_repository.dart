import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../entities/enrollment.dart';

abstract class EnrollmentRepository {
  Future<Either<Failure, List<Enrollment>>> getMyEnrollments();
  
  Future<Either<Failure, Enrollment>> getEnrollmentById(String id);
}
