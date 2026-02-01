// lib/settings/theme_data.dart

import 'package:flutter/material.dart';

class QuarkTheme {
  QuarkTheme._();

  static const Color _lightPrimaryColor = Color(0xFF5E5CE6);
  static const Color _lightBackgroundColor = Color(0xFFF2F2F7);
 static const Color _lightTextColor = Colors.black;

  static const Color _darkPrimaryColor = Color(0xFF64D2FF);
  static const Color _darkBackgroundColor = Color(0xFF1C1C1E);
  static const Color _darkTextColor = Colors.white;

  static const _textTheme = TextTheme(
    displayLarge: TextStyle(fontSize: 57.0, fontWeight: FontWeight.bold),
    displayMedium: TextStyle(fontSize: 45.0, fontWeight: FontWeight.bold),
    displaySmall: TextStyle(fontSize: 36.0, fontWeight: FontWeight.bold),
    headlineLarge: TextStyle(fontSize: 32.0, fontWeight: FontWeight.w700),
    headlineMedium: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
    headlineSmall: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w700),
    titleLarge: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),
    titleMedium: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),
    titleSmall: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w600),
    bodyLarge: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w400),
    bodyMedium: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400),
    bodySmall: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w400),
    labelLarge: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500, letterSpacing: 1.25),
    labelMedium: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w500),
    labelSmall: TextStyle(fontSize: 10.0, fontWeight: FontWeight.w400, letterSpacing: 1.5),
  );

  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: _lightPrimaryColor,
    scaffoldBackgroundColor: _lightBackgroundColor,
    colorScheme: ColorScheme.light(
      primary: _lightPrimaryColor,
      secondary: _lightPrimaryColor,
      background: _lightBackgroundColor,
      onBackground: _lightTextColor,
      surface: Colors.white,
      onSurface: _lightTextColor,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: _lightBackgroundColor,
      elevation: 0,
      iconTheme: IconThemeData(color: _lightPrimaryColor),
      titleTextStyle: TextStyle(color: _lightTextColor, fontSize: 20, fontWeight: FontWeight.bold),
    ),
    textTheme: _textTheme.apply(bodyColor: _lightTextColor, displayColor: _lightTextColor),
    
    // --- ADDED FOR BUTTON STYLING ---
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: _lightPrimaryColor,
        foregroundColor: Colors.white,
      ),
    ),
    
    // --- ADDED FOR TEXT FIELD STYLING ---
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.black.withOpacity(0.04),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: _darkPrimaryColor,
    scaffoldBackgroundColor: _darkBackgroundColor,
    colorScheme: ColorScheme.dark(
      primary: _darkPrimaryColor,
      secondary: _darkPrimaryColor,
      background: _darkBackgroundColor,
      onBackground: _darkTextColor,
      surface: const Color(0xFF2C2C2E),
      onSurface: _darkTextColor,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: _darkBackgroundColor,
      elevation: 0,
      iconTheme: IconThemeData(color: _darkPrimaryColor),
      titleTextStyle: TextStyle(color: _darkTextColor, fontSize: 20, fontWeight: FontWeight.bold),
    ),
    textTheme: _textTheme.apply(bodyColor: _darkTextColor, displayColor: _darkTextColor),

    // --- ADDED FOR BUTTON STYLING (DARK) ---
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: _darkPrimaryColor,
        foregroundColor: _darkBackgroundColor,
      ),
    ),

    // --- ADDED FOR TEXT FIELD STYLING (DARK) ---
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white.withOpacity(0.06),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    ),
  );
}