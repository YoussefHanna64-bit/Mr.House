import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class AppTheme {
  static final inputDecoration = InputDecorationTheme(
    border: _outlinedBorder(AppColors.primary),
    focusedBorder: _outlinedBorder(AppColors.primary),
    errorBorder: _outlinedBorder(AppColors.error),
    floatingLabelStyle: const TextStyle(color: AppColors.primary),
    prefixIconColor: Colors.black,
    labelStyle: const TextStyle(color: Colors.black, fontSize: 14),
    hintStyle: const TextStyle(color: Colors.black, fontSize: 14),
  );

  static final inputDecorationDark = InputDecorationTheme(
    border: _outlinedBorder(AppColors.primary),
    focusedBorder: _outlinedBorder(AppColors.primary),
    errorBorder: _outlinedBorder(AppColors.error),
    floatingLabelStyle: const TextStyle(color: AppColors.primary),
    prefixIconColor: Colors.white,
    labelStyle: const TextStyle(color: Colors.white, fontSize: 14),
    hintStyle: const TextStyle(color: Colors.white, fontSize: 14),
  );

  static final bottomNavTheme = BottomNavigationBarThemeData(
    selectedItemColor: AppColors.primary,
    unselectedItemColor: Colors.grey.shade500,
    elevation: 10,
    type: BottomNavigationBarType.shifting,
  );

  static final bottomNavDarkTheme = BottomNavigationBarThemeData(
    selectedItemColor: AppColors.darkGreen,
    unselectedItemColor: Colors.grey.shade500,
    elevation: 10,
    type: BottomNavigationBarType.shifting,
  );

  static ThemeData get light => ThemeData(
        brightness: Brightness.light,
        fontFamily: "Inter",
        inputDecorationTheme: inputDecoration,
        scaffoldBackgroundColor: AppColors.background,
        bottomNavigationBarTheme: bottomNavTheme,
      );

  static ThemeData get dark => ThemeData(
        brightness: Brightness.dark,
        fontFamily: "Inter",
        inputDecorationTheme: inputDecorationDark,
        bottomNavigationBarTheme: bottomNavDarkTheme,
      );

  static OutlineInputBorder _outlinedBorder(Color color) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
      borderSide: BorderSide(color: color),
    );
  }
}
