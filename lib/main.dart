import 'package:flutter/material.dart';

import 'screens/app_shell.dart';
import 'theme/app_theme.dart';

void main() => runApp(const BiteSanoApp());

class BiteSanoApp extends StatelessWidget {
  const BiteSanoApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'BiteSano',
    debugShowCheckedModeBanner: false,
    theme: buildTheme(),
    home: const AppShell(),
  );
}
