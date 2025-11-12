import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;

import 'package:igcse_learning_hub/src/features/authentication/presentation/providers/auth_provider.dart';
import 'package:igcse_learning_hub/src/features/authentication/presentation/providers/auth_state.dart';
import 'package:igcse_learning_hub/src/shared/presentation/widgets/app_logo.dart';
import 'package:igcse_learning_hub/src/shared/presentation/widgets/primary_capsule_button.dart';
import 'package:igcse_learning_hub/src/theme/design_tokens.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _rememberMe = false;
  bool _obscurePassword = true;
  bool _isGoogleSigningIn = false;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'profile',
      'openid',
    ],
    hostedDomain: '',
  );

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthProvider>().resetState();
    });
  }

  Future<void> _handleSignIn() async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = context.read<AuthProvider>();
    
    await authProvider.signIn(
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );

    if (!mounted) return;

    final state = authProvider.state;
    if (state is AuthAuthenticated) {
      context.go('/dashboard');
    } else if (state is AuthError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(state.message),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _handleGoogleSignIn() async {
    try {
      final authProvider = context.read<AuthProvider>();
      // Disable button during Google Sign-In process
      if (authProvider.isLoading) return;

      // Set temporary loading state during Google UI
      setState(() {
        _isGoogleSigningIn = true;
      });
      
      print('🔍 DEBUG: Starting Google Sign-In');
      
      // Check if already signed in
      GoogleSignInAccount? currentUser = await _googleSignIn.signInSilently();
      if (currentUser != null) {
        print('🔍 DEBUG: Already signed in, signing out...');
        await _googleSignIn.signOut();
        await Future.delayed(const Duration(milliseconds: 500));
      }
      
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      print('🔍 DEBUG: Google Sign-In result: ${googleUser != null}');
      
      if (googleUser == null) {
        print('🔍 DEBUG: User cancelled Google Sign-In');
        return;
      }

      print('🔍 DEBUG: Getting authentication tokens...');
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Debug Google Sign-In tokens
      print('🔍 DEBUG: Google Auth Tokens');
      print('ID Token: ${googleAuth.idToken?.substring(0, 50)}...');
      print('Access Token: ${googleAuth.accessToken?.substring(0, 50)}...');
      print('Has ID Token: ${googleAuth.idToken != null}');
      print('Has Access Token: ${googleAuth.accessToken != null}');
      
      // STEP 2: Create Google credential for Firebase
      final OAuthCredential googleCredential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      );

      // STEP 3: Sign in to Firebase with Google credential
      final UserCredential firebaseUserCredential = await FirebaseAuth.instance.signInWithCredential(googleCredential);
      print('🔍 DEBUG: Firebase authentication successful');
      print('🔍 DEBUG: Firebase User UID: ${firebaseUserCredential.user?.uid}');

      // STEP 4: Get Firebase ID Token
      final String? firebaseIdToken = await firebaseUserCredential.user?.getIdToken();
      if (firebaseIdToken == null) {
        throw Exception('Failed to get Firebase ID token');
      }
      print('🔍 DEBUG: Firebase ID Token: ${firebaseIdToken.substring(0, 50)}...');

      // STEP 5: Send Firebase ID token to API
      await authProvider.googleSignInWithFirebase(
        firebaseIdToken: firebaseIdToken,
      );

      if (!mounted) return;

      final state = authProvider.state;
      if (state is AuthAuthenticated) {
        context.go('/dashboard');
      } else if (state is AuthError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(state.message),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      print('🔴 DEBUG: Google Sign-In error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Google Sign-In failed: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isGoogleSigningIn = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final authProvider = context.watch<AuthProvider>();
    final isLoading = authProvider.isLoading;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Form(
            key: _formKey,
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
                "Let's Sign In.!",
                style: textTheme.titleLarge?.copyWith(fontSize: 28),
              ),
              const SizedBox(height: 12),
              Text(
                'Login to your account to continue your courses',
                style: textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 32),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                enabled: !isLoading,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email_outlined),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!value.contains('@')) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                enabled: !isLoading,
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: const Icon(Icons.lock_outline_rounded),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off_rounded
                          : Icons.visibility_rounded,
                    ),
                    onPressed: () =>
                        setState(() => _obscurePassword = !_obscurePassword),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  if (value.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Checkbox(
                    value: _rememberMe,
                    onChanged: (value) =>
                        setState(() => _rememberMe = value ?? false),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Remember Me',
                    style: textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () => context.push('/auth/forgot'),
                    child: const Text('Forgot Password?'),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              PrimaryCapsuleButton(
                label: isLoading ? 'Signing In...' : 'Sign In',
                icon: isLoading ? null : Icons.arrow_forward_rounded,
                onPressed: isLoading ? null : _handleSignIn,
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  const Expanded(child: Divider()),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      'Or Continue With',
                      style: textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                  const Expanded(child: Divider()),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: (isLoading || _isGoogleSigningIn) ? null : _handleGoogleSignIn,
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
                  children: [
                    if (_isGoogleSigningIn)
                      const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    else
                      const Icon(
                        Icons.g_mobiledata_rounded,
                        size: 36,
                        color: Colors.white,
                      ),
                    const SizedBox(width: 12),
                    Text(_isGoogleSigningIn ? 'Signing in...' : 'Continue with Google'),
                  ],
                ),
              ),
              const SizedBox(height: 20),
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
                    onPressed: () => context.push('/auth/sign-up'),
                    child: const Text('SIGN UP'),
                  ),
                ],
              ),
            ],
          ),
        ),
        ),
      ),
    );
  }
}
