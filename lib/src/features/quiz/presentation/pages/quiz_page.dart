import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:igcse_learning_hub/src/theme/design_tokens.dart';

class QuizPage extends StatelessWidget {
  const QuizPage({super.key});

  @override
  Widget build(BuildContext context) {
    final quizes = _mockQuizzes;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Quiz luyện tập'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.filter_list_rounded),
          ),
        ],
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(20),
        itemCount: quizes.length,
        separatorBuilder: (_, __) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          final quiz = quizes[index];
          return Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: const [
                BoxShadow(
                  color: AppColors.cardShadow,
                  blurRadius: 18,
                  offset: Offset(0, 12),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        color: AppColors.primary.withAlpha(18),
                      ),
                      child: const Icon(
                        Icons.quiz_rounded,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            quiz.title,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            '${quiz.questionCount} câu hỏi • Giới hạn ${quiz.duration} phút',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    TextButton.icon(
                      onPressed: () => context.push('/quiz/detail?quiz=${quiz.id}'),
                      icon: const Icon(Icons.visibility_outlined),
                      label: const Text('Xem chi tiết'),
                    ),
                    const Spacer(),
                    ElevatedButton(
                      onPressed: () => context.push('/quiz/detail?quiz=${quiz.id}'),
                      child: const Text('Bắt đầu'),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class QuizDetailPage extends StatelessWidget {
  const QuizDetailPage({super.key, required this.quizId});

  final String quizId;

  @override
  Widget build(BuildContext context) {
    final quiz = _mockQuizzes.firstWhere(
      (element) => element.id == quizId,
      orElse: () => _mockQuizzes.first,
    );
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Quiz Detail'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    quiz.title,
                    style: textTheme.titleLarge,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(Icons.timer_outlined, color: AppColors.primary),
                      const SizedBox(width: 8),
                      Text(
                        '${quiz.duration} phút',
                        style: textTheme.bodyMedium,
                      ),
                      const SizedBox(width: 16),
                      const Icon(Icons.help_outline_rounded,
                          color: AppColors.primary),
                      const SizedBox(width: 8),
                      Text(
                        '${quiz.questionCount} câu hỏi',
                        style: textTheme.bodyMedium,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Mô tả',
                    style: textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    quiz.description,
                    style: textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: ListView.separated(
                itemCount: quiz.sampleQuestions.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final question = quiz.sampleQuestions[index];
                  return Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: AppColors.primary.withAlpha(30),
                          child: Text('${index + 1}'),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            question,
                            style: textTheme.bodyMedium,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Chức năng quiz trực tuyến sẽ được bổ sung sau khi kết nối backend.',
                    ),
                  ),
                );
              },
              child: const Text('Bắt đầu làm quiz'),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuizInfo {
  const _QuizInfo({
    required this.id,
    required this.title,
    required this.questionCount,
    required this.duration,
    required this.description,
    required this.sampleQuestions,
  });

  final String id;
  final String title;
  final int questionCount;
  final int duration;
  final String description;
  final List<String> sampleQuestions;
}

const _mockQuizzes = [
  _QuizInfo(
    id: 'quiz-1',
    title: 'Graphic Design Mastery',
    questionCount: 20,
    duration: 25,
    description:
        'Quiz ôn tập các kiến thức về bố cục, màu sắc, typography dựa trên khoá Graphic Design Advanced.',
    sampleQuestions: [
      'Nguyên tắc 60-30-10 áp dụng thế nào trong phối màu?',
      'Phân biệt serif và sans-serif trong ứng dụng brand.',
      'Các bước quan trọng khi xây dựng moodboard.',
    ],
  ),
  _QuizInfo(
    id: 'quiz-2',
    title: 'Web Developer Concepts',
    questionCount: 25,
    duration: 30,
    description:
        'Quiz tổng hợp kiến thức front-end và back-end trong lộ trình Web Developer Concepts.',
    sampleQuestions: [
      'Các pattern quản lý state phổ biến trong Flutter.',
      'So sánh REST và GraphQL.',
      'Những bước kiểm thử trước khi deploy production.',
    ],
  ),
];
