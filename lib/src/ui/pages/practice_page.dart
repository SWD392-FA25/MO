import 'package:flutter/material.dart';
import '../../data/mock_data.dart';
import '../widgets/app_scaffold.dart';

class PracticePage extends StatefulWidget {
  const PracticePage({super.key});

  @override
  State<PracticePage> createState() => _PracticePageState();
}

class _PracticePageState extends State<PracticePage> {
  final answers = <String, int>{};
  int? selectedIndexFor(String id) => answers[id];

  @override
  Widget build(BuildContext context) {
    final questions = MockData.quiz;
    return AppScaffold(
      title: 'Practice Quiz',
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ListView.separated(
              itemCount: questions.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final q = questions[index];
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Q${index + 1}. ${q.question}',
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 8),
                        for (int i = 0; i < q.options.length; i++)
                          RadioListTile<int>(
                            value: i,
                            groupValue: selectedIndexFor(q.id),
                            onChanged: (val) =>
                                setState(() => answers[q.id] = val!),
                            title: Text(q.options[i]),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                final correct = questions
                    .where((q) => answers[q.id] == q.correctIndex)
                    .length;
                final total = questions.length;
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text('Result'),
                    content: Text('You scored $correct / $total'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                );
              },
              child: const Text('Submit'),
            ),
          ),
        ],
      ),
    );
  }
}
