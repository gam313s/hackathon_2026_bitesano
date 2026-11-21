import 'package:flutter/material.dart';

import '../controllers/bitesano_controller.dart';
import '../models/analysis_snapshot.dart';
import '../widgets/brand.dart';
import '../widgets/bottom_nav.dart';
import '../widgets/waiter_card.dart';
import 'access_screen.dart';
import 'allergies_screen.dart';
import 'analysis_screen.dart';
import 'history_screen.dart';
import 'home_screen.dart';
import 'profile_screen.dart';
import 'scanner_screen.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});
  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  final c = BiteSanoController();
  int _tab = 0;
  AnalysisSnapshot? _detail;
  @override
  void initState() {
    super.initState();
    c.initialize();
  }

  @override
  void dispose() {
    c.dispose();
    super.dispose();
  }

  void _select(int value) {
    if (!mounted) return;
    setState(() {
      _tab = value;
      _detail = null;
    });
  }

  void _open(AnalysisSnapshot value) {
    if (!mounted) return;
    setState(() {
      _tab = 2;
      _detail = value;
    });
  }

  void _card() {
    showWaiterCard(context, c);
  }

  void _allergies() {
    if (!mounted || c.busy) return;
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (routeContext) => AllergiesScreen(
          controller: c,
          onContinue: () {
            Navigator.of(routeContext).pop();
            _select(1);
          },
        ),
      ),
    );
  }

  void _entered() {
    if (!mounted) return;
    _select(0);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _allergies();
    });
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: c,
    builder: (context, _) {
      if (!c.ready)
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      if (!c.signedIn) return AccessScreen(controller: c, onEntered: _entered);
      final page = switch (_tab) {
        0 => HomeScreen(
          controller: c,
          onScan: () => _select(1),
          onManage: _allergies,
          onHistory: () => _select(2),
          onCard: _card,
        ),
        1 => ScannerScreen(
          controller: c,
          onAllergies: _allergies,
          onAnalyzed: () {
            if (c.history.isNotEmpty) _open(c.history.first);
          },
        ),
        2 =>
          _detail != null
              ? AnalysisScreen(
                  snapshot: _detail!,
                  onCard: () =>
                      showWaiterCard(context, c, selected: _detail!.allergies),
                )
              : HistoryScreen(
                  controller: c,
                  onOpen: _open,
                  onScan: () => _select(1),
                ),
        _ => ProfileScreen(controller: c, onManage: _allergies, onCard: _card),
      };
      final title = switch (_tab) {
        0 => 'Inicio / Bienvenido',
        1 => 'Escáner de Menú',
        2 => _detail != null ? 'Historial / Análisis' : 'Historial',
        _ => 'Mi perfil',
      };
      return Scaffold(
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              BrandHeader(
                subtitle: title,
                name: c.name,
                onProfile: () => _select(3),
              ),
              if (_tab == 2 && _detail != null)
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton.icon(
                    onPressed: () => _select(2),
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('Volver al historial'),
                  ),
                ),
              Expanded(child: page),
            ],
          ),
        ),
        bottomNavigationBar: BiteNavigation(selected: _tab, onSelect: _select),
      );
    },
  );
}
