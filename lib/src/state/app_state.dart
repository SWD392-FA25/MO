import 'package:flutter/foundation.dart';

// Legacy AppState for backward compatibility
// TODO: Migrate to Riverpod state management
class AppState with ChangeNotifier {
  int _selectedIndex = 0;
  String? _displayName;

  int get selectedIndex => _selectedIndex;
  String? get displayName => _displayName;

  void setSelectedIndex(int index) {
    _selectedIndex = index;
    notifyListeners();
  }

  void navigateTo(int index) {
    setSelectedIndex(index);
  }

  // Mock login methods for compatibility
  Future<void> loginWithGoogleMock() async {
    // TODO: Implement actual Google login
    await Future.delayed(const Duration(seconds: 1));
    _displayName = 'Guest User';
    notifyListeners();
  }

  Future<void> logout() async {
    _displayName = null;
    _selectedIndex = 0;
    notifyListeners();
  }
}
