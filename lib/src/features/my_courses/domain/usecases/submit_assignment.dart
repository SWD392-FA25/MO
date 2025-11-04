import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../entities/assignment.dart';
import '../repositories/assignment_repository.dart';

class SubmitAssignment implements UseCase<AssignmentSubmission, SubmitAssignmentParams> {
  final AssignmentRepository repository;

  SubmitAssignment(this.repository);

  @override
  Future<Either<Failure, AssignmentSubmission>> call(SubmitAssignmentParams params) {
    return repository.submitAssignment(
      assignmentId: params.assignmentId,
      content: params.content,
      fileUrl: params.fileUrl,
    );
  }
}

class SubmitAssignmentParams {
  final String assignmentId;
  final String content;
  final String? fileUrl;

  SubmitAssignmentParams({
    required this.assignmentId,
    required this.content,
    this.fileUrl,
  });
}
