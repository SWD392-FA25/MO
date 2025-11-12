import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../providers/quiz_provider.dart';
import '../../../../theme/design_tokens.dart';

class QuizPage extends StatefulWidget {
  const QuizPage({
    super.key,
    required this.quizId,
    this.lessonId,
  });

  final String quizId;
  final String? lessonId;

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<QuizProvider>().loadQuiz(widget.quizId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Bài kiểm tra'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: Consumer<QuizProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppColors.primary,
              ),
            );
          }

          if (provider.errorMessage != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 64,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    provider.errorMessage!,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.pop(),
                    child: const Text('Quay lại'),
                  ),
                ],
              ),
            );
          }

          if (provider.currentQuiz == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.quiz_outlined,
                    size: 64,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Không tìm thấy bài kiểm tra',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.pop(),
                    child: const Text('Quay lại'),
                  ),
                ],
              ),
            );
          }

          final quiz = provider.currentQuiz!;
          
          if (provider.currentAttempt == null) {
            return _QuizStartView(
              quiz: quiz,
              onStart: () async {
                final attempt = await provider.startQuiz(widget.quizId);
                if (attempt != null) {
                  // Successfully started quiz
                }
              },
              isStarting: provider.isLoading,
            );
          }

          return _QuizAttemptView(
            quiz: quiz,
            attempt: provider.currentAttempt!,
          );
        },
      ),
    );
  }
}

class _QuizStartView extends StatelessWidget {
  const _QuizStartView({
    required this.quiz,
    required this.onStart,
    required this.isStarting,
  });

  final quiz;
  final VoidCallback onStart;
  final bool isStarting;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Quiz Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: const [
                BoxShadow(
                  color: AppColors.cardShadow,
                  offset: Offset(0, 10),
                  blurRadius: 24,
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
                        color: AppColors.primary.withAlpha(24),
                      ),
                      child: const Icon(
                        Icons.quiz,
                        color: AppColors.primary,
                        size: 32,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            quiz.title ?? 'Bài kiểm tra',
                            style: textTheme.titleMedium,
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: AppColors.primary.withAlpha(24),
                                ),
                                child: Text(
                                  '${quiz.questions?.length ?? 0} câu hỏi',
                                  style: textTheme.bodySmall?.copyWith(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                if (quiz.description != null) ...[
                  const SizedBox(height: 16),
                  Text(
                    quiz.description!,
                    style: textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                      height: 1.5,
                    ),
                  ),
                ],
              ],
            ),
          ),
          
          const SizedBox(height: 24),

          // Quiz Instructions
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: const [
                BoxShadow(
                  color: AppColors.cardShadow,
                  offset: Offset(0, 10),
                  blurRadius: 24,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hướng dẫn',
                  style: textTheme.titleMedium,
                ),
                const SizedBox(height: 16),
                _buildInstructionItem(textTheme, '• Đọc kỹ từng câu hỏi trước khi trả lời'),
                _buildInstructionItem(textTheme, '• Mỗi câu hỏi chỉ có một đáp án đúng'),
                _buildInstructionItem(textTheme, '• Bạn có thể thay đổi đáp án trước khi nộp bài'),
                _buildInstructionItem(textTheme, '• Thời gian làm bài: ${quiz.timeLimit ?? 'Không giới hạn'}'),
                if (quiz.maxScore != null) ...[
                  _buildInstructionItem(textTheme, '• Điểm tối đa: ${quiz.maxScore} điểm'),
                ],
              ],
            ),
          ),

          const SizedBox(height: 32),

          // Start Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: isStarting ? null : onStart,
              icon: isStarting
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.play_arrow),
              label: Text(isStarting ? 'Đang tải...' : 'Bắt đầu làm bài'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInstructionItem(TextTheme textTheme, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: textTheme.bodyMedium?.copyWith(
          color: AppColors.textSecondary,
        ),
      ),
    );
  }
}

class _QuizAttemptView extends StatefulWidget {
  const _QuizAttemptView({
    required this.quiz,
    required this.attempt,
  });

  final quiz;
  final attempt;

  @override
  State<_QuizAttemptView> createState() => _QuizAttemptViewState();
}

class _QuizAttemptViewState extends State<_QuizAttemptView> {
  final PageController _pageController = PageController();
  int _currentQuestionIndex = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.read<QuizProvider>();
    final questions = widget.quiz.questions ?? [];
    
    if (questions.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.quiz_outlined,
              size: 64,
              color: AppColors.textSecondary,
            ),
            const SizedBox(height: 16),
            Text(
              'Không có câu hỏi nào trong bài kiểm tra',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        // Progress Bar
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          color: Colors.white,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Câu ${_currentQuestionIndex + 1}/${questions.length}',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  if (widget.quiz.timeLimit != null)
                    Row(
                      children: [
                        const Icon(Icons.schedule, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          widget.quiz.timeLimit!,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                ],
              ),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: (_currentQuestionIndex + 1) / questions.length,
                backgroundColor: AppColors.background,
                valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
              ),
            ],
          ),
        ),
        
        // Questions
        Expanded(
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentQuestionIndex = index;
              });
            },
            itemCount: questions.length,
            itemBuilder: (context, index) {
              return _QuestionView(
                question: questions[index],
                questionNumber: index + 1,
                onAnswerChanged: (answer) {
                  provider.setAnswer(questions[index].id ?? '', answer);
                },
              );
            },
          ),
        ),
        
        // Navigation Buttons
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          color: Colors.white,
          child: Row(
            children: [
              if (_currentQuestionIndex > 0)
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      _pageController.previousPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                    child: const Text('Câu trước'),
                  ),
                ),
              if (_currentQuestionIndex > 0) const SizedBox(width: 12),
              if (_currentQuestionIndex < questions.length - 1)
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                    child: const Text('Câu tiếp theo'),
                  ),
                )
              else
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: provider.isLoading ? null : () async {
                      final success = await provider.submitQuiz(
                        widget.quiz.id ?? '',
                        widget.attempt.id ?? '',
                      );
                      if (success != null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Nộp bài thành công!'),
                            backgroundColor: Colors.green,
                          ),
                        );
                        context.pop();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(provider.errorMessage ?? 'Không thể nộp bài'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                    icon: provider.isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.send),
                    label: Text(provider.isLoading ? 'Đang nộp...' : 'Nộp bài'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _QuestionView extends StatefulWidget {
  const _QuestionView({
    required this.question,
    required this.questionNumber,
    required this.onAnswerChanged,
  });

  final question;
  final int questionNumber;
  final ValueChanged<String> onAnswerChanged;

  @override
  State<_QuestionView> createState() => _QuestionViewState();
}

class _QuestionViewState extends State<_QuestionView> {
  String? _selectedAnswer;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final options = widget.question.options ?? [];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Question Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: const [
                BoxShadow(
                  color: AppColors.cardShadow,
                  offset: Offset(0, 10),
                  blurRadius: 24,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Câu ${widget.questionNumber}',
                  style: textTheme.titleSmall?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  widget.question.text ?? '',
                  style: textTheme.titleMedium,
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Options
          ...options.map((option) {
            final optionId = option.id ?? '';
            final isSelected = _selectedAnswer == optionId;
            
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: isSelected
                      ? Border.all(color: AppColors.primary, width: 2)
                      : Border.all(color: AppColors.border),
                  boxShadow: [
                    BoxShadow(
                      color: isSelected
                          ? AppColors.primary.withAlpha(24)
                          : AppColors.cardShadow,
                      offset: const Offset(0, 4),
                      blurRadius: 12,
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () {
                      setState(() {
                        _selectedAnswer = optionId;
                      });
                      widget.onAnswerChanged(optionId);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Icon(
                            isSelected
                                ? Icons.radio_button_checked
                                : Icons.radio_button_unchecked,
                            color: isSelected ? AppColors.primary : AppColors.textSecondary,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              option.text ?? '',
                              style: textTheme.bodyMedium?.copyWith(
                                color: isSelected ? AppColors.primary : null,
                                fontWeight: isSelected ? FontWeight.w600 : null,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
          
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
