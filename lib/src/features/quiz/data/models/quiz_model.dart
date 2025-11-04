import '../../domain/entities/quiz.dart';

class QuizModel extends Quiz {
  const QuizModel({
    required super.id,
    required super.title,
    super.description,
    required super.questionCount,
    required super.durationMinutes,
    required super.passingScore,
    super.isActive,
  });

  factory QuizModel.fromJson(Map<String, dynamic> json) {
    return QuizModel(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? json['name'] ?? '',
      description: json['description'],
      questionCount: json['questionCount'] ?? json['totalQuestions'] ?? 0,
      durationMinutes: json['durationMinutes'] ?? json['duration'] ?? 0,
      passingScore: json['passingScore'] ?? json['passScore'] ?? 0,
      isActive: json['isActive'] ?? json['active'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'questionCount': questionCount,
      'durationMinutes': durationMinutes,
      'passingScore': passingScore,
      'isActive': isActive,
    };
  }

  Quiz toEntity() => Quiz(
        id: id,
        title: title,
        description: description,
        questionCount: questionCount,
        durationMinutes: durationMinutes,
        passingScore: passingScore,
        isActive: isActive,
      );
}

class QuizAttemptModel extends QuizAttempt {
  const QuizAttemptModel({
    required super.id,
    required super.quizId,
    required super.userId,
    required super.score,
    required super.totalQuestions,
    required super.isPassed,
    required super.startedAt,
    super.completedAt,
  });

  factory QuizAttemptModel.fromJson(Map<String, dynamic> json) {
    return QuizAttemptModel(
      id: json['id']?.toString() ?? '',
      quizId: json['quizId']?.toString() ?? '',
      userId: json['userId']?.toString() ?? json['studentId']?.toString() ?? '',
      score: json['score'] ?? 0,
      totalQuestions: json['totalQuestions'] ?? json['total'] ?? 0,
      isPassed: json['isPassed'] ?? json['passed'] ?? false,
      startedAt: json['startedAt'] != null
          ? DateTime.parse(json['startedAt'])
          : json['createdAt'] != null
              ? DateTime.parse(json['createdAt'])
              : DateTime.now(),
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'quizId': quizId,
      'userId': userId,
      'score': score,
      'totalQuestions': totalQuestions,
      'isPassed': isPassed,
      'startedAt': startedAt.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
    };
  }

  QuizAttempt toEntity() => QuizAttempt(
        id: id,
        quizId: quizId,
        userId: userId,
        score: score,
        totalQuestions: totalQuestions,
        isPassed: isPassed,
        startedAt: startedAt,
        completedAt: completedAt,
      );
}

class QuizQuestionModel extends QuizQuestion {
  const QuizQuestionModel({
    required super.id,
    required super.question,
    required super.options,
    super.correctAnswer,
    required super.points,
  });

  factory QuizQuestionModel.fromJson(Map<String, dynamic> json) {
    List<String> options = [];
    if (json['options'] != null) {
      options = (json['options'] as List).map((e) => e.toString()).toList();
    }

    return QuizQuestionModel(
      id: json['id']?.toString() ?? '',
      question: json['question'] ?? json['text'] ?? '',
      options: options,
      correctAnswer: json['correctAnswer'],
      points: json['points'] ?? json['score'] ?? 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question': question,
      'options': options,
      'correctAnswer': correctAnswer,
      'points': points,
    };
  }

  QuizQuestion toEntity() => QuizQuestion(
        id: id,
        question: question,
        options: options,
        correctAnswer: correctAnswer,
        points: points,
      );
}
