import 'package:flutter/material.dart';
import '../widgets/bite_sano_bottom_nav.dart';
import 'acercade_screen.dart';
import 'configuracion_screen.dart';
import 'home_screen.dart';
import 'perfil_screen.dart';
import 'scanner_screen.dart';

class MainShellScreen extends StatefulWidget {
  const MainShellScreen({super.key, this.initialIndex = 0});
  final int initialIndex;

  @override
  State<MainShellScreen> createState() => _MainShellScreenState();
}

class _MainShellScreenState extends State<MainShellScreen> {
  late int _index = widget.initialIndex;

  void _setTab(int i) => setState(() => _index = i);

  void _openAllergySettings() {
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (_) => ConfiguracionScreen(
          onContinueToScanner: () {
            Navigator.pop(context);
            _setTab(1);
          },
        ),
      ),
    );
  }

  void _openAbout() {
    Navigator.push(
      context,
      MaterialPageRoute<void>(builder: (_) => const AcercaDeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tabs = [
      HomeScreen(
        onOpenScanner: () => _setTab(1),
        onOpenHistory: () => _setTab(2),
        onEditAllergies: _openAllergySettings,
      ),
      const ScannerScreen(),
      const Center(child: Text('Historial', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
      PerfilScreen(
        onManageAllergies: _openAllergySettings,
        onOpenAbout: _openAbout,
      ),
    ];

    return Scaffold(
      body: IndexedStack(index: _index, children: tabs),
      bottomNavigationBar: BiteSanoBottomNavBar(currentIndex: _index, onTap: _setTab),
    );
  }
}