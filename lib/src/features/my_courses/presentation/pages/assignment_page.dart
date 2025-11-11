import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../domain/entities/assignment.dart';
import '../providers/assignment_provider.dart';
import '../../../../theme/design_tokens.dart';

class AssignmentPage extends StatefulWidget {
  const AssignmentPage({
    super.key,
    required this.courseId,
    required this.lessonId,
    required this.assignmentId,
  });

  final String courseId;
  final String lessonId;
  final String assignmentId;

  @override
  State<AssignmentPage> createState() => _AssignmentPageState();
}

class _AssignmentPageState extends State<AssignmentPage> {
  final TextEditingController _textController = TextEditingController();
  File? _selectedFile;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Bài tập'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: FutureBuilder<Assignment?>(
        future: _loadAssignment(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppColors.primary,
              ),
            );
          }

          if (snapshot.hasError) {
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
                    'Đã có lỗi xảy ra: ${snapshot.error}',
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

          if (!snapshot.hasData) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.assignment_outlined,
                    size: 64,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Không tìm thấy bài tập',
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

          final assignment = snapshot.data!;
          return _AssignmentContent(
            assignment: assignment,
            textController: _textController,
            selectedFile: _selectedFile,
            isSubmitting: _isSubmitting,
            onFileSelected: (file) => setState(() => _selectedFile = file),
            onSubmit: _submitAssignment,
          );
        },
      ),
    );
  }

  Future<Assignment?> _loadAssignment() async {
    // TODO: Load assignment details from API
    // For now, return mock assignment
    await Future.delayed(const Duration(seconds: 1));
    return Assignment(
      id: widget.assignmentId,
      title: 'Bài tập về Flutter',
      description: 'Hoàn thành ứng dụng todo-list sử dụng Flutter và Provider',
      dueDate: DateTime.now().add(const Duration(days: 7)),
      maxScore: 100,
    );
  }

  Future<void> _submitAssignment() async {
    if (_textController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng nhập nội dung bài làm'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      // Submit to actual API
      final success = await context.read<AssignmentProvider>().submitAssignment(
        assignmentId: widget.assignmentId,
        content: _textController.text.trim(),
        fileUrl: _selectedFile?.path,
      );

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Đã nộp bài thành công!'),
            backgroundColor: Colors.green,
          ),
        );
        context.pop();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Không thể nộp bài, vui lòng thử lại'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Lỗi: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _isSubmitting = false);
    }
  }
}

class _AssignmentContent extends StatelessWidget {
  const _AssignmentContent({
    required this.assignment,
    required this.textController,
    required this.selectedFile,
    required this.isSubmitting,
    required this.onFileSelected,
    required this.onSubmit,
  });

  final Assignment assignment;
  final TextEditingController textController;
  final File? selectedFile;
  final bool isSubmitting;
  final Function(File) onFileSelected;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Assignment Header
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
                        Icons.assignment,
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
                            assignment.title,
                            style: textTheme.titleMedium,
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: assignment.isSubmitted
                                  ? Colors.green.withAlpha(24)
                                  : AppColors.primary.withAlpha(24),
                            ),
                            child: Text(
                              assignment.isSubmitted ? 'Đã nộp' : 'Chưa nộp',
                              style: textTheme.bodySmall?.copyWith(
                                color: assignment.isSubmitted
                                    ? Colors.green
                                    : AppColors.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  assignment.description,
                  style: textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Icon(
                      Icons.schedule,
                      size: 20,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Hạn chót: ${_formatDate(assignment.dueDate)}',
                      style: textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      'Điểm tối đa: ${assignment.maxScore}',
                      style: textTheme.bodySmall?.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Submission Form
          if (!assignment.isSubmitted)
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
                    'Nộp bài',
                    style: textTheme.titleMedium,
                  ),
                  const SizedBox(height: 16),
                  
                  // Text Input
                  TextField(
                    controller: textController,
                    maxLines: 6,
                    decoration: const InputDecoration(
                      hintText: 'Nhập nội dung bài làm tại đây...',
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: AppColors.primary),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // File Upload
                  GestureDetector(
                    onTap: () {
                      // TODO: Implement file picker
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Chức năng chọn file sẽ được triển khai sau')),
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.border),
                        borderRadius: BorderRadius.circular(12),
                        color: AppColors.background,
                      ),
                      child: Column(
                        children: [
                          Icon(
                            selectedFile != null
                                ? Icons.file_present
                                : Icons.cloud_upload,
                            size: 32,
                            color: AppColors.primary,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            selectedFile != null
                                ? 'Đã chọn: ${selectedFile!.path.split('/').last}'
                                : 'Chọn file đính kèm (tùy chọn)',
                            style: textTheme.bodyMedium,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Submit Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: isSubmitting ? null : onSubmit,
                      icon: isSubmitting
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(Icons.send),
                      label: Text(isSubmitting ? 'Đang nộp bài...' : 'Nộp bài'),
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
            )
          else
            _SubmissionsView(assignmentId: assignment.id),

          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _SubmissionsView extends StatefulWidget {
  const _SubmissionsView({
    required this.assignmentId,
  });

  final String assignmentId;

  @override
  State<_SubmissionsView> createState() => _SubmissionsViewState();
}

class _SubmissionsViewState extends State<_SubmissionsView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AssignmentProvider>().loadSubmissions(widget.assignmentId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    
    return Consumer<AssignmentProvider>(
      builder: (context, provider, _) {
        return Container(
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Bài đã nộp',
                    style: textTheme.titleMedium,
                  ),
                  if (provider.isLoading)
                    const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.primary,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 16),
              
              if (provider.submissions.isEmpty && !provider.isLoading)
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Center(
                    child: Text(
                      'Chưa có bài nào được nộp',
                      style: textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                )
              else
                ...provider.submissions.map(
                  (submission) => Column(
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.background,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  submission.isGraded ? Icons.grade : Icons.check_circle,
                                  color: submission.isGraded ? Colors.amber : Colors.green,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  submission.isGraded ? 'Đã chấm điểm' : 'Đã nộp bài',
                                  style: textTheme.titleSmall?.copyWith(
                                    color: submission.isGraded ? Colors.amber : Colors.green,
                                  ),
                                ),
                                if (submission.score != null) ...[
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.amber.withAlpha(24),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      '${submission.score} điểm',
                                      style: textTheme.bodySmall?.copyWith(
                                        color: Colors.amber,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              submission.content,
                              style: textTheme.bodyMedium?.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Thời gian: ${submission.submittedAt.toString().substring(0, 19)}',
                              style: textTheme.bodySmall?.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                            if (submission.feedback != null && submission.feedback!.isNotEmpty) ...[
                              const SizedBox(height: 8),
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.amber.withAlpha(24),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Phản hồi từ giảng viên:',
                                      style: textTheme.bodySmall?.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.amber.shade800,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      submission.feedback!,
                                      style: textTheme.bodySmall?.copyWith(
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

String _formatDate(DateTime date) {
  return '${date.day}/${date.month}/${date.year}';
}
