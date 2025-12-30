import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/user_role.dart';

class AppThemes {
  static ThemeData getTheme(UserRole role) {
    switch (role) {
      case UserRole.adultMale:
        return _maleTheme;
      case UserRole.adultFemale:
        return _femaleTheme;
      case UserRole.child:
        return _childTheme;
    }
  }

  static final ThemeData _maleTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF1E3A5F),
      primary: const Color(0xFF1E3A5F),
      secondary: const Color(0xFF4A90A4),
      surface: const Color(0xFFF8FAFC),
      background: const Color(0xFFF0F4F8),
    ),
    textTheme: GoogleFonts.cairoTextTheme(),
    cardTheme: CardThemeData(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
  );

  static final ThemeData _femaleTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFFBE4B6E),
      primary: const Color(0xFFBE4B6E),
      secondary: const Color(0xFFF4A5B8),
      surface: const Color(0xFFFFF5F7),
      background: const Color(0xFFFCE8EC),
    ),
    textTheme: GoogleFonts.cairoTextTheme(),
    cardTheme: CardThemeData(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
  );

  static final ThemeData _childTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF22C55E),
      primary: const Color(0xFF22C55E),
      secondary: const Color(0xFFFBBF24),
      tertiary: const Color(0xFF3B82F6),
      surface: const Color(0xFFFFFBEB),
      background: const Color(0xFFF0FDF4),
    ),
    textTheme: GoogleFonts.lalezarTextTheme(),
    cardTheme: CardThemeData(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
    ),
  );
}
