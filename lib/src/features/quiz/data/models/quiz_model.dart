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
    super.questions,
    super.timeLimit,
    super.maxScore,
  });

  factory QuizModel.fromJson(Map<String, dynamic> json) {
    List<QuizQuestionModel>? questions;
    if (json['questions'] != null) {
      questions = (json['questions'] as List)
          .map((q) => QuizQuestionModel.fromJson(q as Map<String, dynamic>))
          .toList();
    }

    return QuizModel(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? json['name'] ?? '',
      description: json['description'],
      questionCount: json['questionCount'] ?? json['totalQuestions'] ?? 0,
      durationMinutes: json['durationMinutes'] ?? json['duration'] ?? 0,
      passingScore: json['passingScore'] ?? json['passScore'] ?? 0,
      isActive: json['isActive'] ?? json['active'] ?? true,
      questions: questions?.map((q) => q.toEntity()).toList(),
      timeLimit: json['timeLimit']?.toString(),
      maxScore: json['maxScore'],
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
      'questions': questions?.map((q) => QuizQuestionModel.fromEntity(q).toJson()).toList(),
      'timeLimit': timeLimit,
      'maxScore': maxScore,
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
        questions: questions,
        timeLimit: timeLimit,
        maxScore: maxScore,
      );

  static QuizModel fromEntity(Quiz entity) {
    return QuizModel(
      id: entity.id,
      title: entity.title,
      description: entity.description,
      questionCount: entity.questionCount,
      durationMinutes: entity.durationMinutes,
      passingScore: entity.passingScore,
      isActive: entity.isActive,
      questions: entity.questions?.map((q) => QuizQuestionModel.fromEntity(q)).toList(),
      timeLimit: entity.timeLimit,
      maxScore: entity.maxScore,
    );
  }
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
    required super.text,
    required super.options,
    super.correctAnswer,
    required super.points,
  });

  factory QuizQuestionModel.fromJson(Map<String, dynamic> json) {
    List<QuizQuestionOptionModel> options = [];
    if (json['options'] != null) {
      if (json['options'] is List) {
        final optionsList = json['options'] as List;
        if (optionsList.isNotEmpty && optionsList.first is String) {
          // Handle simple string array
          options = optionsList.asMap().entries.map((entry) {
            return QuizQuestionOptionModel(
              id: entry.key.toString(),
              text: entry.value.toString(),
            );
          }).toList();
        } else {
          // Handle object array
          options = optionsList
              .map((e) => QuizQuestionOptionModel.fromJson(e as Map<String, dynamic>))
              .cast<QuizQuestionOptionModel>()
              .toList();
        }
      }
    }

    return QuizQuestionModel(
      id: json['id']?.toString() ?? '',
      question: json['question'] ?? json['text'] ?? '',
      text: json['text'] ?? json['question'] ?? '',
      options: options.map((o) => o.toEntity()).toList(),
      correctAnswer: json['correctAnswer'],
      points: json['points'] ?? json['score'] ?? 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question': question,
      'text': text,
      'options': options.map((o) => QuizQuestionOptionModel.fromEntity(o).toJson()).toList(),
      'correctAnswer': correctAnswer,
      'points': points,
    };
  }

  QuizQuestion toEntity() => QuizQuestion(
        id: id,
        question: question,
        text: text,
        options: options.map((o) => QuizQuestionOption(id: o.id, text: o.text)).toList(),
        correctAnswer: correctAnswer,
        points: points,
      );

  static QuizQuestionModel fromEntity(QuizQuestion entity) {
    return QuizQuestionModel(
      id: entity.id,
      question: entity.question,
      text: entity.text,
      options: entity.options
          .map((o) => QuizQuestionOptionModel.fromEntity(o))
          .toList(),
      correctAnswer: entity.correctAnswer,
      points: entity.points,
    );
  }
}

class QuizQuestionOptionModel extends QuizQuestionOption {
  const QuizQuestionOptionModel({
    super.id,
    super.text,
  });

  factory QuizQuestionOptionModel.fromJson(Map<String, dynamic> json) {
    return QuizQuestionOptionModel(
      id: json['id']?.toString(),
      text: json['text']?.toString() ?? json['option']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
    };
  }

  QuizQuestionOption toEntity() => QuizQuestionOption(
        id: id,
        text: text,
      );

  static QuizQuestionOptionModel fromEntity(QuizQuestionOption entity) {
    return QuizQuestionOptionModel(
      id: entity.id,
      text: entity.text,
    );
  }
}
