import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../entities/quiz.dart';
import '../repositories/quiz_repository.dart';

class CreateQuizAttempt implements UseCase<QuizAttempt, String> {
  final QuizRepository repository;

  CreateQuizAttempt(this.repository);

  @override
  Future<Either<Failure, QuizAttempt>> call(String quizId) {
    return repository.createAttempt(quizId);
  }
}
