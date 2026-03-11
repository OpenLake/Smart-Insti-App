import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class UltimateTheme {
  // Brand Colors
  static const Color primary = Color(0xFF6366F1); // Indigo-600
  static const Color secondary = Color(0xFF06B6D4); // Cyan-500
  static const Color accent = Color(0xFFF59E0B); // Amber-500
  static const Color navy = Color(0xFF1E293B); // Slate-800

  // Neutral Colors (Light)
  static const Color background = Color(0xFFF8FAFC); // Slate-50
  static const Color surface = Color(0xFFFFFFFF);
  static const Color textMain = Color(0xFF0F172A); // Slate-900
  static const Color textSub = Color(0xFF64748B); // Slate-500

  // Neutral Colors (Dark)
  static const Color darkBackground = Color(0xFF020617); // Slate-950
  static const Color darkSurface = Color(0xFF0F172A); // Slate-900
  static const Color darkTextMain = Color(0xFFF1F5F9); // Slate-100
  static const Color darkTextSub = Color(0xFF94A3B8); // Slate-400

  static LinearGradient get brandGradient => const LinearGradient(
        colors: [primary, Color(0xFF818CF8), secondary],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );

  static LinearGradient get brandGradientSoft => LinearGradient(
        colors: [
          primary.withValues(alpha: 0.1),
          secondary.withValues(alpha: 0.1)
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );

  static BoxDecoration get brandCardDecoration => BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: primary.withValues(alpha: 0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      );

  static ThemeData get lightThemeData => _buildTheme(Brightness.light);
  static ThemeData get darkThemeData => _buildTheme(Brightness.dark);

  static ThemeData _buildTheme(Brightness brightness) {
    final bool isDark = brightness == Brightness.dark;
    final Color bgColor = isDark ? darkBackground : background;
    final Color surfaceColor = isDark ? darkSurface : surface;
    final Color mainColor = isDark ? darkTextMain : textMain;
    final Color subColor = isDark ? darkTextSub : textSub;

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primary,
        primary: primary,
        secondary: secondary,
        surface: surfaceColor,
        error: const Color(0xFFEF4444),
        brightness: brightness,
      ),
      scaffoldBackgroundColor: bgColor,
      textTheme: _buildTextTheme(mainColor, subColor),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: mainColor),
        titleTextStyle: GoogleFonts.spaceGrotesk(
          color: mainColor,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      cardTheme: CardThemeData(
        color: surfaceColor,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: BorderSide(
            color:
                (isDark ? Colors.white : Colors.black).withValues(alpha: 0.05),
            width: 1,
          ),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 56),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          textStyle:
              GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 16),
          elevation: 0,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark ? darkSurface : surface,
        contentPadding: const EdgeInsets.all(18),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
              color: (isDark ? Colors.white : Colors.black)
                  .withValues(alpha: 0.1)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
              color: (isDark ? Colors.white : Colors.black)
                  .withValues(alpha: 0.05)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: primary, width: 2),
        ),
        hintStyle: GoogleFonts.inter(color: subColor, fontSize: 14),
      ),
    );
  }

  static TextTheme _buildTextTheme(Color mainColor, Color subColor) {
    return GoogleFonts.interTextTheme().copyWith(
      displayLarge: GoogleFonts.spaceGrotesk(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: mainColor,
        letterSpacing: -0.5,
      ),
      titleLarge: GoogleFonts.spaceGrotesk(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: mainColor,
      ),
      bodyLarge: GoogleFonts.inter(fontSize: 16, color: mainColor),
      bodyMedium: GoogleFonts.inter(fontSize: 14, color: subColor),
      labelLarge: GoogleFonts.inter(
          fontSize: 14, fontWeight: FontWeight.w600, color: mainColor),
    );
  }

  // Helper decorations
  static BoxDecoration get glassDecoration {
    return BoxDecoration(
      color: Colors.white.withValues(alpha: 0.05),
      borderRadius: BorderRadius.circular(24),
      border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
    );
  }

  static BoxDecoration bentoDecoration(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return BoxDecoration(
      color: isDark ? darkSurface : surface,
      borderRadius: BorderRadius.circular(24),
      border: Border.all(
        color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.05),
        width: 1.5,
      ),
      boxShadow: [
        BoxShadow(
          color: (isDark ? Colors.black : primary).withValues(alpha: 0.03),
          blurRadius: 20,
          offset: const Offset(0, 8),
        ),
      ],
    );
  }

  // Legacy support / Aliases
  static const Color primaryColor = primary;
  static const Color backgroundColor = background;
  static const Color surfaceColor = surface;
  static const Color textColor = textMain;
  static const Color accentColor = accent;
}
