import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:igcse_learning_hub/src/features/authentication/presentation/providers/auth_provider.dart';
import 'package:igcse_learning_hub/src/shared/presentation/widgets/app_logo.dart';
import 'package:igcse_learning_hub/src/theme/design_tokens.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _controller.forward();
    _checkAuthAndNavigate();
  }

  Future<void> _checkAuthAndNavigate() async {
    final authProvider = context.read<AuthProvider>();
    
    try {
      // Check authentication status with timeout
      await authProvider.checkAuthStatus().timeout(
        const Duration(seconds: 5),
        onTimeout: () {
          // If timeout, treat as unauthenticated
          debugPrint('Auth check timeout - treating as unauthenticated');
        },
      );
    } catch (e) {
      // If error, treat as unauthenticated
      debugPrint('Auth check error: $e');
    }
    
    // Wait for animation
    await Future.delayed(const Duration(milliseconds: 2200));
    if (!mounted) return;
    
    // Navigate based on authentication status
    if (authProvider.isAuthenticated) {
      context.go('/dashboard');
    } else {
      context.go('/onboarding');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0E1C4F), Color(0xFF16235F), Color(0xFF1F2F6F)],
          ),
        ),
        child: FadeTransition(
          opacity: _fade,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                AppLogo(size: 96),
                SizedBox(height: 24),
                Text(
                  'IGCSE MASTERY',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Building confidence, mastering IGCSE',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: const Padding(
        padding: EdgeInsets.only(bottom: 32),
        child: SizedBox(
          height: 2,
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Colors.transparent,
                  AppColors.primary,
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
