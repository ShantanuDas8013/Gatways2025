import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Defines the color palette and text styles for the Cyberpunk theme.
class CyberpunkTheme {
  // --- CORE COLORS ---
  // Deep, nearly-black base used for backgrounds and panels
  static const Color primaryBlack = Color(0xFF05040A);
  static const Color background = Color(0xFF0B0711);

  // Neon accents inspired by Cyberpunk 2077
  static const Color neonYellow = Color(
    0xFFFFD400,
  ); // signature Cyberpunk yellow
  static const Color neonCyan = Color(0xFF00F0FF);
  static const Color neonPink = Color(0xFFFF2D95);
  static const Color neonOrange = Color(0xFFFF7A00);
  static const Color holoBlue = Color(0xFF63F3FF);

  // --- UI ELEMENT COLORS ---
  static const Color textPrimary = Color(0xFFEFEFF1);
  static const Color textSecondary = Color(0xFFB6B6C0);
  static const Color muted = Color(0xFF8A8892);
  static const Color shadow = Color(0x99000000);

  // --- GRADIENTS ---
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF1B0036), Color(0xFF0B0711)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // Neon sweep gradient used for glows, buttons and highlights
  static const LinearGradient neonGradient = LinearGradient(
    colors: [neonCyan, neonYellow, neonPink],
    stops: [0.0, 0.5, 1.0],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  // --- UI HELPERS ---
  // Dynamic neon glow box shadows (getter because of opacity calls)
  static List<BoxShadow> get neonGlow => [
    BoxShadow(
      color: neonCyan.withOpacity(0.22),
      blurRadius: 20,
      spreadRadius: 1,
    ),
    BoxShadow(
      color: neonPink.withOpacity(0.12),
      blurRadius: 40,
      spreadRadius: 2,
    ),
    BoxShadow(color: shadow, blurRadius: 6, offset: Offset(2, 2)),
  ];

  // --- TEXT STYLES ---
  static TextStyle get headlineStyle {
    return GoogleFonts.rajdhani(
      fontSize: 46,
      fontWeight: FontWeight.w800,
      color: neonYellow,
      letterSpacing: 3.0,
      shadows: [
        Shadow(color: neonYellow.withOpacity(0.95), blurRadius: 14),
        Shadow(color: neonPink.withOpacity(0.65), blurRadius: 28),
        Shadow(color: shadow, blurRadius: 3, offset: Offset(2, 2)),
      ],
    );
  }

  static TextStyle get subtitleStyle {
    return GoogleFonts.rajdhani(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: textSecondary,
      letterSpacing: 1.4,
      shadows: [Shadow(color: holoBlue.withOpacity(0.12), blurRadius: 6)],
    );
  }

  static TextStyle get loadingStyle {
    return GoogleFonts.rajdhani(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: neonCyan.withOpacity(0.92),
      letterSpacing: 1.2,
      shadows: [Shadow(color: neonCyan.withOpacity(0.16), blurRadius: 8)],
    );
  }

  static TextStyle get versionStyle {
    return GoogleFonts.rajdhani(
      fontSize: 12,
      fontWeight: FontWeight.w300,
      color: textSecondary.withOpacity(0.6),
      letterSpacing: 1.0,
    );
  }

  // --- THEME DATA ---
  // A ready-to-use ThemeData that applies the neon palette and text styles across the app.
  static ThemeData get theme {
    final base = ThemeData.dark();
    return base.copyWith(
      scaffoldBackgroundColor: background,
      primaryColor: neonCyan,
      colorScheme: base.colorScheme.copyWith(
        primary: neonCyan,
        secondary: neonPink,
        background: background,
      ),
      textTheme: GoogleFonts.rajdhaniTextTheme(
        base.textTheme,
      ).apply(bodyColor: textPrimary, displayColor: textPrimary),
      appBarTheme: base.appBarTheme.copyWith(
        backgroundColor: Colors.transparent,
        elevation: 0,
        titleTextStyle: headlineStyle,
        toolbarTextStyle: subtitleStyle,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: primaryBlack,
          backgroundColor: neonPink,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          elevation: 8,
          shadowColor: neonPink.withOpacity(0.25),
        ),
      ),
      cardColor: Color(0xFF100A12),
      dividerColor: muted.withOpacity(0.2),
    );
  }
}
