import 'package:flutter/material.dart';

import '../controllers/bitesano_controller.dart';
import '../models/analysis_snapshot.dart';
import '../models/menu.dart';
import '../theme/app_theme.dart';
import '../widgets/brand.dart';

class HistoryScreen extends StatelessWidget {
  final BiteSanoController controller;
  final ValueChanged<AnalysisSnapshot> onOpen;
  final VoidCallback onScan;
  const HistoryScreen({
    super.key,
    required this.controller,
    required this.onOpen,
    required this.onScan,
  });
  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.fromLTRB(18, 8, 18, 25),
    children: [
      const Align(
        alignment: Alignment.centerLeft,
        child: StatusPill(
          label: 'MIS ANÁLISIS',
          icon: Icons.assignment_outlined,
        ),
      ),
      const SizedBox(height: 9),
      Text('Historial', style: Theme.of(context).textTheme.headlineLarge),
      const Text(
        'Menús analizados durante esta sesión.',
        style: TextStyle(color: BiteColors.muted),
      ),
      const SizedBox(height: 18),
      if (controller.history.isEmpty)
        SurfaceCard(
          child: Column(
            children: [
              const Icon(
                Icons.assignment_outlined,
                color: BiteColors.green,
                size: 54,
              ),
              const SizedBox(height: 15),
              Text(
                'Aún no hay análisis',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 7),
              const Text(
                'Escanea un menú para comenzar.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 15),
              FilledButton.icon(
                onPressed: onScan,
                icon: const Icon(Icons.camera_alt_outlined),
                label: const Text('Ir al escáner'),
              ),
            ],
          ),
        )
      else
        ...controller.history.map((s) {
          final risk = s.results.values
              .where((r) => r.status == AllergyStatus.risk)
              .length;
          final date = s.time;
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: SurfaceCard(
              padding: EdgeInsets.zero,
              child: ListTile(
                contentPadding: const EdgeInsets.all(12),
                leading: const CircleAvatar(
                  backgroundColor: BiteColors.mint,
                  child: Icon(Icons.restaurant_menu, color: BiteColors.green),
                ),
                title: Text(
                  s.title,
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
                subtitle: Text(
                  '${date.day}/${date.month}/${date.year} · ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}\n${s.items.length} productos · $risk posibles riesgos',
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => onOpen(s),
              ),
            ),
          );
        }),
    ],
  );
}
