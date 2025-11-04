import '../../domain/entities/assignment.dart';

class AssignmentModel extends Assignment {
  const AssignmentModel({
    required super.id,
    required super.title,
    required super.description,
    required super.dueDate,
    required super.maxScore,
    super.isSubmitted,
  });

  factory AssignmentModel.fromJson(Map<String, dynamic> json) {
    return AssignmentModel(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      dueDate: json['dueDate'] != null
          ? DateTime.parse(json['dueDate'])
          : DateTime.now(),
      maxScore: json['maxScore'] ?? json['totalScore'] ?? 100,
      isSubmitted: json['isSubmitted'] ?? json['submitted'] ?? false,
    );
  }

  Assignment toEntity() => Assignment(
        id: id,
        title: title,
        description: description,
        dueDate: dueDate,
        maxScore: maxScore,
        isSubmitted: isSubmitted,
      );
}

class AssignmentSubmissionModel extends AssignmentSubmission {
  const AssignmentSubmissionModel({
    required super.id,
    required super.assignmentId,
    required super.userId,
    required super.content,
    super.fileUrl,
    super.score,
    super.feedback,
    required super.submittedAt,
    super.gradedAt,
  });

  factory AssignmentSubmissionModel.fromJson(Map<String, dynamic> json) {
    return AssignmentSubmissionModel(
      id: json['id']?.toString() ?? '',
      assignmentId: json['assignmentId']?.toString() ?? '',
      userId: json['userId']?.toString() ?? json['studentId']?.toString() ?? '',
      content: json['content'] ?? json['answer'] ?? '',
      fileUrl: json['fileUrl'] ?? json['attachmentUrl'],
      score: json['score'] ?? json['grade'],
      feedback: json['feedback'] ?? json['comment'],
      submittedAt: json['submittedAt'] != null
          ? DateTime.parse(json['submittedAt'])
          : json['createdAt'] != null
              ? DateTime.parse(json['createdAt'])
              : DateTime.now(),
      gradedAt: json['gradedAt'] != null 
          ? DateTime.parse(json['gradedAt']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'assignmentId': assignmentId,
      'userId': userId,
      'content': content,
      'fileUrl': fileUrl,
      'score': score,
      'feedback': feedback,
      'submittedAt': submittedAt.toIso8601String(),
      'gradedAt': gradedAt?.toIso8601String(),
    };
  }

  AssignmentSubmission toEntity() => AssignmentSubmission(
        id: id,
        assignmentId: assignmentId,
        userId: userId,
        content: content,
        fileUrl: fileUrl,
        score: score,
        feedback: feedback,
        submittedAt: submittedAt,
        gradedAt: gradedAt,
      );
}
