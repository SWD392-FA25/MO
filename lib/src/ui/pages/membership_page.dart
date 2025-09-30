import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../data/mock_data.dart';
import '../widgets/app_scaffold.dart';

class MembershipPage extends StatelessWidget {
  const MembershipPage({super.key});

  @override
  Widget build(BuildContext context) {
    final plans = MockData.plans;
    return AppScaffold(
      title: 'Membership',
      body: LayoutBuilder(
        builder: (context, cons) {
          final isWide = cons.maxWidth > 900;
          return GridView.count(
            crossAxisCount: isWide ? 3 : 1,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: isWide ? 0.9 : 1.6,
            children: plans
                .map((p) => _PlanCard(name: p.name, features: p.features))
                .toList(),
          );
        },
      ),
    );
  }
}

class _PlanCard extends StatelessWidget {
  final String name;
  final List<String> features;
  const _PlanCard({required this.name, required this.features});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(name, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            ...features.map(
              (f) => Row(
                children: [
                  const Icon(Icons.check, size: 16, color: Colors.green),
                  const SizedBox(width: 8),
                  Expanded(child: Text(f)),
                ],
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => context.go('/payment'),
                child: const Text('Upgrade'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
