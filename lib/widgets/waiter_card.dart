import 'package:flutter/material.dart';

import '../controllers/bitesano_controller.dart';
import '../theme/app_theme.dart';
import 'allergy_tiles.dart';
import 'brand.dart';

void showWaiterCard(
  BuildContext context,
  BiteSanoController controller, {
  Set<String>? selected,
}) {
  final allergies = selected ?? controller.selected;
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (context) => SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(22, 0, 22, 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Center(child: BrandMark(size: 58)),
            const SizedBox(height: 12),
            Text(
              'Tarjeta para el mesero / chef',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 14),
            const Text(
              'Por favor, ayúdeme a confirmar los ingredientes de mi comida.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            if (allergies.isEmpty) const Text('No hay alergias seleccionadas.'),
            ...allergies.map(
              (a) => ListTile(
                leading: const Icon(
                  Icons.warning_amber_rounded,
                  color: BiteColors.danger,
                ),
                title: Text(
                  allergyInfo(a).title,
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
              ),
            ),
            const SizedBox(height: 12),
            const SurfaceCard(
              color: BiteColors.input,
              child: Text(
                '¿Contiene alguno de estos ingredientes? ¿Se prepara con aceite, utensilios, equipo o superficies compartidas? Si no pueden confirmarlo, por favor avísenme.',
              ),
            ),
            const SizedBox(height: 18),
            FilledButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cerrar tarjeta'),
            ),
          ],
        ),
      ),
    ),
  );
}
