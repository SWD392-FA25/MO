import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;

import 'package:igcse_learning_hub/src/features/authentication/presentation/providers/auth_provider.dart';
import 'package:igcse_learning_hub/src/features/authentication/presentation/providers/auth_state.dart';
import 'package:igcse_learning_hub/src/shared/presentation/widgets/app_logo.dart';
import 'package:igcse_learning_hub/src/theme/design_tokens.dart';

class AuthWelcomePage extends StatefulWidget {
  const AuthWelcomePage({super.key});

  @override
  State<AuthWelcomePage> createState() => _AuthWelcomePageState();
}

class _AuthWelcomePageState extends State<AuthWelcomePage> {
  bool _isGoogleSigningIn = false;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile', 'openid'],
    hostedDomain: '',
  );

  Future<void> _handleGoogleSignIn() async {
    try {
      final authProvider = context.read<AuthProvider>();
      if (authProvider.isLoading) return;

      setState(() => _isGoogleSigningIn = true);

      GoogleSignInAccount? currentUser = await _googleSignIn.signInSilently();
      if (currentUser != null) {
        await _googleSignIn.signOut();
        await Future.delayed(const Duration(milliseconds: 500));
      }

      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return;

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final OAuthCredential googleCredential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      );

      final UserCredential firebaseUserCredential =
          await FirebaseAuth.instance.signInWithCredential(googleCredential);

      final String? firebaseIdToken = await firebaseUserCredential.user?.getIdToken();
      if (firebaseIdToken == null) {
        throw Exception('Failed to get Firebase ID token');
      }

      await authProvider.googleSignInWithFirebase(firebaseIdToken: firebaseIdToken);

      if (!mounted) return;

      final state = authProvider.state;
      if (state is AuthAuthenticated) {
        context.go('/dashboard');
      } else if (state is AuthError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(state.message), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Google Sign-In failed: ${e.toString()}'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isGoogleSigningIn = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final authProvider = context.watch<AuthProvider>();
    final isLoading = authProvider.isLoading || _isGoogleSigningIn;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
          child: Column(
            children: [
              const SizedBox(height: 20),
              AppLogo(width: MediaQuery.of(context).size.width * 0.7),
              const Spacer(),
              Text(
                "Let's you in",
                style: textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1E232C),
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: isLoading ? null : () => context.push('/auth/sign-in'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                    elevation: 0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Sign In with Your Account', style: textTheme.titleMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.w600)),
                      const SizedBox(width: 12),
                      const Icon(Icons.arrow_forward, color: Colors.white, size: 24),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text('Or', style: textTheme.bodyLarge?.copyWith(color: const Color(0xFF6A707C), fontWeight: FontWeight.w600)),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: isLoading ? null : _handleGoogleSignIn,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFEA4335),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                    elevation: 0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (isLoading)
                        const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation<Color>(Colors.white)))
                      else
                        Text('Continue with Google', style: textTheme.titleMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.w600)),
                      const SizedBox(width: 12),
                      const Icon(Icons.arrow_forward, color: Colors.white, size: 24),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Don't have an Account? ", style: textTheme.bodyMedium?.copyWith(color: const Color(0xFF6A707C))),
                  TextButton(
                    onPressed: () => context.push('/auth/sign-up'),
                    style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: const Size(0, 0), tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                    child: Text('SIGN UP', style: textTheme.bodyMedium?.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold)),
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
