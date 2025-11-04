import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../entities/assignment.dart';

abstract class AssignmentRepository {
  Future<Either<Failure, AssignmentSubmission>> submitAssignment({
    required String assignmentId,
    required String content,
    String? fileUrl,
  });

  Future<Either<Failure, List<AssignmentSubmission>>> getMySubmissions(
    String assignmentId,
  );
}
