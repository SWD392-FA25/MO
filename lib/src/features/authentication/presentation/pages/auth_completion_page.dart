import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:igcse_learning_hub/src/shared/presentation/widgets/primary_capsule_button.dart';
import 'package:igcse_learning_hub/src/theme/design_tokens.dart';

class AuthCompletionPage extends StatelessWidget {
  const AuthCompletionPage({
    super.key,
    required this.contextType,
  });

  final AuthCompletionType contextType;

  String get _title {
    switch (contextType) {
      case AuthCompletionType.signUp:
        return 'Hoàn tất đăng ký!';
      case AuthCompletionType.passwordReset:
        return 'Đặt lại mật khẩu thành công!';
    }
  }

  String get _message {
    switch (contextType) {
      case AuthCompletionType.signUp:
        return 'Chào mừng bạn đến với IGCSE Learning Hub. Cùng bắt đầu học tập thôi!';
      case AuthCompletionType.passwordReset:
        return 'Mật khẩu mới của bạn đã được cập nhật. Hãy đăng nhập lại để tiếp tục.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 160,
                height: 160,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary.withAlpha(32),
                ),
                child: Icon(
                  contextType == AuthCompletionType.signUp
                      ? Icons.emoji_events_rounded
                      : Icons.lock_open_rounded,
                  size: 72,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                _title,
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                _message,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                      height: 1.5,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              PrimaryCapsuleButton(
                label: 'Đi tới Dashboard',
                icon: Icons.arrow_forward_rounded,
                onPressed: () => context.go('/dashboard'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

enum AuthCompletionType { signUp, passwordReset }
