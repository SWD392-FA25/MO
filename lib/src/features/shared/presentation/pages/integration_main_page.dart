import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../presentation/widgets/my_learning_bottom_nav.dart';
import '../../theme/app_theme.dart';

class IntegrationMainPage extends StatelessWidget {
  const IntegrationMainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FF),
      appBar: AppBar(
        title: const Text('IGCSE Learning Hub'),
        backgroundColor: Colors.white,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(
              Icons.school,
              size: 64,
              color: Color(0xFF4C1DE6),
            ),
            const SizedBox(height: 16),
            const Text(
              'Chào mừng đến với IGCSE Learning Hub!',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1B1F3B),
              ),
            ),
            const SizedBox(height: 32),
            Text(
              'Sử dụng bottom navigation để khám phá các tính năng',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF6F7492),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            MyLearningBottomNav(),
          ],
        ),
      ),
    );
  }
}
