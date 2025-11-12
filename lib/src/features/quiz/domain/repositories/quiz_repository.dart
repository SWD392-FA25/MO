import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../entities/quiz.dart';

abstract class QuizRepository {
  Future<Either<Failure, List<Quiz>>> getQuizzes();
  
  Future<Either<Failure, Quiz>> getQuizById(String quizId);
  
  Future<Either<Failure, List<Quiz>>> getStudentAssignments();

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
