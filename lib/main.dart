import 'package:flutter/material.dart';

import 'screens/splash_screen.dart';
import 'widgets/brand_components.dart';

void main() {
  runApp(const BiteSanoApp());
}

class BiteSanoApp extends StatelessWidget {
  const BiteSanoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BiteSano',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: BiteSanoColors.pageBackground,
        colorScheme: ColorScheme.fromSeed(
          seedColor: BiteSanoColors.forest,
          primary: BiteSanoColors.forest,
          surface: Colors.white,
        ),
        fontFamily: 'Roboto',
      ),
      home: const SplashScreen(),
    );
  }
}
