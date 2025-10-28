import 'package:flutter/material.dart';
import '../../../../shared/widgets/app_scaffold.dart';

class LessonPage extends StatelessWidget {
  final String lessonId;
  const LessonPage({super.key, required this.lessonId});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Lesson',
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Lesson ID: $lessonId',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          const Text('This is a placeholder for lesson content.'),
          const SizedBox(height: 16),
          AspectRatio(
            aspectRatio: 16 / 9,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Icon(Icons.play_circle_fill, size: 64),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
