import 'package:flutter/material.dart';

ThemeData buildAppTheme() {
  const primaryBlue = Color(0xFF1565C0); // modern academic blue
  const secondaryBlue = Color(0xFF42A5F5);
  const surfaceWhite = Colors.white;

  final colorScheme = ColorScheme.fromSeed(
    seedColor: primaryBlue,
    primary: primaryBlue,
    secondary: secondaryBlue,
    surface: surfaceWhite,
    background: const Color(0xFFF7F9FC),
    brightness: Brightness.light,
  );

  return ThemeData(
    colorScheme: colorScheme,
    useMaterial3: true,
    scaffoldBackgroundColor: colorScheme.background,
    appBarTheme: AppBarTheme(
      backgroundColor: surfaceWhite,
      foregroundColor: colorScheme.primary,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: primaryBlue,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: colorScheme.primary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    ),
    chipTheme: ChipThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      selectedColor: secondaryBlue.withOpacity(0.15),
      side: BorderSide(color: secondaryBlue.withOpacity(0.3)),
    ),
    cardTheme: const CardThemeData(
      color: surfaceWhite,
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
    ),
  );
}
