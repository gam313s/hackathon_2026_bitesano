import 'package:flutter/material.dart';

abstract final class BiteColors {
  static const green = Color(0xff00684d);
  static const dark = Color(0xff082c25);
  static const mint = Color(0xffbff5df);
  static const background = Color(0xfff5f7fb);
  static const input = Color(0xffedf1fb);
  static const ink = Color(0xff14202c);
  static const muted = Color(0xff5d6e70);
  static const danger = Color(0xffb82126);
  static const dangerBg = Color(0xffffe7e5);
  static const amber = Color(0xff98610d);
  static const amberBg = Color(0xffffedd5);
  static const blueGray = Color(0xff53617b);
  static const blueBg = Color(0xffdfe7fa);
}

ThemeData buildTheme() {
  final scheme = ColorScheme.fromSeed(
    seedColor: BiteColors.green,
    brightness: Brightness.light,
    surface: Colors.white,
  );
  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: BiteColors.background,
    appBarTheme: const AppBarTheme(
      backgroundColor: BiteColors.background,
      surfaceTintColor: Colors.transparent,
      foregroundColor: BiteColors.ink,
      elevation: 0,
    ),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.w800,
        letterSpacing: -1,
      ),
      headlineMedium: TextStyle(
        fontSize: 25,
        fontWeight: FontWeight.w800,
        letterSpacing: -.6,
      ),
      titleLarge: TextStyle(
        fontSize: 21,
        fontWeight: FontWeight.w700,
        letterSpacing: -.35,
      ),
      titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
      bodyMedium: TextStyle(fontSize: 14, height: 1.4),
      bodySmall: TextStyle(fontSize: 12, height: 1.35),
    ).apply(bodyColor: BiteColors.ink, displayColor: BiteColors.ink),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: BiteColors.input,
      contentPadding: const EdgeInsets.symmetric(vertical: 17, horizontal: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      hintStyle: const TextStyle(color: BiteColors.muted),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: BiteColors.green,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(17)),
        textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: BiteColors.green,
        side: const BorderSide(color: BiteColors.green),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    ),
    dividerTheme: const DividerThemeData(color: Color(0xffe5e9ef)),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      backgroundColor: BiteColors.dark,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
  );
}
