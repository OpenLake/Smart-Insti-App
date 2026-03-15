import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class UltimateTheme {
  // Brand Colors from Guide
  static const Color primary = Color(0xFF504EC6); // 01
  static const Color secondary = Color(0xFFC8CCED); // 02
  static const Color accent = Color(0xFF313131); // 03
  static const Color skeletonGrey = Color(0xFFE3E3E3); // 04
  static const Color background = Color(0xFFF0EDF9); // 05

  // Neutral Colors (Light)
  static const Color surface = Color(0xFFFFFFFF);
  static const Color textMain = Color(0xFF313131);
  static const Color textSub = Color(0xFF64748B);

  // Neutral Colors (Dark)
  static const Color darkBackground = Color(0xFF0F172A);
  static const Color darkSurface = Color(0xFF1E293B);
  static const Color darkTextMain = Color(0xFFF1F5F9);
  static const Color darkTextSub = Color(0xFF94A3B8);

  // Additional design colors derived from skeleton
  static const Color skeletonBrown = Color(0xFFC48154);
  static const Color skeletonRed = Color(0xFFF1655E);
  static const Color skeletonYellow = Color(0xFFFFC107);

  static LinearGradient get brandGradient => const LinearGradient(
        colors: [primary, Color(0xFF6366F1), secondary],
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
        background: bgColor,
        onBackground: mainColor,
        onSurface: mainColor,
        error: skeletonRed,
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
      iconTheme: IconThemeData(color: mainColor),
      dividerTheme: DividerThemeData(
        color: mainColor.withValues(alpha: 0.1),
        thickness: 1,
      ),
      cardTheme: CardThemeData(
        color: surfaceColor,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: BorderSide(
            color: mainColor.withValues(alpha: 0.05),
            width: 1,
          ),
        ),
      ),
      drawerTheme: DrawerThemeData(
        backgroundColor: surfaceColor,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.horizontal(right: Radius.circular(32)),
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: surfaceColor,
        selectedItemColor: primary,
        unselectedItemColor: subColor,
        elevation: 0,
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
        fillColor: surfaceColor,
        contentPadding: const EdgeInsets.all(18),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: mainColor.withValues(alpha: 0.1)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: mainColor.withValues(alpha: 0.05)),
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
      displayMedium: GoogleFonts.spaceGrotesk(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: mainColor,
      ),
      displaySmall: GoogleFonts.spaceGrotesk(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: mainColor,
      ),
      headlineLarge: GoogleFonts.spaceGrotesk(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: mainColor,
      ),
      titleLarge: GoogleFonts.spaceGrotesk(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: mainColor,
      ),
      titleMedium: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: mainColor,
      ),
      bodyLarge: GoogleFonts.inter(fontSize: 16, color: mainColor),
      bodyMedium: GoogleFonts.inter(fontSize: 14, color: subColor),
      labelLarge: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: mainColor,
      ),
    );
  }

  // Semantic Design Tokens
  static BoxDecoration bentoDecoration(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final mainColor = isDark ? darkTextMain : textMain;
    final surfaceColor = isDark ? darkSurface : surface;

    return BoxDecoration(
      color: surfaceColor,
      borderRadius: BorderRadius.circular(24),
      border: Border.all(
        color: mainColor.withValues(alpha: 0.05),
        width: 1.5,
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.02),
          blurRadius: 20,
          offset: const Offset(0, 8),
        ),
      ],
    );
  }

  // Legacy support aliases
  static const Color primaryColor = primary;
  static const Color backgroundColor = background;
  static const Color surfaceColor = surface;
  static const Color accentColor = accent;
  static const Color textColor = textMain;
  static const Color navy = Color(0xFF1E293B);

  static BoxDecoration get brandCardDecoration => BoxDecoration(
        color: surface,
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
}
