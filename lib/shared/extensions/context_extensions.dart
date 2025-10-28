import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

extension ContextExtensions on BuildContext {
  // Theme extensions
  ThemeData get theme => Theme.of(this);
  ColorScheme get colorScheme => theme.colorScheme;
  TextTheme get textTheme => theme.textTheme;
  
  // MediaQuery extensions
  MediaQueryData get mediaQuery => MediaQuery.of(this);
  Size get screenSize => mediaQuery.size;
  double get screenWidth => screenSize.width;
  double get screenHeight => screenSize.height;
  EdgeInsets get padding => mediaQuery.padding;
  EdgeInsets get viewInsets => mediaQuery.viewInsets;
  EdgeInsets get viewPadding => mediaQuery.viewPadding;
  bool get isKeyboardVisible => viewInsets.bottom > 0;
  
  // Responsive design helpers
  bool get isMobile => screenWidth < 600;
  bool get isTablet => screenWidth >= 600 && screenWidth < 1200;
  bool get isDesktop => screenWidth >= 1200;
  
  // Navigation extensions - use GoRouter methods directly to avoid conflicts
  GoRouter get router => GoRouter.of(this);
  
  void navigate(String location, {Object? extra}) => router.go(location, extra: extra);
  void navigateNamed(String name, {Map<String, String>? params, Object? extra}) => 
      router.goNamed(name, pathParameters: params ?? {}, extra: extra);
  void pushTo(String location, {Object? extra}) => router.push(location, extra: extra);
  void pushToNamed(String name, {Map<String, String>? params, Object? extra}) => 
      router.pushNamed(name, pathParameters: params ?? {}, extra: extra);
  
  // Snackbar helpers
  void showSnackBar(String message, {Duration? duration, SnackBarAction? action}) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: duration ?? const Duration(seconds: 3),
        action: action,
      ),
    );
  }
  
  void showErrorSnackBar(String message) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: colorScheme.error,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
  
  void showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
  
  void hideSnackBar() {
    ScaffoldMessenger.of(this).hideCurrentSnackBar();
  }
  
  // Dialog helpers
  Future<T?> showAppDialog<T>({
    required String title,
    required String message,
    String? confirmText,
    String? cancelText,
    bool isDismissible = true,
  }) {
    return showDialog<T>(
      context: this,
      barrierDismissible: isDismissible,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          if (cancelText != null)
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(cancelText),
            ),
          if (confirmText != null)
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(confirmText),
            ),
        ],
      ),
    );
  }
  
  // Focus helpers
  void unfocus() {
    FocusScope.of(this).unfocus();
  }
  
  void requestFocus(FocusNode node) {
    FocusScope.of(this).requestFocus(node);
  }
}
