import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:igcse_learning_hub/src/theme/design_tokens.dart';

class CourseReviewsPage extends StatelessWidget {
  const CourseReviewsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final reviews = _mockReviews;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Đánh giá khoá học'),
        actions: [
          TextButton(
            onPressed: () => context.push('/courses/reviews/write'),
            child: const Text('Viết đánh giá'),
          ),
        ],
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(20),
        itemCount: reviews.length,
        separatorBuilder: (_, __) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          final review = reviews[index];
          return Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: AppColors.primary.withAlpha(26),
                      child: Text(review.reviewer[0]),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          review.reviewer,
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                        Row(
                          children: [
                            for (var i = 0; i < 5; i++)
                              Icon(
                                i < review.rating
                                    ? Icons.star_rounded
                                    : Icons.star_border_rounded,
                                color: const Color(0xFFFFC53D),
                                size: 18,
                              ),
                          ],
                        ),
                      ],
                    ),
                    const Spacer(),
                    Text(
                      review.date,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  review.comment,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(height: 1.5),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/courses/reviews/write'),
        icon: const Icon(Icons.edit_rounded),
        label: const Text('Viết đánh giá'),
      ),
    );
  }
}

class CourseWriteReviewPage extends StatefulWidget {
  const CourseWriteReviewPage({super.key});

  @override
  State<CourseWriteReviewPage> createState() => _CourseWriteReviewPageState();
}

class _CourseWriteReviewPageState extends State<CourseWriteReviewPage> {
  int _rating = 4;
  final _reviewController = TextEditingController();

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Viết đánh giá'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Chấm điểm'),
            const SizedBox(height: 12),
            Row(
              children: [
                for (var i = 1; i <= 5; i++)
                  IconButton(
                    onPressed: () => setState(() => _rating = i),
                    icon: Icon(
                      i <= _rating ? Icons.star_rounded : Icons.star_border_rounded,
                      color: const Color(0xFFFFC53D),
                      size: 32,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _reviewController,
              minLines: 5,
              maxLines: 6,
              decoration: const InputDecoration(
                hintText: 'Chia sẻ trải nghiệm của bạn...',
              ),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Cảm ơn bạn đã đánh giá!')),
                );
                if (context.canPop()) {
                  context.pop();
                }
              },
              child: const Text('Gửi đánh giá'),
            ),
          ],
        ),
      ),
    );
  }
}

class _Review {
  const _Review({
    required this.reviewer,
    required this.date,
    required this.rating,
    required this.comment,
  });

  final String reviewer;
  final String date;
  final int rating;
  final String comment;
}

const _mockReviews = [
  _Review(
    reviewer: 'Ethan Barker',
    date: '2 days ago',
    rating: 5,
    comment: 'Khoá học rất thực tế, phần dự án cuối có feedback chi tiết. Mình thích cách giảng viên hướng dẫn về workflow với khách hàng.',
  ),
  _Review(
    reviewer: 'Mira Chen',
    date: '1 week ago',
    rating: 4,
    comment: 'Nội dung cập nhật theo trend mới. Tuy nhiên mình mong có thêm phần tài nguyên về UI motion.',
  ),
];
