// core/theme.dart
import 'package:flutter/material.dart';
import 'package:news_app/core/theme/light_colors.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme.light(
        primary: LightColor.primaryColor,
        secondary: LightColor.primaryColor,
        surface: LightColor.backgroundColor,
        error: LightColor.errorColor,
        onPrimary: LightColor.secondaryTextColor,
        onSecondary: LightColor.secondaryTextColor,
        onSurface: LightColor.textColor,
        onError: LightColor.secondaryTextColor,
      ),

      scaffoldBackgroundColor: LightColor.backgroundColor,

      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.w700,
          letterSpacing: 2,
        ),
        headlineMedium: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
        bodySmall: TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
      ),

      appBarTheme: const AppBarTheme(
        backgroundColor: LightColor.backgroundColor,
        foregroundColor: LightColor.textColor,
        elevation: 0,
      ),

      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: LightColor.backgroundColor,
        selectedItemColor: LightColor.primaryColor,
        unselectedItemColor: LightColor.textColor,
        showUnselectedLabels: true,
      ),

      listTileTheme: const ListTileThemeData(
        contentPadding: EdgeInsets.zero,
        minLeadingWidth: 16,
      ),

      iconTheme: const IconThemeData(color: LightColor.textColor),

      cardTheme: CardTheme(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 0,
      ),
    );
  }

  static ThemeData get darkTheme {
    return lightTheme;
  }

  static ThemeData getTheme({required bool isDarkMode}) {
    return isDarkMode ? darkTheme : lightTheme;
  }
}
