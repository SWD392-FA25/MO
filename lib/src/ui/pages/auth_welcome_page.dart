import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../state/app_state.dart';
import '../../theme/design_tokens.dart';
import '../widgets/app_logo.dart';
import '../widgets/primary_capsule_button.dart';

class AuthWelcomePage extends StatelessWidget {
  const AuthWelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            children: [
              const SizedBox(height: 12),
              const AppLogo(size: 88),
              const SizedBox(height: 24),
              Text(
                'IGCSE MASTERY',
                style: textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Building confidence, mastering IGCSE',
                style: textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              Text(
                "Let's you in",
                style: textTheme.titleLarge?.copyWith(fontSize: 26),
              ),
              const SizedBox(height: 32),
              PrimaryCapsuleButton(
                label: 'Sign In with Your Account',
                icon: Icons.arrow_forward_rounded,
                onPressed: () => context.go('/auth/sign-in'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  context.read<AppState>().loginWithGoogleMock();
                  context.go('/dashboard/home');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFEA4235),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 18,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.g_mobiledata_rounded,
                      size: 36,
                      color: Colors.white,
                    ),
                    SizedBox(width: 12),
                    Text('Continue with Google'),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an Account?",
                    style: textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  TextButton(
                    onPressed: () => context.go('/auth/sign-up'),
                    child: const Text('SIGN UP'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
