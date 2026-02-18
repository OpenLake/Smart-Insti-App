import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class UltimateTheme {
  static const Color primary = Color(0xFF5B3482); // IIT Bhilai Purple
  static const Color accent = Color(0xFF1FA6E0); // OpenLake Blue
  static const Color navy = Color(0xFF0D2137); // OpenLake Dark Navy
  static const Color background = Color(0xFFF8F9FE); // Very light lilac tint
  static const Color surface = Color(0xFFFFFFFF); // Pure White for cards
  static const Color textMain = Color(0xFF1E1B4B); // Deep indigo text
  static const Color textSub = Color(0xFF64748B); // Slate

  static LinearGradient get brandGradient => const LinearGradient(
        colors: [primary, Color(0xFF7C3AED), accent],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );

  static LinearGradient get brandGradientSoft => LinearGradient(
        colors: [primary.withOpacity(0.8), accent.withOpacity(0.8)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );

  static ThemeData get lightThemeData {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primary,
        primary: primary,
        secondary: accent,
        tertiary: navy,
        surface: surface,
        background: background,
        brightness: Brightness.light,
      ),
      scaffoldBackgroundColor: background,
      textTheme: _textTheme(textMain, textSub),
      appBarTheme: _appBarTheme(primary, Colors.white),
      cardTheme: _cardTheme(surface, false),
      navigationBarTheme: _navBarTheme(Colors.white, textSub, primary),
    );
  }

  static ThemeData get darkThemeData {
    // Dark Mode Colors
    const darkBackground = Color(0xFF121212);
    const darkSurface = Color(0xFF1E1E1E);
    const darkTextMain = Color(0xFFE0E0E0);
    const darkTextSub = Color(0xFFA0A0A0);

    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primary,
        primary: primary, // Keep brand color
        secondary: accent,
        tertiary: navy,
        surface: darkSurface,
        background: darkBackground,
        brightness: Brightness.dark,
      ),
      scaffoldBackgroundColor: darkBackground,
      textTheme: _textTheme(darkTextMain, darkTextSub),
      appBarTheme: _appBarTheme(darkSurface, darkTextMain),
      cardTheme: _cardTheme(darkSurface, true),
      navigationBarTheme: _navBarTheme(darkSurface, darkTextSub, primary),
    );
  }

  static TextTheme _textTheme(Color mainColor, Color subColor) {
      return GoogleFonts.interTextTheme().copyWith(
        displayLarge: GoogleFonts.spaceGrotesk(fontSize: 32, fontWeight: FontWeight.bold, color: mainColor, letterSpacing: -1.0),
        titleLarge: GoogleFonts.spaceGrotesk(fontSize: 22, fontWeight: FontWeight.bold, color: mainColor),
        bodyLarge: GoogleFonts.inter(fontSize: 16, color: mainColor),
        bodyMedium: GoogleFonts.inter(fontSize: 14, color: subColor),
      );
  }

  static AppBarTheme _appBarTheme(Color bgColor, Color itemsColor) {
      return AppBarTheme(
        backgroundColor: bgColor,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: itemsColor, size: 24),
        titleTextStyle: GoogleFonts.spaceGrotesk(color: itemsColor, fontSize: 20, fontWeight: FontWeight.bold),
      );
  }

  static CardThemeData _cardTheme(Color color, bool isDark) {
      return CardThemeData(
        color: color,
        elevation: 2,
        shadowColor: isDark ? Colors.black.withOpacity(0.3) : primary.withOpacity(0.1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        margin: EdgeInsets.zero,
      );
  }

  static NavigationBarThemeData _navBarTheme(Color bgColor, Color unselectedColor, Color selectedColor) {
      return NavigationBarThemeData(
        backgroundColor: bgColor,
        indicatorColor: selectedColor.withOpacity(0.1),
        iconTheme: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return IconThemeData(color: selectedColor, size: 26);
          }
          return IconThemeData(color: unselectedColor, size: 24);
        }),
      );
  }

  static BoxDecoration get bentoDecoration {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(24),
      border: Border.all(color: primary.withOpacity(0.05), width: 1.5),
      boxShadow: [
        BoxShadow(
          color: primary.withOpacity(0.03),
          blurRadius: 15,
          offset: const Offset(0, 8),
        ),
      ],
    );
  }

  static BoxDecoration get brandCardDecoration {
    return BoxDecoration(
      gradient: brandGradient,
      borderRadius: BorderRadius.circular(24),
      boxShadow: [
        BoxShadow(
          color: primary.withOpacity(0.3),
          blurRadius: 20,
          offset: const Offset(0, 10),
        ),
      ],
    );
  }
  // Aliases for compatibility
  static const Color primaryColor = primary;
  static const Color backgroundColor = background;
  static const Color surfaceColor = surface;
  static const Color textColor = textMain;
}
