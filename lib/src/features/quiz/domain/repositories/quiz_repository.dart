import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../entities/quiz.dart';

abstract class QuizRepository {
  Future<Either<Failure, Quiz>> getQuizForTake(String quizId);

  Future<Either<Failure, QuizAttempt>> createAttempt(String quizId);

  Future<Either<Failure, QuizAttempt>> submitAttempt({
    required String quizId,
    required String attemptId,
    required Map<String, String> answers,
  });

  Future<Either<Failure, QuizAttempt>> getAttempt({
    required String quizId,
    required String attemptId,
  });

  Future<Either<Failure, List<QuizAttempt>>> getMyAttempts();
}
