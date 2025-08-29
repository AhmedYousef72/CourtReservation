import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_constants.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppConstants.primaryColor,
        brightness: Brightness.light,
      ),
      textTheme: GoogleFonts.poppinsTextTheme().copyWith(
        displayLarge: GoogleFonts.poppins(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: AppConstants.textPrimaryColor,
        ),
        displayMedium: GoogleFonts.poppins(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: AppConstants.textPrimaryColor,
        ),
        displaySmall: GoogleFonts.poppins(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: AppConstants.textPrimaryColor,
        ),
        headlineLarge: GoogleFonts.poppins(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: AppConstants.textPrimaryColor,
        ),
        headlineMedium: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppConstants.textPrimaryColor,
        ),
        headlineSmall: GoogleFonts.poppins(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppConstants.textPrimaryColor,
        ),
        titleLarge: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: AppConstants.textPrimaryColor,
        ),
        titleMedium: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: AppConstants.textPrimaryColor,
        ),
        titleSmall: GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: AppConstants.textPrimaryColor,
        ),
        bodyLarge: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: AppConstants.textPrimaryColor,
        ),
        bodyMedium: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.normal,
          color: AppConstants.textPrimaryColor,
        ),
        bodySmall: GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: FontWeight.normal,
          color: AppConstants.textSecondaryColor,
        ),
        labelLarge: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: AppConstants.textPrimaryColor,
        ),
        labelMedium: GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: AppConstants.textPrimaryColor,
        ),
        labelSmall: GoogleFonts.poppins(
          fontSize: 10,
          fontWeight: FontWeight.w500,
          color: AppConstants.textSecondaryColor,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppConstants.primaryColor,
          foregroundColor: Colors.white,
          elevation: 2,
          shadowColor: AppConstants.primaryColor.withOpacity(0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
          ),
          minimumSize: const Size(double.infinity, AppConstants.buttonHeightMedium),
          textStyle: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppConstants.primaryColor,
          side: const BorderSide(color: AppConstants.primaryColor, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
          ),
          minimumSize: const Size(double.infinity, AppConstants.buttonHeightMedium),
          textStyle: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppConstants.primaryColor,
          textStyle: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppConstants.surfaceColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
          borderSide: BorderSide(color: AppConstants.textLightColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
          borderSide: BorderSide(color: AppConstants.textLightColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
          borderSide: const BorderSide(color: AppConstants.primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
          borderSide: const BorderSide(color: AppConstants.errorColor, width: 2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
          borderSide: const BorderSide(color: AppConstants.errorColor, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppConstants.paddingMedium,
          vertical: AppConstants.paddingMedium,
        ),
        labelStyle: GoogleFonts.poppins(
          color: AppConstants.textSecondaryColor,
          fontSize: 14,
        ),
        hintStyle: GoogleFonts.poppins(
          color: AppConstants.textLightColor,
          fontSize: 14,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 4,
        shadowColor: Colors.black.withOpacity(0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadiusLarge),
        ),
        color: AppConstants.surfaceColor,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppConstants.surfaceColor,
        foregroundColor: AppConstants.textPrimaryColor,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.poppins(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppConstants.textPrimaryColor,
        ),
        iconTheme: const IconThemeData(
          color: AppConstants.textPrimaryColor,
          size: AppConstants.iconSizeMedium,
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppConstants.surfaceColor,
        selectedItemColor: AppConstants.primaryColor,
        unselectedItemColor: AppConstants.textSecondaryColor,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppConstants.primaryColor,
        foregroundColor: Colors.white,
        elevation: 6,
        shape: CircleBorder(),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppConstants.primaryColor,
        brightness: Brightness.dark,
      ),
      textTheme: GoogleFonts.poppinsTextTheme().copyWith(
        displayLarge: GoogleFonts.poppins(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        displayMedium: GoogleFonts.poppins(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        displaySmall: GoogleFonts.poppins(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        headlineLarge: GoogleFonts.poppins(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        headlineMedium: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        headlineSmall: GoogleFonts.poppins(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        titleLarge: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        titleMedium: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
        titleSmall: GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
        bodyLarge: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: Colors.white,
        ),
        bodyMedium: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.normal,
          color: Colors.white,
        ),
        bodySmall: GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: FontWeight.normal,
          color: Colors.grey[400],
        ),
        labelLarge: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
        labelMedium: GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
        labelSmall: GoogleFonts.poppins(
          fontSize: 10,
          fontWeight: FontWeight.w500,
          color: Colors.grey[400],
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppConstants.primaryColor,
          foregroundColor: Colors.white,
          elevation: 2,
          shadowColor: AppConstants.primaryColor.withOpacity(0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
          ),
          minimumSize: const Size(double.infinity, AppConstants.buttonHeightMedium),
          textStyle: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppConstants.primaryColor,
          side: const BorderSide(color: AppConstants.primaryColor, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
          ),
          minimumSize: const Size(double.infinity, AppConstants.buttonHeightMedium),
          textStyle: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppConstants.primaryColor,
          textStyle: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.grey[900],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
          borderSide: BorderSide(color: Colors.grey[700]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
          borderSide: BorderSide(color: Colors.grey[700]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
          borderSide: const BorderSide(color: AppConstants.primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
          borderSide: const BorderSide(color: AppConstants.errorColor, width: 2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
          borderSide: const BorderSide(color: AppConstants.errorColor, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppConstants.paddingMedium,
          vertical: AppConstants.paddingMedium,
        ),
        labelStyle: GoogleFonts.poppins(
          color: Colors.grey[400],
          fontSize: 14,
        ),
        hintStyle: GoogleFonts.poppins(
          color: Colors.grey[500],
          fontSize: 14,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 4,
        shadowColor: Colors.black.withOpacity(0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadiusLarge),
        ),
        color: Colors.grey[900],
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.grey[900],
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.poppins(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        iconTheme: const IconThemeData(
          color: Colors.white,
          size: AppConstants.iconSizeMedium,
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.grey[900],
        selectedItemColor: AppConstants.primaryColor,
        unselectedItemColor: Colors.grey[400],
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppConstants.primaryColor,
        foregroundColor: Colors.white,
        elevation: 6,
        shape: CircleBorder(),
      ),
    );
  }
}
