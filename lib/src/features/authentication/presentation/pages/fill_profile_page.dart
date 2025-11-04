import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:igcse_learning_hub/src/shared/presentation/widgets/app_logo.dart';
import 'package:igcse_learning_hub/src/shared/presentation/widgets/primary_capsule_button.dart';
import 'package:igcse_learning_hub/src/theme/design_tokens.dart';

class FillProfilePage extends StatefulWidget {
  const FillProfilePage({super.key});

  @override
  State<FillProfilePage> createState() => _FillProfilePageState();
}

class _FillProfilePageState extends State<FillProfilePage> {
  final _nameController = TextEditingController(text: 'Shirayuki Luna');
  final _gradeController = TextEditingController(text: 'IGCSE - Grade 10');
  final _goalController =
      TextEditingController(text: 'Hoàn thành chứng chỉ Graphic Design');

  @override
  void dispose() {
    _nameController.dispose();
    _gradeController.dispose();
    _goalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () => context.pop(),
                    icon: const Icon(Icons.arrow_back_ios_new_rounded),
                  ),
                  const Spacer(),
                  const AppLogo(size: 48),
                  const SizedBox(width: 12),
                  Text(
                    'IGCSE MASTERY',
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              Text(
                'Điền hồ sơ của bạn',
                style: textTheme.titleLarge?.copyWith(fontSize: 28),
              ),
              const SizedBox(height: 12),
              Text(
                'Hoàn thiện thông tin để cá nhân hoá lộ trình học tập.',
                style: textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 32),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Tên hiển thị',
                  prefixIcon: Icon(Icons.person_outline_rounded),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _gradeController,
                decoration: const InputDecoration(
                  labelText: 'Lớp / Khối đang học',
                  prefixIcon: Icon(Icons.school_outlined),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _goalController,
                minLines: 3,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'Mục tiêu học tập',
                  prefixIcon: Icon(Icons.flag_outlined),
                ),
              ),
              const SizedBox(height: 32),
              PrimaryCapsuleButton(
                label: 'Hoàn tất hồ sơ',
                icon: Icons.arrow_forward_rounded,
                onPressed: () => context.go('/auth/congratulations?context=signup'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
