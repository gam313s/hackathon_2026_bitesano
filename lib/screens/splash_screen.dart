import 'dart:async';

import 'package:flutter/material.dart';

import '../widgets/brand_components.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _navigationTimer;

  @override
  void initState() {
    super.initState();
    _navigationTimer = Timer(const Duration(milliseconds: 2200), () {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(builder: (_) => const LoginScreen()),
      );
    });
  }

  @override
  void dispose() {
    _navigationTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(28),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const AiBadge(),
                const SizedBox(height: 24),
                const BiteSanoLogo(width: 300),
                const SizedBox(height: 16),
                Text(
                  'Come fuera con total seguridad\ny sin riesgos de alergias alimentarias.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: BiteSanoColors.deepForest.withValues(alpha: 0.82),
                    fontSize: 17,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 40),
                const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    color: BiteSanoColors.forest,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
