import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color primaryGold = Color(0xFFFFD700);
  static const Color deepNavy = Color(0xFF0A0E21);
  static const Color lightBlue = Color(0xFF1D2136);
  static const Color accentCyan = Color(0xFF00E5FF);

  static ThemeData darkTheme = ThemeData.dark().copyWith(
    primaryColor: primaryGold,
    scaffoldBackgroundColor: deepNavy,
    cardColor: lightBlue,
    textTheme: GoogleFonts.outfitTextTheme(ThemeData.dark().textTheme),
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryGold,
      brightness: Brightness.dark,
      secondary: accentCyan,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryGold,
        foregroundColor: deepNavy,
        textStyle: const TextStyle(fontWeight: FontWeight.bold),
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
  );
}
