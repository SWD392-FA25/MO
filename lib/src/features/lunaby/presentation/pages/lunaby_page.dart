import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:igcse_learning_hub/src/theme/design_tokens.dart';
import '../../../ai_chat/presentation/providers/ai_chat_provider.dart';
import '../../../ai_chat/domain/entities/chat_message.dart';

class LunabyPage extends StatefulWidget {
  const LunabyPage({super.key});

  @override
  State<LunabyPage> createState() => _LunabyPageState();
}

class _LunabyPageState extends State<LunabyPage> {
  final _textController = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _sendMessage(String text) {
    if (text.trim().isEmpty) return;

    _textController.clear();
    FocusScope.of(context).unfocus();

    context.read<AiChatProvider>().sendMessage(text);
    _scrollToBottom();
  }

  void _sendSuggestion(String suggestion) {
    _textController.text = suggestion;
    _sendMessage(suggestion);
  }

  Widget _buildMessageBubble(ChatMessage message) {
    final isUser = message.type == MessageType.user;
    final isLoading = message.type == MessageType.loading;
    final isError = message.type == MessageType.error;

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 280),
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isError
                ? Colors.red[100]
                : isUser
                    ? AppColors.primary
                    : Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(20),
              topRight: const Radius.circular(20),
              bottomLeft: isUser
                  ? const Radius.circular(20)
                  : const Radius.circular(4),
              bottomRight: isUser
                  ? const Radius.circular(4)
                  : const Radius.circular(20),
            ),
            boxShadow: isUser
                ? null
                : const [
                    BoxShadow(
                      color: AppColors.cardShadow,
                      blurRadius: 16,
                      offset: Offset(0, 12),
                    ),
                  ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!isUser)
                Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.primary.withAlpha(20),
                      ),
                      child: const Icon(
                        Icons.auto_awesome,
                        color: AppColors.primary,
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Lunaby',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                    ),
                  ],
                ),
              if (!isUser) const SizedBox(height: 8),
              if (isLoading)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(
                    3,
                    (index) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2),
                      child: Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: AppColors.textSecondary,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                )
              else
                Text(
                  message.text,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: isUser ? Colors.white : AppColors.textPrimary,
                        height: 1.5,
                      ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primary.withAlpha(20),
            ),
            child: const Icon(
              Icons.auto_awesome,
              size: 40,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Xin chào! Mình là Lunaby',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              'Trợ lý AI của bạn. Hỏi mình về bất kỳ môn học IGCSE nào!',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Lunaby - Your AI Tutor'),
        actions: [
          Consumer<AiChatProvider>(
            builder: (context, provider, _) {
              return IconButton(
                onPressed: provider.state.messages.isEmpty
                    ? null
                    : () => _showClearDialog(context, provider),
                icon: const Icon(Icons.delete_outline),
                tooltip: 'Clear conversation',
              );
            },
          ),
        ],
      ),
      body: Consumer<AiChatProvider>(
        builder: (context, provider, _) {
          _scrollToBottom();

          return Column(
            children: [
              // Error display
              if (provider.state.error != null)
                Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red[50],
                    border: Border.all(color: Colors.red[200]!),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.error_outline, color: Colors.red[600], size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          provider.state.error!,
                          style: TextStyle(
                            color: Colors.red[600],
                            fontSize: 14,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: provider.clearError,
                        icon: const Icon(Icons.close, size: 18),
                        color: Colors.red[600],
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                ),

              // Messages
              Expanded(
                child: provider.state.messages.isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.all(20),
                        itemCount: provider.state.messages.length,
                        itemBuilder: (context, index) {
                          return _buildMessageBubble(provider.state.messages[index]);
                        },
                      ),
              ),

              // Suggestion chips (only show when empty)
              if (provider.state.messages.isEmpty)
                _SuggestionChips(onSuggestionTap: _sendSuggestion),

              const SizedBox(height: 12),

              // Input area
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _textController,
                        textCapitalization: TextCapitalization.sentences,
                        decoration: InputDecoration(
                          hintText: 'Hỏi Lunaby về môn học của bạn...',
                          suffixIcon: IconButton(
                            onPressed: provider.state.isLoading ||
                                    _textController.text.trim().isEmpty
                                ? null
                                : () => _sendMessage(_textController.text),
                            icon: provider.state.isLoading
                                ? SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: AppColors.primary,
                                    ),
                                  )
                                : const Icon(Icons.send_rounded),
                          ),
                        ),
                        onSubmitted: (_) => _sendMessage(_textController.text),
                        onChanged: (_) => setState(() {}),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showClearDialog(BuildContext context, AiChatProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xóa cuộc trò chuyện'),
        content: const Text('Bạn có chắc muốn xóa toàn bộ cuộc trò chuyện?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              provider.clearConversation();
              _textController.clear();
            },
            child: const Text('Xóa'),
          ),
        ],
      ),
    );
  }
}

class _SuggestionChips extends StatelessWidget {
  final Function(String) onSuggestionTap;

  const _SuggestionChips({required this.onSuggestionTap});

  @override
  Widget build(BuildContext context) {
    final suggestions = [
      'Viết kế hoạch ôn thi Toán',
      'Giải thích định luật Hooke',
      'Tạo quiz 10 câu về Biology',
    ];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          for (final suggestion in suggestions)
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: ActionChip(
                label: Text(suggestion),
                onPressed: () => onSuggestionTap(suggestion),
              ),
            ),
        ],
      ),
    );
  }
}
