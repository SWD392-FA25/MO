import 'package:flutter/foundation.dart';

import '../../domain/entities/user_profile.dart';
import '../../domain/usecases/get_profile.dart';
import '../../domain/usecases/update_profile.dart';

class ProfileProvider extends ChangeNotifier {
  final GetProfile getProfileUseCase;
  final UpdateProfile updateProfileUseCase;

  ProfileProvider({
    required this.getProfileUseCase,
    required this.updateProfileUseCase,
  });

  // State
  UserProfile? _profile;
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  UserProfile? get profile => _profile;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isLoggedIn => _profile != null;

  // Load profile
  Future<void> loadProfile(String userId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await getProfileUseCase.call(userId);

    result.fold(
      (failure) {
        _errorMessage = failure.message;
        _isLoading = false;
        notifyListeners();
      },
      (profile) {
        _profile = profile;
        _isLoading = false;
        notifyListeners();
      },
    );
  }

  // Update profile
  Future<bool> updateProfile(String userId, Map<String, dynamic> data) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await updateProfileUseCase.call(
      UpdateProfileParams(userId: userId, data: data),
    );

    return result.fold(
      (failure) {
        _errorMessage = failure.message;
        _isLoading = false;
        notifyListeners();
        return false;
      },
      (profile) {
        _profile = profile;
        _isLoading = false;
        notifyListeners();
        return true;
      },
    );
  }

  // Clear profile (logout)
  void clearProfile() {
    _profile = null;
    _errorMessage = null;
    notifyListeners();
  }

  // Clear error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
