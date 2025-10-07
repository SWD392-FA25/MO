import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';

import 'package:igcse_learning_hub/src/features/authentication/presentation/pages/auth_completion_page.dart';
import 'package:igcse_learning_hub/src/features/authentication/presentation/pages/auth_welcome_page.dart';
import 'package:igcse_learning_hub/src/features/authentication/presentation/pages/create_new_password_page.dart';
import 'package:igcse_learning_hub/src/features/authentication/presentation/pages/fill_profile_page.dart';
import 'package:igcse_learning_hub/src/features/authentication/presentation/pages/forgot_password_page.dart';
import 'package:igcse_learning_hub/src/features/authentication/presentation/pages/sign_in_page.dart';
import 'package:igcse_learning_hub/src/features/authentication/presentation/pages/sign_up_page.dart';
import 'package:igcse_learning_hub/src/features/authentication/presentation/pages/verify_otp_page.dart';
import 'package:igcse_learning_hub/src/theme/app_theme.dart';

Widget wrapWithAppTheme(Widget child) {
  return MaterialApp(
    theme: buildAppTheme(),
    debugShowCheckedModeBanner: false,
    home: Scaffold(body: child),
  );
}

@Preview(
  name: 'Auth Welcome',
  size: Size(390, 844),
  wrapper: wrapWithAppTheme,
)
Widget authWelcomePreview() => const AuthWelcomePage();

@Preview(
  name: 'Sign In',
  size: Size(390, 844),
  wrapper: wrapWithAppTheme,
)
Widget signInPreview() => const SignInPage();

@Preview(
  name: 'Sign Up',
  size: Size(390, 844),
  wrapper: wrapWithAppTheme,
)
Widget signUpPreview() => const SignUpPage();

@Preview(
  name: 'Forgot Password',
  size: Size(390, 844),
  wrapper: wrapWithAppTheme,
)
Widget forgotPasswordPreview() => const ForgotPasswordPage();

@Preview(
  name: 'Verify OTP',
  size: Size(390, 844),
  wrapper: wrapWithAppTheme,
)
Widget verifyOtpPreview() => const VerifyOtpPage();

@Preview(
  name: 'Create Password',
  size: Size(390, 844),
  wrapper: wrapWithAppTheme,
)
Widget createPasswordPreview() => const CreateNewPasswordPage();

@Preview(
  name: 'Fill Profile',
  size: Size(390, 844),
  wrapper: wrapWithAppTheme,
)
Widget fillProfilePreview() => const FillProfilePage();

@Preview(
  name: 'Auth Completion',
  size: Size(390, 844),
  wrapper: wrapWithAppTheme,
)
Widget authCompletionPreview() =>
    const AuthCompletionPage(contextType: AuthCompletionType.signUp);
