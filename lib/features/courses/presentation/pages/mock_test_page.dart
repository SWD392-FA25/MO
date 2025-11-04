import 'dart:async';
import 'package:flutter/material.dart';
import '../../../../core/widgets/app_scaffold.dart';

class MockTestPage extends StatefulWidget {
  const MockTestPage({super.key});

  @override
  State<MockTestPage> createState() => _MockTestPageState();
}

class _MockTestPageState extends State<MockTestPage> {
  late Timer _timer;
  int _remainingSeconds = 20 * 60; // 20 minutes demo

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds == 0) {
        timer.cancel();
      } else {
        setState(() => _remainingSeconds--);
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String get _formattedTime {
    final m = (_remainingSeconds ~/ 60).toString().padLeft(2, '0');
    final s = (_remainingSeconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Mock Test',
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: Chip(label: Text(_formattedTime)),
        ),
      ],
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'This is a demo mock test. Timer counts down from 20 minutes.',
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: 10,
              itemBuilder: (_, i) => Card(
                child: ListTile(title: Text('Question ${i + 1} placeholder')),
              ),
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Submitted mock test.')),
                );
              },
              child: const Text('Submit Test'),
            ),
          ),
        ],
      ),
    );
  }
}
