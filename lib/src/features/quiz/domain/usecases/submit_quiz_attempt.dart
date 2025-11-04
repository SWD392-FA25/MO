import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../entities/quiz.dart';
import '../repositories/quiz_repository.dart';

class SubmitQuizAttempt implements UseCase<QuizAttempt, SubmitQuizParams> {
  final QuizRepository repository;

  SubmitQuizAttempt(this.repository);

  @override
  Future<Either<Failure, QuizAttempt>> call(SubmitQuizParams params) {
    return repository.submitAttempt(
      quizId: params.quizId,
      attemptId: params.attemptId,
      answers: params.answers,
    );
  }
}

class SubmitQuizParams {
  final String quizId;
  final String attemptId;
  final Map<String, String> answers;

  SubmitQuizParams({
    required this.quizId,
    required this.attemptId,
    required this.answers,
  });
}
