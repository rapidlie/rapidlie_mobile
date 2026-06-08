import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  // Brand
  static const primary = Color(0xFF3E62F0);
  static const primaryLight = Color(0xFFDBE8F8);
  static const primaryDeep = Color(0xFF137AF3);
  static const secondary = Color(0xFF092147);

  // Light surfaces
  static const lightBackground = Color(0xFFF8F9FB);
  static const lightSurface = Color(0xFFFFFFFF);
  static const lightCard = Color(0xFFFFFFFF);
  static const lightBorder = Color(0xFFE8ECF4);

  // Dark surfaces
  static const darkBackground = Color(0xFF0A0F1E);
  static const darkSurface = Color(0xFF111827);
  static const darkCard = Color(0xFF1A2235);
  static const darkBorder = Color(0xFF2A3448);

  // Semantic
  static const success = Color(0xFF24AE5F);
  static const successBg = Color(0xFFEBFAF1);
  static const warning = Color(0xFFE57E25);
  static const warningBg = Color(0xFFFFF1E6);
  static const info = Color(0xFF00ACE9);
  static const infoBg = Color(0xFFCDF1FF);
  static const error = Color(0xFFE53935);
  static const errorBg = Color(0xFFFFEBEE);
}

class AppTheme {
  static TextTheme _buildTextTheme(TextTheme base) {
    return GoogleFonts.interTextTheme(base).copyWith(
      displayLarge: GoogleFonts.inter(
          fontSize: 32, fontWeight: FontWeight.w700, letterSpacing: -0.5),
      displayMedium: GoogleFonts.inter(
          fontSize: 26, fontWeight: FontWeight.w700, letterSpacing: -0.3),
      displaySmall: GoogleFonts.inter(
          fontSize: 22, fontWeight: FontWeight.w600),
      headlineLarge: GoogleFonts.inter(
          fontSize: 20, fontWeight: FontWeight.w700),
      headlineMedium: GoogleFonts.inter(
          fontSize: 18, fontWeight: FontWeight.w600),
      headlineSmall: GoogleFonts.inter(
          fontSize: 16, fontWeight: FontWeight.w600),
      titleLarge: GoogleFonts.inter(
          fontSize: 16, fontWeight: FontWeight.w600),
      titleMedium: GoogleFonts.inter(
          fontSize: 14, fontWeight: FontWeight.w500),
      titleSmall: GoogleFonts.inter(
          fontSize: 13, fontWeight: FontWeight.w500),
      bodyLarge: GoogleFonts.inter(
          fontSize: 16, fontWeight: FontWeight.w400, height: 1.5),
      bodyMedium: GoogleFonts.inter(
          fontSize: 14, fontWeight: FontWeight.w400, height: 1.5),
      bodySmall: GoogleFonts.inter(
          fontSize: 12, fontWeight: FontWeight.w400, height: 1.5),
      labelLarge: GoogleFonts.inter(
          fontSize: 14, fontWeight: FontWeight.w600),
      labelMedium: GoogleFonts.inter(
          fontSize: 12, fontWeight: FontWeight.w500),
      labelSmall: GoogleFonts.inter(
          fontSize: 11, fontWeight: FontWeight.w500),
    );
  }

  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.lightBackground,
    primaryColor: AppColors.primary,
    textTheme: _buildTextTheme(ThemeData.light().textTheme.apply(
          bodyColor: const Color(0xFF0D1117),
          displayColor: const Color(0xFF0D1117),
        )),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.lightSurface,
      foregroundColor: const Color(0xFF0D1117),
      elevation: 0,
      scrolledUnderElevation: 0.5,
      shadowColor: AppColors.lightBorder,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      titleTextStyle: GoogleFonts.inter(
        color: const Color(0xFF0D1117),
        fontSize: 17,
        fontWeight: FontWeight.w600,
      ),
      iconTheme: const IconThemeData(color: Color(0xFF0D1117), size: 24),
    ),
    colorScheme: const ColorScheme.light(
      primary: AppColors.primary,
      onPrimary: Colors.white,
      secondary: AppColors.primaryDeep,
      onSecondary: Colors.white,
      surface: AppColors.lightSurface,
      onSurface: Color(0xFF0D1117),
      error: AppColors.error,
      onError: Colors.white,
      outline: AppColors.lightBorder,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: AppColors.primary,
        elevation: 0,
        shadowColor: Colors.transparent,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w600),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primary,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        side: const BorderSide(color: AppColors.primary, width: 1.5),
        textStyle: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w600),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primary,
        textStyle: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.lightSurface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.lightBorder),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.lightBorder, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.error, width: 1),
      ),
      labelStyle: GoogleFonts.inter(color: const Color(0xFF6B7280)),
      hintStyle: GoogleFonts.inter(color: const Color(0xFF9CA3AF)),
      contentPadding:
          const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
    ),
    cardTheme: CardThemeData(
      color: AppColors.lightCard,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.lightBorder, width: 1),
      ),
      margin: EdgeInsets.zero,
    ),
    chipTheme: ChipThemeData(
      backgroundColor: AppColors.lightBackground,
      selectedColor: AppColors.primary.withValues(alpha: 0.12),
      labelStyle: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w500),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: AppColors.lightSurface,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: const Color(0xFF9CA3AF),
      elevation: 8,
      selectedLabelStyle:
          GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600),
      unselectedLabelStyle:
          GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w400),
    ),
    tabBarTheme: TabBarThemeData(
      labelColor: AppColors.primary,
      unselectedLabelColor: const Color(0xFF9CA3AF),
      indicatorColor: AppColors.primary,
      indicatorSize: TabBarIndicatorSize.label,
      labelStyle: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600),
      unselectedLabelStyle:
          GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w400),
      dividerColor: AppColors.lightBorder,
    ),
    dividerTheme: const DividerThemeData(
      color: AppColors.lightBorder,
      thickness: 1,
      space: 1,
    ),
    iconTheme: const IconThemeData(color: Color(0xFF374151), size: 24),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      elevation: 4,
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: const Color(0xFF1A2235),
      contentTextStyle: GoogleFonts.inter(color: Colors.white, fontSize: 14),
      behavior: SnackBarBehavior.floating,
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: AppColors.lightSurface,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: AppColors.lightSurface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      showDragHandle: true,
    ),
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.darkBackground,
    primaryColor: AppColors.primary,
    textTheme: _buildTextTheme(ThemeData.dark().textTheme.apply(
          bodyColor: const Color(0xFFE5E7EB),
          displayColor: Colors.white,
        )),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.darkSurface,
      foregroundColor: Colors.white,
      elevation: 0,
      scrolledUnderElevation: 0.5,
      shadowColor: AppColors.darkBorder,
      systemOverlayStyle: SystemUiOverlayStyle.light,
      titleTextStyle: GoogleFonts.inter(
        color: Colors.white,
        fontSize: 17,
        fontWeight: FontWeight.w600,
      ),
      iconTheme: const IconThemeData(color: Colors.white, size: 24),
    ),
    colorScheme: const ColorScheme.dark(
      primary: AppColors.primary,
      onPrimary: Colors.white,
      secondary: AppColors.primaryDeep,
      onSecondary: Colors.white,
      surface: AppColors.darkSurface,
      onSurface: Colors.white,
      error: AppColors.error,
      onError: Colors.white,
      outline: AppColors.darkBorder,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: AppColors.primary,
        elevation: 0,
        shadowColor: Colors.transparent,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w600),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primary,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        side: const BorderSide(color: AppColors.primary, width: 1.5),
        textStyle: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w600),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primary,
        textStyle: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.darkCard,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.darkBorder),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.darkBorder, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.error, width: 1),
      ),
      labelStyle: GoogleFonts.inter(color: const Color(0xFF9CA3AF)),
      hintStyle: GoogleFonts.inter(color: const Color(0xFF6B7280)),
      contentPadding:
          const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
    ),
    cardTheme: CardThemeData(
      color: AppColors.darkCard,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.darkBorder, width: 1),
      ),
      margin: EdgeInsets.zero,
    ),
    chipTheme: ChipThemeData(
      backgroundColor: AppColors.darkCard,
      selectedColor: AppColors.primary.withValues(alpha: 0.2),
      labelStyle: GoogleFonts.inter(
          fontSize: 13, fontWeight: FontWeight.w500, color: Colors.white),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: AppColors.darkSurface,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: const Color(0xFF6B7280),
      elevation: 8,
      selectedLabelStyle:
          GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600),
      unselectedLabelStyle:
          GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w400),
    ),
    tabBarTheme: TabBarThemeData(
      labelColor: AppColors.primary,
      unselectedLabelColor: const Color(0xFF6B7280),
      indicatorColor: AppColors.primary,
      indicatorSize: TabBarIndicatorSize.label,
      labelStyle: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600),
      unselectedLabelStyle:
          GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w400),
      dividerColor: AppColors.darkBorder,
    ),
    dividerTheme: const DividerThemeData(
      color: AppColors.darkBorder,
      thickness: 1,
      space: 1,
    ),
    iconTheme: const IconThemeData(color: Color(0xFFD1D5DB), size: 24),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      elevation: 4,
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: AppColors.darkCard,
      contentTextStyle: GoogleFonts.inter(color: Colors.white, fontSize: 14),
      behavior: SnackBarBehavior.floating,
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: AppColors.darkSurface,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: AppColors.darkSurface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      showDragHandle: true,
    ),
  );
}
