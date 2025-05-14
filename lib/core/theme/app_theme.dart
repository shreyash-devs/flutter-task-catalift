import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/colors.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    primaryColor: AppColors.primaryColor,
    scaffoldBackgroundColor: AppColors.backgroundColor,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primaryColor,
      primary: AppColors.primaryColor,
      secondary: AppColors.accentColor,
      tertiary: AppColors.highlightColor,
      surface: AppColors.cardBackgroundColor,
      onSurface: AppColors.textPrimary,
      background: AppColors.backgroundColor,
      error: AppColors.errorColor,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.primaryColor,
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: GoogleFonts.poppins(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: Colors.white,
        letterSpacing: 0.5,
      ),
      iconTheme: const IconThemeData(color: Colors.white, size: 20),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
    ),
    cardTheme: CardTheme(
      color: AppColors.cardColor,
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.withOpacity(0.1), width: 1),
      ),
    ),
    dividerTheme: DividerThemeData(
      color: Colors.grey.withOpacity(0.15),
      thickness: 1,
      space: 1,
    ),
    textTheme: GoogleFonts.poppinsTextTheme().copyWith(
      displayLarge: GoogleFonts.poppins(
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
        fontSize: 32,
        height: 1.2,
        letterSpacing: -0.5,
      ),
      displayMedium: GoogleFonts.poppins(
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
        fontSize: 28,
        height: 1.2,
        letterSpacing: -0.5,
      ),
      displaySmall: GoogleFonts.poppins(
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
        fontSize: 24,
        height: 1.2,
      ),
      headlineLarge: GoogleFonts.poppins(
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
        fontSize: 22,
        height: 1.3,
      ),
      headlineMedium: GoogleFonts.poppins(
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
        fontSize: 20,
        height: 1.3,
      ),
      headlineSmall: GoogleFonts.poppins(
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
        fontSize: 18,
        height: 1.4,
      ),
      titleLarge: GoogleFonts.poppins(
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
        fontSize: 16,
        height: 1.4,
      ),
      titleMedium: GoogleFonts.poppins(
        fontWeight: FontWeight.w500,
        color: AppColors.textPrimary,
        fontSize: 14,
        height: 1.4,
      ),
      titleSmall: GoogleFonts.poppins(
        fontWeight: FontWeight.w500,
        color: AppColors.textPrimary,
        fontSize: 12,
        height: 1.4,
        letterSpacing: 0.2,
      ),
      bodyLarge: GoogleFonts.poppins(
        fontWeight: FontWeight.normal,
        color: AppColors.textPrimary,
        fontSize: 16,
        height: 1.5,
      ),
      bodyMedium: GoogleFonts.poppins(
        fontWeight: FontWeight.normal,
        color: AppColors.textPrimary,
        fontSize: 14,
        height: 1.5,
      ),
      bodySmall: GoogleFonts.poppins(
        fontWeight: FontWeight.normal,
        color: AppColors.textSecondary,
        fontSize: 12,
        height: 1.5,
        letterSpacing: 0.2,
      ),
      labelLarge: GoogleFonts.poppins(
        fontWeight: FontWeight.w500,
        color: AppColors.textPrimary,
        fontSize: 14,
        height: 1.4,
      ),
      labelMedium: GoogleFonts.poppins(
        fontWeight: FontWeight.w500,
        color: AppColors.textPrimary,
        fontSize: 12,
        height: 1.4,
        letterSpacing: 0.2,
      ),
      labelSmall: GoogleFonts.poppins(
        fontWeight: FontWeight.w500,
        color: AppColors.textSecondary,
        fontSize: 11,
        height: 1.4,
        letterSpacing: 0.2,
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: AppColors.primaryColor,
      unselectedItemColor: AppColors.textSecondary,
      showSelectedLabels: true,
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
      selectedLabelStyle: GoogleFonts.poppins(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.3,
      ),
      unselectedLabelStyle: GoogleFonts.poppins(
        fontSize: 11,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.3,
      ),
    ),
    buttonTheme: ButtonThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      buttonColor: AppColors.primaryColor,
      textTheme: ButtonTextTheme.primary,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primaryColor,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primaryColor,
        side: BorderSide(color: AppColors.primaryColor, width: 1.5),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: AppColors.accentColor,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.grey[100],
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.primaryColor),
      ),
      hintStyle: GoogleFonts.poppins(
        color: Colors.grey[400],
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
      prefixIconColor: AppColors.iconColor,
      suffixIconColor: AppColors.iconColor,
    ),
    chipTheme: ChipThemeData(
      backgroundColor: AppColors.highlightColor.withOpacity(0.2),
      selectedColor: AppColors.primaryColor,
      disabledColor: Colors.grey[300],
      labelStyle: GoogleFonts.poppins(
        color: AppColors.textPrimary,
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
      secondaryLabelStyle: GoogleFonts.poppins(
        color: Colors.white,
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: AppColors.primaryColor,
      contentTextStyle: GoogleFonts.poppins(
        color: Colors.white,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      behavior: SnackBarBehavior.floating,
    ),
  );
}
