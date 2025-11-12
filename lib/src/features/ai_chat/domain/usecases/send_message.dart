import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../repositories/ai_chat_repository.dart';

class SendMessage extends UseCase<String, SendMessageParams> {
  final AiChatRepository repository;

  SendMessage(this.repository);

  @override
  Future<Either<Failure, String>> call(SendMessageParams params) async {
    return await repository.sendMessage(params.message);
  }
}

class SendMessageParams extends Equatable {
  final String message;

  const SendMessageParams({required this.message});

  @override
  List<Object?> get props => [message];
}
