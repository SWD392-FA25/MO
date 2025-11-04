import 'package:flutter/material.dart';

import 'package:igcse_learning_hub/src/data/mock_data.dart';
import 'package:igcse_learning_hub/src/theme/design_tokens.dart';

class CourseCurriculumPage extends StatelessWidget {
  const CourseCurriculumPage({super.key, required this.courseId});

  final String courseId;

  @override
  Widget build(BuildContext context) {
    final detail = mockCourseDetails[courseId] ?? mockCourseDetails.values.first;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Curriculum'),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(20),
        itemCount: detail.curriculum.length,
        separatorBuilder: (_, __) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          final section = detail.curriculum[index];
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
                Text(
                  section.title,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 12),
                for (final lesson in section.lessons)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      children: [
                        const Icon(Icons.play_arrow_rounded,
                            color: AppColors.primary),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            lesson,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
