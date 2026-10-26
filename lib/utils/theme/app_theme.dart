import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lost_and_found/utils/colors/color_schemes.dart';
import 'package:lost_and_found/utils/colors/custom_color.dart';

/// Standardized design radius tokens
class AppRadius {
  static const double card = 16.0;
  static const double input = 16.0;
  static const double button = 16.0;
  static const double pill = 24.0;
  static const double badge = 24.0;
  static const double modalTop = 24.0;
  static const double small = 12.0;
}

/// Standardized typography using Playfair Display (Serif) & Inter (Sans-Serif)
class AppTypography {
  /// Elegant Serif for screen titles, headings, and branding
  static TextStyle serifTitle(
    BuildContext context, {
    double fontSize = 28,
    FontWeight fontWeight = FontWeight.bold,
    Color? color,
  }) {
    final defaultColor = Theme.of(context).colorScheme.onSurface;
    return GoogleFonts.playfairDisplay(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color ?? defaultColor,
      letterSpacing: -0.5,
    );
  }

  /// Elegant Serif for sub-headings
  static TextStyle serifHeading(
    BuildContext context, {
    double fontSize = 22,
    FontWeight fontWeight = FontWeight.w600,
    Color? color,
  }) {
    final defaultColor = Theme.of(context).colorScheme.onSurface;
    return GoogleFonts.playfairDisplay(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color ?? defaultColor,
      letterSpacing: -0.3,
    );
  }

  /// Clean geometric Sans-Serif for body text
  static TextStyle sansBody(
    BuildContext context, {
    double fontSize = 14,
    FontWeight fontWeight = FontWeight.normal,
    Color? color,
    double? height,
  }) {
    final defaultColor = Theme.of(context).colorScheme.onSurface;
    return GoogleFonts.inter(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color ?? defaultColor,
      height: height,
    );
  }

  /// Clean geometric Sans-Serif for bold accents/subtitles
  static TextStyle sansBold(
    BuildContext context, {
    double fontSize = 16,
    FontWeight fontWeight = FontWeight.w600,
    Color? color,
  }) {
    final defaultColor = Theme.of(context).colorScheme.onSurface;
    return GoogleFonts.inter(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color ?? defaultColor,
    );
  }

  /// Clean geometric Sans-Serif for muted secondary text
  static TextStyle sansSecondary(
    BuildContext context, {
    double fontSize = 13,
    FontWeight fontWeight = FontWeight.normal,
    Color? color,
    double? height,
  }) {
    final secColor = Theme.of(context).extension<CustomColors>()?.secondaryTextColor ?? const Color(0xFF8F99A8);
    return GoogleFonts.inter(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color ?? secColor,
      height: height,
    );
  }

  /// Uppercase tracking labels for form fields & badges
  static TextStyle uppercaseLabel(
    BuildContext context, {
    double fontSize = 11,
    FontWeight fontWeight = FontWeight.w700,
    Color? color,
    double letterSpacing = 1.3,
  }) {
    final secColor = Theme.of(context).extension<CustomColors>()?.secondaryTextColor ?? const Color(0xFF8F99A8);
    return GoogleFonts.inter(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color ?? secColor,
      letterSpacing: letterSpacing,
    );
  }
}

/// Application Theme builder
class AppTheme {
  static CustomColors colors(BuildContext context) {
    return Theme.of(context).extension<CustomColors>() ?? lightCustomColors;
  }

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: const Color(0xFFFBF9F6),
      colorScheme: lightColorScheme,
      extensions: [lightCustomColors],
      fontFamily: GoogleFonts.inter().fontFamily,
      cardTheme: CardThemeData(
        color: const Color(0xFFFFFFFF),
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.card),
          side: const BorderSide(color: Color(0xFFEDE8E1), width: 1),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFFF3EFEA),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.input),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.input),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.input),
          borderSide: const BorderSide(color: Color(0xFF52C46A), width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.input),
          borderSide: const BorderSide(color: Color(0xFFA61C32), width: 1.5),
        ),
        hintStyle: GoogleFonts.inter(color: const Color(0xFF9C8B7A), fontSize: 14),
        labelStyle: GoogleFonts.inter(color: const Color(0xFF9C8B7A), fontSize: 14),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: const Color(0xFF52C46A),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.button),
          ),
          textStyle: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: const Color(0xFF1E232A),
          side: const BorderSide(color: Color(0xFF9C8B7A), width: 1.2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.button),
          ),
          textStyle: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFFFBF9F6),
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        iconTheme: IconThemeData(color: Color(0xFF1E232A)),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: const Color(0xFFFFFFFF),
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.card)),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: const Color(0xFF0B101D),
      colorScheme: darkColorScheme,
      extensions: [darkCustomColors],
      fontFamily: GoogleFonts.inter().fontFamily,
      cardTheme: CardThemeData(
        color: const Color(0xFF131A2B),
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.card),
          side: const BorderSide(color: Color(0xFF1F2B45), width: 1),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF131A2B),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.input),
          borderSide: const BorderSide(color: Color(0xFF1F2B45), width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.input),
          borderSide: const BorderSide(color: Color(0xFF1F2B45), width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.input),
          borderSide: const BorderSide(color: Color(0xFF63D279), width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.input),
          borderSide: const BorderSide(color: Color(0xFFA61C32), width: 1.5),
        ),
        hintStyle: GoogleFonts.inter(color: const Color(0xFF8F99A8), fontSize: 14),
        labelStyle: GoogleFonts.inter(color: const Color(0xFF8F99A8), fontSize: 14),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: const Color(0xFF63D279),
          foregroundColor: const Color(0xFF0B101D),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.button),
          ),
          textStyle: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.white,
          side: const BorderSide(color: Color(0xFF8F99A8), width: 1.2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.button),
          ),
          textStyle: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF0B101D),
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: const Color(0xFF131A2B),
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.card)),
      ),
    );
  }
}
