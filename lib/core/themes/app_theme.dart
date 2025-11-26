import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFF1a1a2e);
  static const Color cardColor = Color(0xFF16213e);
  static const Color accentColor = Colors.blue;

  static ThemeData darkTheme = ThemeData(
    primarySwatch: Colors.blue,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: primaryColor,
    cardColor: cardColor,
    appBarTheme: AppBarTheme(
      backgroundColor: primaryColor,
      elevation: 0,
      centerTitle: true,
    ),
  );
}