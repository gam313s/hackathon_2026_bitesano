import 'package:flutter/material.dart';

import '../models/menu.dart';
import '../models/analysis_snapshot.dart';
import '../theme/app_theme.dart';
import '../widgets/brand.dart';
import '../widgets/result_card.dart';
import '../widgets/allergy_tiles.dart';

class AnalysisScreen extends StatefulWidget {
  final AnalysisSnapshot snapshot;
  final VoidCallback onCard;
  final bool asPage;
  const AnalysisScreen({
    super.key,
    required this.snapshot,
    required this.onCard,
    this.asPage = false,
  });
  @override
  State<AnalysisScreen> createState() => _AnalysisScreenState();
}

class _AnalysisScreenState extends State<AnalysisScreen> {
  MenuFilter _filter = MenuFilter.all;
  @override
  void didUpdateWidget(covariant AnalysisScreen old) {
    super.didUpdateWidget(old);
    if (old.snapshot != widget.snapshot) _filter = MenuFilter.all;
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.snapshot;
    int count(MenuFilter f) => filterMenuItems(s.items, s.results, f).length;
    final no = count(MenuFilter.noMatch),
        risk = count(MenuFilter.risk),
        unknown = count(MenuFilter.insufficient);
    final visible = filterMenuItems(s.items, s.results, _filter);
    final body = ListView(
      padding: const EdgeInsets.fromLTRB(18, 9, 18, 25),
      children: [
        const Align(
          alignment: Alignment.centerLeft,
          child: StatusPill(
            label: 'ANÁLISIS COMPLETADO',
            icon: Icons.check_circle_outline,
          ),
        ),
        const SizedBox(height: 8),
        Text(s.title, style: Theme.of(context).textTheme.headlineLarge),
        const SizedBox(height: 5),
        Text(
          '${s.items.length} platillos analizados · Perfil: ${s.allergies.map((a) => allergyInfo(a).title).join(', ')}',
          style: const TextStyle(color: BiteColors.muted, fontSize: 12),
        ),
        if (s.demo)
          const Padding(
            padding: EdgeInsets.only(top: 8),
            child: Text(
              'Ejemplo ficticio, sin consultas a internet.',
              style: TextStyle(
                color: BiteColors.green,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        const SizedBox(height: 15),
        SurfaceCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.circle, color: BiteColors.green, size: 11),
                  const SizedBox(width: 7),
                  const Expanded(
                    child: Text(
                      'Semáforo de resultados',
                      style: TextStyle(fontWeight: FontWeight.w800),
                    ),
                  ),
                  const StatusPill(
                    label: 'REFERENCIAS',
                    background: BiteColors.input,
                    color: BiteColors.blueGray,
                  ),
                ],
              ),
              const SizedBox(height: 14),
              ClipRRect(
                borderRadius: BorderRadius.circular(9),
                child: Row(
                  children: [
                    if (no > 0)
                      Expanded(
                        flex: no,
                        child: Container(height: 12, color: BiteColors.green),
                      ),
                    if (unknown > 0)
                      Expanded(
                        flex: unknown,
                        child: Container(height: 12, color: BiteColors.amber),
                      ),
                    if (risk > 0)
                      Expanded(
                        flex: risk,
                        child: Container(height: 12, color: BiteColors.danger),
                      ),
                    if (s.items.isEmpty)
                      Expanded(
                        child: Container(height: 12, color: BiteColors.blueBg),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  _Stat(
                    value: no,
                    label: 'Sin riesgo*',
                    color: BiteColors.green,
                    icon: Icons.info_outline,
                  ),
                  const SizedBox(width: 7),
                  _Stat(
                    value: unknown,
                    label: 'Sin datos',
                    color: BiteColors.amber,
                    icon: Icons.help_outline,
                  ),
                  const SizedBox(width: 7),
                  _Stat(
                    value: risk,
                    label: 'Riesgo',
                    color: BiteColors.danger,
                    icon: Icons.warning_amber_rounded,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const Text(
                '*Sin riesgo detectado en la referencia, no significa alimento seguro.',
                style: TextStyle(fontSize: 11, color: BiteColors.muted),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Wrap(
          spacing: 7,
          runSpacing: 7,
          children: MenuFilter.values.map((f) {
            final label = switch (f) {
              MenuFilter.all => 'Todos',
              MenuFilter.risk => 'Riesgo',
              MenuFilter.insufficient => 'Precaución',
              MenuFilter.noMatch => 'Sin riesgo*',
            };
            return ChoiceChip(
              showCheckmark: false,
              selected: _filter == f,
              selectedColor: BiteColors.green,
              backgroundColor: BiteColors.input,
              side: BorderSide.none,
              label: Text(
                '$label (${count(f)})',
                style: TextStyle(
                  color: _filter == f ? Colors.white : BiteColors.ink,
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                ),
              ),
              onSelected: (_) => setState(() => _filter = f),
            );
          }).toList(),
        ),
        const SizedBox(height: 13),
        if (visible.isEmpty)
          const SurfaceCard(child: Text('No hay productos en esta categoría.')),
        ...visible.map(
          (item) => ResultCard(item: item, result: s.results[item]),
        ),
        const SizedBox(height: 10),
        const SurfaceCard(
          color: BiteColors.input,
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: BiteColors.blueBg,
                child: Icon(Icons.restaurant_outlined, color: BiteColors.green),
              ),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Consulta sin estrés',
                      style: TextStyle(fontWeight: FontWeight.w800),
                    ),
                    Text(
                      'Muestra tu tarjeta al personal para confirmar ingredientes y contacto cruzado.',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        FilledButton.icon(
          onPressed: widget.onCard,
          icon: const Icon(Icons.badge_outlined),
          label: const Text('Mostrar tarjeta al mesero / chef'),
        ),
        const SizedBox(height: 14),
        const Text(
          'Los resultados son orientativos y no sustituyen la confirmación del restaurante.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 11, color: BiteColors.muted),
        ),
      ],
    );
    return widget.asPage
        ? Scaffold(
            appBar: AppBar(title: const Text('Historial / Análisis')),
            body: SafeArea(child: body),
          )
        : body;
  }
}

class _Stat extends StatelessWidget {
  final int value;
  final String label;
  final Color color;
  final IconData icon;
  const _Stat({
    required this.value,
    required this.label,
    required this.color,
    required this.icon,
  });
  @override
  Widget build(BuildContext context) => Expanded(
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 4),
      decoration: BoxDecoration(
        color: BiteColors.input,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 15),
              const SizedBox(width: 4),
              Text(
                '$value',
                style: TextStyle(
                  color: color,
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    ),
  );
}
