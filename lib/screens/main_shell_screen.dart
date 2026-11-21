import 'package:flutter/material.dart';
import '../widgets/bite_sano_bottom_nav.dart';
import 'perfil_screen.dart';
import 'home_screen.dart';
class MainShellScreen extends StatefulWidget {
  const MainShellScreen({super.key, this.initialIndex = 0});
  final int initialIndex;

  @override
  State<MainShellScreen> createState() => _MainShellScreenState();
}

class _MainShellScreenState extends State<MainShellScreen> {
  late int _index = widget.initialIndex;

  void _setTab(int i) => setState(() => _index = i);

  @override
  Widget build(BuildContext context) {
    final tabs = [
      HomeScreen(
        onOpenScanner: () => _setTab(1),
        onOpenHistory: () => _setTab(2),
        onEditAllergies: () => Navigator.push(
          context,
          MaterialPageRoute<void>(
            builder: (_) => Scaffold(
              appBar: AppBar(title: const Text('Mis Alergias')),
              body: const Center(child: Text('Editar Alergias')),
            ),
          ),
        ),
      ),
      const Center(child: Text('Escáner IA', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
      const Center(child: Text('Historial', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
      const Center(child: Text('Perfil', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
    ];

    return Scaffold(
      body: IndexedStack(index: _index, children: tabs),
      bottomNavigationBar: BiteSanoBottomNavBar(currentIndex: _index, onTap: _setTab),
    );
  }
}