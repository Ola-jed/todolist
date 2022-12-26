import 'package:flutter/material.dart';

class TodolistTheme {
  TodolistTheme._();

  static double borderRadius = 3;
  static ThemeData lightTheme = ThemeData(
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFFF1F1F1),
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.black),
      titleTextStyle: TextStyle(color: Colors.black),
    ),
    cardColor: Colors.white,
    scaffoldBackgroundColor: const Color(0xFFF1F1F1),
    colorScheme: const ColorScheme(
      primary: Color(0xFF1B4525),
      secondary: Color(0xFF515B68),
      surface: Color(0xFFACBDD3),
      background: Color(0xFFF1F1F1),
      error: Color(0xFFB00020),
      onPrimary: Color(0xFF212121),
      onSecondary: Color(0xFF48832D),
      onSurface: Color(0xFF092509),
      onBackground: Color(0xFF000000),
      onError: Color(0xFFF4FAFF),
      brightness: Brightness.light,
    ),
  );

  static ThemeData darkTheme = ThemeData(
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF212121),
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(color: Colors.white),
    ),
    cardColor: const Color(0xFF625D5D),
    scaffoldBackgroundColor: const Color(0xFF212121),
    colorScheme: const ColorScheme(
      primary: Color(0xFF4DB666),
      secondary: Color(0xFF515B68),
      surface: Color(0xFF8B8E8F),
      background: Color(0xFF212121),
      error: Color(0xFFCD091B),
      onPrimary: Color(0xFFF4FAFF),
      onSecondary: Color(0xFFF4FAFF),
      onSurface: Color(0xFFF4FAFF),
      onBackground: Color(0xFFF4FAFF),
      onError: Color(0xFFF4FAFF),
      brightness: Brightness.dark,
    ),
  );

  static ButtonStyle primaryBtn() {
    return ElevatedButton.styleFrom(
      minimumSize: const Size.fromHeight(50),
      foregroundColor: Colors.white,
      backgroundColor: Color(0xFF1B4525),
      textStyle: const TextStyle(fontSize: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      side: BorderSide(color: Colors.black, width: 1),
    );
  }

  static ButtonStyle secondaryBtn(BuildContext context) {
    return ElevatedButton.styleFrom(
      foregroundColor: Theme.of(context).colorScheme.onBackground,
      backgroundColor: Colors.transparent,
      minimumSize: const Size.fromHeight(50),
      textStyle: const TextStyle(fontSize: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }
}
