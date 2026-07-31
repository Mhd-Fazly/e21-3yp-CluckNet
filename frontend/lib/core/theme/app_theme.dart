import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:io' show Platform;

@immutable
class SensorColors extends ThemeExtension<SensorColors> {
  final Color safe;
  final Color warning;
  final Color critical;

  const SensorColors({
    required this.safe,
    required this.warning,
    required this.critical,
  });

  @override
  SensorColors copyWith({Color? safe, Color? warning, Color? critical}) {
    return SensorColors(
      safe: safe ?? this.safe,
      warning: warning ?? this.warning,
      critical: critical ?? this.critical,
    );
  }

  @override
  SensorColors lerp(ThemeExtension<SensorColors>? other, double t) {
    if (other is! SensorColors) return this;
    return SensorColors(
      safe: Color.lerp(safe, other.safe, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      critical: Color.lerp(critical, other.critical, t)!,
    );
  }

  static const light = SensorColors(
    safe: Color(0xFF2E7D32),       // Rich Green
    warning: Color(0xFFEF6C00),    // Rich Orange
    critical: Color(0xFFC62828),   // Rich Red
  );

  static const dark = SensorColors(
    safe: Color(0xFF81C784),       // Light Green
    warning: Color(0xFFFFB74D),    // Light Orange
    critical: Color(0xFFE57373),   // Light Red
  );
}

class AppTheme {
  // Primary green theme colors
  static const Color primaryColor = Color(0xFF4CAF50);
  static const Color primaryDarkColor = Color(0xFF388E3C);

  static bool get _isTest => Platform.environment.containsKey('FLUTTER_TEST');
  
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: Brightness.light,
        primary: primaryColor,
        secondary: const Color(0xFF81C784),
        error: const Color(0xFFC62828),
        surface: Colors.white,
      ),
      scaffoldBackgroundColor: const Color(0xFFF9FBE7), // Soft earthy cream
      textTheme: _isTest
          ? ThemeData.light().textTheme
          : GoogleFonts.outfitTextTheme(ThemeData.light().textTheme),
      appBarTheme: const AppBarTheme(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: Colors.white,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 56), // Large touch targets
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      ),
      extensions: const [SensorColors.light],
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: Brightness.dark,
        primary: const Color(0xFF81C784),
        secondary: const Color(0xFF4CAF50),
        error: const Color(0xFFE57373),
        surface: const Color(0xFF2A302A),
      ),
      scaffoldBackgroundColor: const Color(0xFF1E241E), // Soft dark earthy background
      textTheme: _isTest
          ? ThemeData.dark().textTheme
          : GoogleFonts.outfitTextTheme(ThemeData.dark().textTheme),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF2A302A),
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: const Color(0xFF2A302A),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF81C784),
          foregroundColor: const Color(0xFF1E241E),
          minimumSize: const Size(double.infinity, 56),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF2A302A),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade800),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade800),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF81C784), width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      ),
      extensions: const [SensorColors.dark],
    );
  }
}
