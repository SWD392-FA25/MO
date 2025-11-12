import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../repositories/ai_chat_repository.dart';

class ClearConversation extends UseCase<void, NoParams> {
  final AiChatRepository repository;

  ClearConversation(this.repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    return await repository.clearConversation();
  }
}
