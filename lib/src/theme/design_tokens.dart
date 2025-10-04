import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF4C1DE6);
  static const Color primaryDark = Color(0xFF31149B);
  static const Color accent = Color(0xFFFF3265);
  static const Color background = Color(0xFFF5F6FF);
  static const Color surface = Colors.white;
  static const Color textPrimary = Color(0xFF1B1F3B);
  static const Color textSecondary = Color(0xFF6F7492);
  static const Color border = Color(0xFFE3E7FF);
  static const Color cardShadow = Color(0x141B1F3B);

  const AppColors._();
}

class AppSpacing {
  static const double xxs = 4;
  static const double xs = 8;
  static const double sm = 12;
  static const double md = 16;
  static const double lg = 20;
  static const double xl = 24;
  static const double xxl = 32;

  const AppSpacing._();
}

class AppRadius {
  static const Radius card = Radius.circular(24);
  static const Radius chip = Radius.circular(28);
  static const Radius pill = Radius.circular(30);
  static const Radius input = Radius.circular(18);

  const AppRadius._();
}
