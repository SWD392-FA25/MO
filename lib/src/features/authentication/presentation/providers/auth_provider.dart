import 'package:flutter/foundation.dart';

import '../../../../../core/usecases/usecase.dart';
import '../../domain/entities/user.dart';
import '../../domain/usecases/forgot_password.dart';
import '../../domain/usecases/get_current_user.dart';
import '../../domain/usecases/sign_in.dart';
import '../../domain/usecases/sign_out.dart';
import '../../domain/usecases/sign_up.dart';
import '../../domain/usecases/verify_otp.dart';
import 'auth_state.dart';

class AuthProvider extends ChangeNotifier {
  final SignIn signInUseCase;
  final SignUp signUpUseCase;
  final SignOut signOutUseCase;
  final GetCurrentUser getCurrentUserUseCase;
  final ForgotPassword forgotPasswordUseCase;
  final VerifyOtp verifyOtpUseCase;

  AuthProvider({
    required this.signInUseCase,
    required this.signUpUseCase,
    required this.signOutUseCase,
    required this.getCurrentUserUseCase,
    required this.forgotPasswordUseCase,
    required this.verifyOtpUseCase,
  });

  AuthState _state = const AuthInitial();
  AuthState get state => _state;

  User? _currentUser;
  User? get currentUser => _currentUser;

  bool get isAuthenticated => _state is AuthAuthenticated;
  bool get isLoading => _state is AuthLoading;

  void _setState(AuthState newState) {
    _state = newState;
    notifyListeners();
  }

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    _setState(const AuthLoading());

    final result = await signInUseCase(
      SignInParams(email: email, password: password),
    );

    result.fold(
      (failure) => _setState(AuthError(failure.message)),
      (token) async {
        // TODO: Parse user from login response instead of calling getCurrentUser
        // For now, set a temporary authenticated state
        _currentUser = const User(
          id: 'temp',
          email: 'user@example.com',
          name: 'User',
        );
        _setState(AuthAuthenticated(_currentUser!));
      },
    );
  }

  Future<void> signUp({
    required String email,
    required String password,
    required String name,
    String? phoneNumber,
  }) async {
    _setState(const AuthLoading());

    final result = await signUpUseCase(
      SignUpParams(
        email: email,
        password: password,
        name: name,
        phoneNumber: phoneNumber,
      ),
    );

    result.fold(
      (failure) => _setState(AuthError(failure.message)),
      (token) async {
        // TODO: Parse user from register response instead of calling getCurrentUser
        // For now, set a temporary authenticated state
        _currentUser = User(
          id: 'temp',
          email: email,
          name: name,
        );
        _setState(AuthAuthenticated(_currentUser!));
      },
    );
  }

  Future<void> signOut() async {
    _setState(const AuthLoading());

    final result = await signOutUseCase(NoParams());

    result.fold(
      (failure) => _setState(AuthError(failure.message)),
      (_) {
        _currentUser = null;
        _setState(const AuthUnauthenticated());
      },
    );
  }

  Future<void> getCurrentUser() async {
    _setState(const AuthLoading());
    await _loadCurrentUser();
  }

  Future<void> _loadCurrentUser() async {
    final result = await getCurrentUserUseCase(NoParams());

    result.fold(
      (failure) => _setState(AuthError(failure.message)),
      (user) {
        _currentUser = user;
        _setState(AuthAuthenticated(user));
      },
    );
  }

  Future<void> forgotPassword(String email) async {
    _setState(const AuthLoading());

    final result = await forgotPasswordUseCase(ForgotPasswordParams(email));

    result.fold(
      (failure) => _setState(AuthError(failure.message)),
      (_) => _setState(
        const AuthSuccess('Password reset email sent. Please check your inbox.'),
      ),
    );
  }

  Future<void> verifyOtp({
    required String email,
    required String otp,
  }) async {
    _setState(const AuthLoading());

    final result = await verifyOtpUseCase(
      VerifyOtpParams(email: email, otp: otp),
    );

    result.fold(
      (failure) => _setState(AuthError(failure.message)),
      (_) => _setState(const AuthSuccess('OTP verified successfully')),
    );
  }

  void resetState() {
    _setState(const AuthInitial());
  }
}
