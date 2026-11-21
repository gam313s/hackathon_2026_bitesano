import 'package:flutter/material.dart';

import '../controllers/bitesano_controller.dart';
import '../theme/app_theme.dart';
import '../widgets/allergy_tiles.dart';
import '../widgets/brand.dart';

class HomeScreen extends StatelessWidget {
  final BiteSanoController controller;
  final VoidCallback onScan, onManage, onHistory, onCard;
  const HomeScreen({
    super.key,
    required this.controller,
    required this.onScan,
    required this.onManage,
    required this.onHistory,
    required this.onCard,
  });
  @override
  Widget build(BuildContext context) {
    final c = controller;
    return ListView(
      padding: const EdgeInsets.fromLTRB(18, 8, 18, 24),
      children: [
        const Align(
          alignment: Alignment.centerLeft,
          child: StatusPill(
            label: 'ASISTENTE DE ALÉRGENOS',
            icon: Icons.verified_user_outlined,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'Hola, ${c.name}',
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        const SizedBox(height: 6),
        const Text(
          'Explora un menú con más información sobre los ingredientes que necesitas evitar.',
          style: TextStyle(color: BiteColors.muted),
        ),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [BiteColors.green, Color(0xff0c9270)],
            ),
            borderRadius: BorderRadius.circular(25),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.document_scanner_outlined,
                color: Colors.white,
                size: 43,
              ),
              const SizedBox(height: 14),
              const Text(
                'Escanea tu próximo menú',
                style: TextStyle(
                  fontSize: 25,
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -.5,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Foto, ingredientes de referencia y alertas según tu perfil.',
                style: TextStyle(color: Color(0xffd0f3e6)),
              ),
              const SizedBox(height: 17),
              FilledButton.icon(
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: BiteColors.green,
                ),
                onPressed: onScan,
                icon: const Icon(Icons.camera_alt_outlined),
                label: const Text('Abrir escáner'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 22),
        Row(
          children: [
            Expanded(
              child: Text(
                'Mis alergias',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            TextButton(onPressed: onManage, child: const Text('Gestionar')),
          ],
        ),
        SurfaceCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (c.allergies.isEmpty)
                const Text('Configura tu perfil para empezar a analizar.')
              else
                Wrap(
                  spacing: 7,
                  runSpacing: 7,
                  children: c.allergies.keys
                      .map(
                        (a) => StatusPill(
                          label: allergyInfo(a).title,
                          icon: allergyInfo(a).icon,
                        ),
                      )
                      .toList(),
                ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: c.busy ? null : onManage,
                icon: const Icon(Icons.tune),
                label: const Text('Editar perfil de alergias'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SurfaceCard(
          padding: EdgeInsets.zero,
          child: ListTile(
            leading: const CircleAvatar(
              backgroundColor: BiteColors.input,
              child: Icon(Icons.assignment_outlined, color: BiteColors.green),
            ),
            title: const Text(
              'Historial de análisis',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            subtitle: Text(
              '${c.history.length} menús analizados en esta sesión',
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: onHistory,
          ),
        ),
        const SizedBox(height: 10),
        SurfaceCard(
          padding: EdgeInsets.zero,
          child: ListTile(
            leading: const CircleAvatar(
              backgroundColor: BiteColors.input,
              child: Icon(Icons.badge_outlined, color: BiteColors.green),
            ),
            title: const Text(
              'Tarjeta para el restaurante',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            subtitle: const Text('Comunica tus alergias al personal'),
            trailing: const Icon(Icons.chevron_right),
            onTap: onCard,
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          'BiteSano es orientativo. Confirma los ingredientes reales y el contacto cruzado antes de consumir.',
          style: TextStyle(color: BiteColors.muted, fontSize: 11),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
