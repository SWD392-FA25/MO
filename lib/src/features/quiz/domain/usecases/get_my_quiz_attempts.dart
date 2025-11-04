import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../entities/quiz.dart';
import '../repositories/quiz_repository.dart';

class GetMyQuizAttempts implements UseCase<List<QuizAttempt>, NoParams> {
  final QuizRepository repository;

  GetMyQuizAttempts(this.repository);

  @override
  Future<Either<Failure, List<QuizAttempt>>> call(NoParams params) {
    return repository.getMyAttempts();
  }
}
