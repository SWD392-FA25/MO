import 'package:flutter/material.dart';

import '../../domain/entities/chat_message.dart';
import '../../domain/usecases/clear_conversation.dart';
import '../../domain/usecases/send_message.dart';
import '../../../../../core/usecases/usecase.dart';

class AiChatState {
  final List<ChatMessage> messages;
  final bool isLoading;
  final String? error;

  const AiChatState({
    this.messages = const [],
    this.isLoading = false,
    this.error,
  });

  AiChatState copyWith({
    List<ChatMessage>? messages,
    bool? isLoading,
    String? error,
  }) {
    return AiChatState(
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AiChatState &&
        other.isLoading == isLoading &&
        other.error == error &&
        _messagesEqual(other.messages);
  }

  bool _messagesEqual(List<ChatMessage> other) {
    if (messages.length != other.length) return false;
    for (int i = 0; i < messages.length; i++) {
      if (messages[i] != other[i]) return false;
    }
    return true;
  }

  @override
  int get hashCode {
    return isLoading.hashCode ^
        error.hashCode ^
        messages.hashCode;
  }
}

class AiChatProvider extends ChangeNotifier {
  final SendMessage sendMessageUseCase;
  final ClearConversation clearConversationUseCase;

  AiChatProvider({
    required this.sendMessageUseCase,
    required this.clearConversationUseCase,
  });

  AiChatState _state = const AiChatState();
  AiChatState get state => _state;

  void _setState(AiChatState newState) {
    _state = newState;
    notifyListeners();
  }

  void addMessage(ChatMessage message) {
    final updatedMessages = [..._state.messages, message];
    _setState(_state.copyWith(messages: updatedMessages));
  }

  Future<void> sendMessage(String messageText) async {
    if (messageText.trim().isEmpty) return;

    // Add user message
    final userMessage = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: messageText.trim(),
      type: MessageType.user,
    );
    addMessage(userMessage);

    // Add loading message
    addMessage(ChatMessage(
      id: 'loading',
      text: '',
      type: MessageType.loading,
    ));

    _setState(_state.copyWith(isLoading: true, error: null));

    final result = await sendMessageUseCase(
      SendMessageParams(message: messageText),
    );

    result.fold(
      (failure) {
        // Remove loading message
        final updatedMessages = _state.messages
            .where((message) => message.id != 'loading')
            .toList()
          ..add(ChatMessage(
            id: 'error',
            text: 'Sorry, something went wrong. Please try again.',
            type: MessageType.error,
          ));
        
        _setState(_state.copyWith(
         messages: updatedMessages,
          isLoading: false,
          error: failure.message,
        ));
      },
      (response) {
        // Replace loading message with AI response
        final updatedMessages = _state.messages
            .where((message) => message.id != 'loading')
            .toList()
          ..add(ChatMessage(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            text: response,
            type: MessageType.bot,
          ));

        _setState(_state.copyWith(
          messages: updatedMessages,
          isLoading: false,
        ));
      },
    );
  }

  Future<void> clearConversation() async {
    _setState(_state.copyWith(isLoading: true));

    final result = await clearConversationUseCase(NoParams());

    result.fold(
      (failure) {
        _setState(_state.copyWith(
          isLoading: false,
          error: failure.message,
        ));
      },
      (_) {
        _setState(const AiChatState());
      },
    );
  }

  void clearError() {
    if (_state.error != null) {
      _setState(_state.copyWith(error: null));
    }
  }
}
