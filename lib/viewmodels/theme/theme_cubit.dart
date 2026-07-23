import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mr_house/viewmodels/theme/theme_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(ThemeState(ThemeMode.light));

  Future<void> loadPreference() async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool("isDarkMode") ?? false;

    emit(ThemeState(isDark ? ThemeMode.dark : ThemeMode.light));
  }

  Future<void> toggleTheme(bool isDark) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("isDarkMode", isDark);

    emit(ThemeState(isDark ? ThemeMode.dark : ThemeMode.light));
  }
}
