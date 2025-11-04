import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:igcse_learning_hub/src/theme/design_tokens.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                onPressed: () => context.pop(),
                icon: const Icon(Icons.arrow_back_ios_new_rounded),
              ),
              const SizedBox(height: 32),
              Text(
                'Quên mật khẩu?',
                style: textTheme.titleLarge?.copyWith(fontSize: 26),
              ),
              const SizedBox(height: 12),
              Text(
                'Nhập email đăng ký để nhận mã xác thực đặt lại mật khẩu.',
                style: textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 32),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email_outlined),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => context.push('/auth/verify-otp'),
                child: const Text('Gửi mã xác thực'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
