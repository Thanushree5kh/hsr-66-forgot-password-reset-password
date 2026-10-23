import 'package:flutter/material.dart';

/// Design system color palette:
/// - Primary: #1565C0 (Royal Blue — buttons, active accents, focus)
/// - Royal Blue: #1565C0
/// - Sky Blue: #1976D2
/// - Light Sky Blue: #42A5F5
/// - Ice Blue: #80D8FF
/// - Brand Green: #0F4735 (Deep Forest Green — NEET text & ECG heartbeat wave)
/// - Mint Green: #7ED9B5 (Soft Mint for cross, botanical leaves)
/// - Periwinkle Blue: #6B72B8 (Character shirt & doodle accents)
/// - Soft Blue: #1976D2 (Active focus borders & icons)
/// - Doodle Light Blue: #A4B6D8 (Floating atom, book outlines, dashed lines)
/// - Background: #F0F5FA (Clean, calm soft sky/periwinkle backdrop)
/// - Surface: #FFFFFF (Pure White card)
/// - Text Primary: #1E2640 (Deep Navy / Charcoal)
/// - Text Secondary: #677489 (Muted Cool Slate)
class AppColors {
  static const primary = Color(0xFF1565C0); // Royal Blue
  static const primaryHover = Color(0xFF0D47A1); // Deep Navy Blue
  static const brandGreen = Color(0xFF0F4735); // Deep Forest Green
  static const mintGreen = Color(0xFF7ED9B5); // Soft Mint
  static const periwinkle = Color(0xFF6B72B8);
  static const softBlue = Color(0xFF1976D2);
  static const doodleBlue = Color(0xFFA4B6D8);
  static const background = Color(0xFFF0F5FA);
  static const surface = Color(0xFFFFFFFF);
  static const cardBackground = Color(0xFFF7FAFD);
  static const border = Color(0xFFE2E8F0);
  static const inputBorder = Color(0xFFD3DFEE);
  static const outlineVariant = Color(0xFFD1D5DB);
  static const textPrimary = Color(0xFF1E2640);
  static const textSecondary = Color(0xFF677489);
  static const error = Color(0xFFDC2626);

  // Blue Theme additions:
  static const royalBlue = Color(0xFF1565C0);
  static const skyBlue = Color(0xFF1976D2);
  static const lightSkyBlue = Color(0xFF42A5F5);
  static const iceBlue = Color(0xFF80D8FF);
}

ThemeData buildLightTheme() {
  const baseScheme = ColorScheme(
    brightness: Brightness.light,
    primary: AppColors.primary,
    onPrimary: Colors.white,
    primaryContainer: Color(0xFFE3F2FD),
    onPrimaryContainer: AppColors.primary,
    secondary: AppColors.softBlue,
    onSecondary: Colors.white,
    secondaryContainer: Color(0xFFE8EEFB),
    onSecondaryContainer: AppColors.softBlue,
    surface: AppColors.surface,
    onSurface: AppColors.textPrimary,
    onSurfaceVariant: AppColors.textSecondary,
    outline: AppColors.border,
    outlineVariant: AppColors.inputBorder,
    error: AppColors.error,
    onError: Colors.white,
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: baseScheme,
    scaffoldBackgroundColor: AppColors.background,
    fontFamily: 'Inter',
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      iconTheme: IconThemeData(color: AppColors.textPrimary),
      titleTextStyle: TextStyle(
        color: AppColors.textPrimary,
        fontWeight: FontWeight.bold,
        fontSize: 18,
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        minimumSize: const Size(double.infinity, 54),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28),
        ),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      labelStyle: const TextStyle(
        color: AppColors.textSecondary,
        fontSize: 14.5,
      ),
      hintStyle: const TextStyle(
        color: AppColors.textSecondary,
        fontSize: 14,
      ),
      prefixIconColor: AppColors.softBlue,
      suffixIconColor: AppColors.textSecondary,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.inputBorder),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.inputBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.softBlue, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.error, width: 2),
      ),
    ),
    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: AppColors.border),
      ),
    ),
  );
}

ThemeData buildDarkTheme() {
  return ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.dark,
    ),
    fontFamily: 'Inter',
  );
}
