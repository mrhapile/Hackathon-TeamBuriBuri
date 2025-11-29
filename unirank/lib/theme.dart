import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class UniRankTheme {
  // Colors
  static const Color bg = Color(0xFFFFFFFF); // Pure white background
  static const Color cardBg = Color(0xFFFFFFFF); // White for cards
  static const Color accent = Color(0xFF62C370); // Mint Green
  static const Color mintGreenLight = Color(0xFFBEEAC5);
  static const Color softSlate = Color(0xFF9A9A9A);
  static const Color textMain = Color(0xFF111111);
  static const Color textSecondary = Color(0xFF6B6B6B);
  static const Color border = Color(0xFFEDEDED);
  static const Color softGray = Color(0xFFF2F2F7); // iOS system gray 6ish

  static final BoxShadow softShadow = BoxShadow(
    color: Colors.black.withValues(alpha: 0.05),
    blurRadius: 20,
    offset: const Offset(0, 4),
  );

  static ThemeData theme() {
    final base = ThemeData.light();
    return base.copyWith(
      scaffoldBackgroundColor: bg,
      primaryColor: accent,
      textTheme: GoogleFonts.interTextTheme(base.textTheme).apply(
        bodyColor: textMain,
        displayColor: textMain,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: bg,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: textMain),
        titleTextStyle: TextStyle(
          color: textMain,
          fontSize: 18,
          fontWeight: FontWeight.w600,
          fontFamily: 'Inter',
        ),
      ),
      cardColor: cardBg,
      colorScheme: const ColorScheme.light(
        primary: accent,
        secondary: accent,
        surface: cardBg,
        onSurface: textMain,
      ),
      dividerColor: border,
    );
  }

  // Text Styles
  static TextStyle heading(double size) => GoogleFonts.inter(
        fontSize: size,
        fontWeight: FontWeight.w600,
        color: textMain,
        letterSpacing: -0.5,
      );

  static TextStyle body(double size) => GoogleFonts.inter(
        fontSize: size,
        fontWeight: FontWeight.w400,
        color: textSecondary,
      );

  static TextStyle label(double size) => GoogleFonts.inter(
        fontSize: size,
        fontWeight: FontWeight.w500,
        color: textMain,
      );
}
