import 'package:client/core/theme/app_palette.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static OutlineInputBorder _border(Color color) => OutlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        borderSide: BorderSide(
          color: color,
          width: 3,
        ),
      );

  static final darkThemeMode = ThemeData.dark().copyWith(
    scaffoldBackgroundColor: Palette.backgroundColor,
    inputDecorationTheme: InputDecorationTheme(
      contentPadding: const EdgeInsets.all(27),
      border: const OutlineInputBorder(
        borderSide: BorderSide(
          color: Palette.borderColor,
        ),
      ),
      focusedBorder: _border(Palette.gradient2),
      enabledBorder: _border(Palette.borderColor),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Palette.backgroundColor,
      selectedItemColor: Palette.gradient2,
      unselectedItemColor: Palette.borderColor,
    ),
    // colorScheme: ColorScheme.fromSwatch(
    //   primarySwatch: Colors.deepPurple,
    //   accentColor: Colors.deepPurpleAccent,
    // ),
    // appBarTheme: const AppBarTheme(
    //   backgroundColor: Colors.deepPurple,
    // ),
  );
}
