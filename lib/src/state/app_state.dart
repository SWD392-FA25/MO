import 'package:flutter/foundation.dart';

class AppState extends ChangeNotifier {
  bool _isLoggedIn = false;
  String? _studentName;

  bool get isLoggedIn => _isLoggedIn;
  String get displayName => _studentName ?? 'Student';

  void loginWithGoogleMock() {
    _isLoggedIn = true;
    _studentName = 'IGCSE Learner';
    notifyListeners();
  }

  void logout() {
    _isLoggedIn = false;
    _studentName = null;
    notifyListeners();
  }
}
