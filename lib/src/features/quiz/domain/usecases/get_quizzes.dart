import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../entities/quiz.dart';
import '../repositories/quiz_repository.dart';

class GetQuizzes implements UseCase<List<Quiz>, NoParams> {
  final QuizRepository repository;

  GetQuizzes(this.repository);

  @override
  Future<Either<Failure, List<Quiz>>> call(NoParams params) {
    return repository.getQuizzes();
  }
}
