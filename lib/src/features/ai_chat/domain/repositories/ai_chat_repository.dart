import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../entities/chat_message.dart';

abstract class AiChatRepository {
  Future<Either<Failure, String>> sendMessage(String message);
  Future<Either<Failure, void>> clearConversation();
}
