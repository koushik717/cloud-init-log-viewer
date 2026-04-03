import 'package:flutter/material.dart';

class AppTheme {
  static const Color ubuntuOrange = Color(0xFFE95420);
  static const Color ubuntuAubergine = Color(0xFF77216F);
  static const Color ubuntuWarmGrey = Color(0xFFAEA79F);
  static const Color ubuntuCoolGrey = Color(0xFF333333);
  static const Color background = Color(0xFF1A1A1A);
  static const Color surface = Color(0xFF2A2A2A);
  static const Color card = Color(0xFF333333);
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFFC107);
  static const Color error = Color(0xFFF44336);
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFAEA79F);

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: background,
      cardColor: card,
      primaryColor: ubuntuOrange,
      colorScheme: const ColorScheme.dark(
        primary: ubuntuOrange,
        secondary: ubuntuAubergine,
        surface: surface,
        background: background,
        error: error,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: surface,
        elevation: 0,
      ),
      cardTheme: const CardThemeData(
        color: card,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
      ),
      useMaterial3: true,
      fontFamily: 'monospace', // Default for log display areas
    );
  }
}
