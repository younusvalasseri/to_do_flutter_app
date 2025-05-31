import 'package:flutter/material.dart';

class AppColors {
  // Primary theme color
  static const Color primary = Color(0xFF1E6F9F); // Blue tone
  static const Color lightBlue = Color.fromARGB(204, 172, 207, 235);
  // Custom MaterialColor from primary
  static const MaterialColor primarySwatch = MaterialColor(
    0xFF0A73B7,
    <int, Color>{
      50: Color(0xFFE1F0F8),
      100: Color(0xFFB3DAED),
      200: Color(0xFF80C3E2),
      300: Color(0xFF4DACD7),
      400: Color(0xFF2699CE),
      500: Color(0xFF1E6F9F), // primary
      600: Color(0xFF086AA7),
      700: Color(0xFF065B93),
      800: Color(0xFF044D80),
      900: Color(0xFF023960),
    },
  );
  // Accent or secondary color
  static const Color secondary = Color(0xFFFF9800); // Orange tone

  // Backgrounds
  static const Color background = Color(0xFFF5F5F5); // Light grey
  static const Color card = Color(0xFFFFFFFF);

  // Text
  static const Color textPrimary = Color(0xFF212121); // Dark grey
  static const Color textSecondary = Color(0xFF757575); // Medium grey

  // Status indicators
  static const Color success = Color(0xFF4CAF50); // Green
  static const Color error = Color(0xFFF44336); // Red
  static const Color warning = Color(0xFFFFC107); // Yellow
  static const Color info = Color(0xFF2196F3); // Blue

  // Task-specific
  static const Color completed = Color(0xFF4CAF50); // Green tick
  static const Color important = Color(0xFFFF5722); // Deep orange
  static const Color pending = Color(0xFF607D8B); // Blue-grey

  // Transparent overlays
  static const Color overlay = Colors.black54;
  static const Color gray = Color.fromARGB(255, 133, 133, 133);
  static const Color yellow = Color.fromARGB(255, 244, 232, 8);

  static const LinearGradient backgroundGradient = LinearGradient(
    colors: [Color(0xFF1A1A1A), gray],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}
