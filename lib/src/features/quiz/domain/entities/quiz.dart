import 'package:equatable/equatable.dart';

class Quiz extends Equatable {
  final String id;
  final String title;
  final String? description;
  final int questionCount;
  final int durationMinutes;
  final int passingScore;
  final bool isActive;
  final List<QuizQuestion>? questions;
  final String? timeLimit;
  final int? maxScore;

  const Quiz({
    required this.id,
    required this.title,
    this.description,
    required this.questionCount,
    required this.durationMinutes,
    required this.passingScore,
    this.isActive = true,
    this.questions,
    this.timeLimit,
    this.maxScore,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        questionCount,
        durationMinutes,
        passingScore,
        isActive,
        questions,
        timeLimit,
        maxScore,
      ];
}

class QuizAttempt extends Equatable {
  final String id;
  final String quizId;
  final String userId;
  final int score;
  final int totalQuestions;
  final bool isPassed;
  final DateTime startedAt;
  final DateTime? completedAt;

  const QuizAttempt({
    required this.id,
    required this.quizId,
    required this.userId,
    required this.score,
    required this.totalQuestions,
    required this.isPassed,
    required this.startedAt,
    this.completedAt,
  });

  @override
  List<Object?> get props => [
        id,
        quizId,
        userId,
        score,
        totalQuestions,
        isPassed,
        startedAt,
        completedAt,
      ];
}

class QuizQuestion extends Equatable {
  final String id;
  final String question;
  final String text; // Renamed from question to text
  final List<QuizQuestionOption> options;
  final String? correctAnswer;
  final int points;

  const QuizQuestion({
    required this.id,
    required this.question,
    required this.text,
    required this.options,
    this.correctAnswer,
    required this.points,
  });

  @override
  List<Object?> get props => [id, question, text, options, correctAnswer, points];
}

class QuizQuestionOption extends Equatable {
  final String? id;
  final String? text;

  const QuizQuestionOption({
    this.id,
    this.text,
  });

  @override
  List<Object?> get props => [id, text];
}
