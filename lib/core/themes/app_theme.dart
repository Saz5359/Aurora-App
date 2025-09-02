import 'package:flutter/material.dart';

class AppTheme {
  // Color Palette
  static const Color primaryTextColor = Color(0xFF04021D);
  static const Color secondaryTextColor = Color(0xFF686777);
  static const Color accentTextColor = Color(0xFF749A78);
  static const Color scaffoldBackgroundColor = Color(0xFFFFFFFF);

  // Light Theme
  static ThemeData appTheme = ThemeData(
    scaffoldBackgroundColor: scaffoldBackgroundColor,
    fontFamily: 'Poppins',
    colorScheme: const ColorScheme.light(
      primary: primaryTextColor,
      secondary: secondaryTextColor,
      tertiary: accentTextColor,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: scaffoldBackgroundColor,
    ),
  );
}
