import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../entities/quiz.dart';
import '../repositories/quiz_repository.dart';

class GetQuizForTake implements UseCase<Quiz, String> {
  final QuizRepository repository;

  GetQuizForTake(this.repository);

  @override
  Future<Either<Failure, Quiz>> call(String quizId) {
    return repository.getQuizForTake(quizId);
  }
}
