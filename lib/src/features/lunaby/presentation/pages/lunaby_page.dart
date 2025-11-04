import 'package:flutter/material.dart';

import 'package:igcse_learning_hub/src/theme/design_tokens.dart';

class LunabyPage extends StatelessWidget {
  const LunabyPage({super.key});

  @override
  Widget build(BuildContext context) {
    final messages = _mockMessages;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Lunaby - Your AI Tutor'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.history),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                final isUser = message.role == 'user';
                return Align(
                  alignment:
                      isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 280),
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isUser
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
                                  // TODO: Thay avatar Lunaby bằng SVG từ Figma.
                                  child: const Icon(
                                    Icons.auto_awesome,
                                    color: AppColors.primary,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Lunaby',
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelMedium
                                      ?.copyWith(
                                        color: AppColors.textSecondary,
                                      ),
                                ),
                              ],
                            ),
                          if (!isUser) const SizedBox(height: 8),
                          Text(
                            message.content,
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
              },
            ),
          ),
          const _SuggestionChips(),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
            child: Row(
              children: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.mic_none_rounded),
                ),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Hỏi Lunaby về môn học của bạn...',
                      suffixIcon: IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.send_rounded),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SuggestionChips extends StatelessWidget {
  const _SuggestionChips();

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
                onPressed: () {},
              ),
            ),
        ],
      ),
    );
  }
}

class _Message {
  const _Message({required this.role, required this.content});

  final String role;
  final String content;
}

const _mockMessages = [
  _Message(role: 'assistant', content: 'Xin chào! Mình là Lunaby, trợ lý AI của bạn. Bạn muốn học gì trong hôm nay?'),
  _Message(role: 'user', content: 'Mình cần ôn lại phần Probability trong Toán.'),
  _Message(role: 'assistant', content: 'Tuyệt vời! Mình sẽ đề xuất một lộ trình 3 bước: \n1. Ôn lại khái niệm cơ bản và công thức.\n2. Giải các bài tập từ dễ tới khó.\n3. Làm thử quiz tổng hợp 15 câu.\n\nBạn muốn bắt đầu với phần nào?'),
];
