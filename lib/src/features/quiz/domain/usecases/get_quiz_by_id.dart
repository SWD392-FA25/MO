import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../entities/quiz.dart';
import '../repositories/quiz_repository.dart';

class GetQuizById implements UseCase<Quiz, String> {
  final QuizRepository repository;

  GetQuizById(this.repository);

  @override
  Future<Either<Failure, Quiz>> call(String quizId) {
    return repository.getQuizById(quizId);
  }
}
