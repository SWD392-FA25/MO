import 'package:equatable/equatable.dart';

class Assignment extends Equatable {
  final String id;
  final String title;
  final String description;
  final DateTime dueDate;
  final int maxScore;
  final bool isSubmitted;

  const Assignment({
    required this.id,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.maxScore,
    this.isSubmitted = false,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        dueDate,
        maxScore,
        isSubmitted,
      ];
}

class AssignmentSubmission extends Equatable {
  final String id;
  final String assignmentId;
  final String userId;
  final String content;
  final String? fileUrl;
  final int? score;
  final String? feedback;
  final DateTime submittedAt;
  final DateTime? gradedAt;

  const AssignmentSubmission({
    required this.id,
    required this.assignmentId,
    required this.userId,
    required this.content,
    this.fileUrl,
    this.score,
    this.feedback,
    required this.submittedAt,
    this.gradedAt,
  });

  bool get isGraded => gradedAt != null && score != null;

  @override
  List<Object?> get props => [
        id,
        assignmentId,
        userId,
        content,
        fileUrl,
        score,
        feedback,
        submittedAt,
        gradedAt,
      ];
}
