import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:igcse_learning_hub/src/features/authentication/presentation/providers/auth_provider.dart';

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
      backgroundColor: Colors.white,
      body: FadeTransition(
        opacity: _fade,
        child: Center(
          child: Image.asset(
            'assets/images/LogoHaveText.png',
            width: MediaQuery.of(context).size.width * 0.6,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
