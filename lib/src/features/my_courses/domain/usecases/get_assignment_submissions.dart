import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../entities/assignment.dart';
import '../repositories/assignment_repository.dart';

class GetAssignmentSubmissions {
  final AssignmentRepository repository;

  GetAssignmentSubmissions(this.repository);

  Future<Either<Failure, List<AssignmentSubmission>>> call(String assignmentId) async {
    return await repository.getMySubmissions(assignmentId);
  }
}
