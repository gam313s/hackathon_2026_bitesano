import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../controllers/bitesano_controller.dart';
import '../models/menu.dart';
import '../theme/app_theme.dart';
import '../widgets/allergy_tiles.dart';
import '../widgets/brand.dart';
import '../widgets/result_card.dart';

class ScannerScreen extends StatelessWidget {
  final BiteSanoController controller;
  final VoidCallback onAllergies;
  final VoidCallback onAnalyzed;
  const ScannerScreen({
    super.key,
    required this.controller,
    required this.onAllergies,
    required this.onAnalyzed,
  });

  Future<void> _edit(BuildContext context, [MenuItem? original]) async {
    final name = TextEditingController(text: original?.name ?? '');
    final price = TextEditingController(text: original?.price ?? '');
    final description = TextEditingController(
      text: original?.description ?? '',
    );
    final form = GlobalKey<FormState>();
    final update = await showDialog<MenuItem>(
      context: context,
      builder: (context) => AlertDialog(
        scrollable: true,
        title: Text(
          original == null ? 'Agregar producto' : 'Corregir producto',
        ),
        content: Form(
          key: form,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: name,
                decoration: const InputDecoration(labelText: 'Nombre'),
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'Escribe un nombre' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: price,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(
                  labelText: 'Precio (opcional)',
                ),
                validator: (v) =>
                    v == null ||
                        v.trim().isEmpty ||
                        RegExp(r'^\d+(?:[.,]\d{1,2})?$').hasMatch(v.trim())
                    ? null
                    : 'Importe no válido',
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: description,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Descripción / ingredientes (opcional)',
                ),
              ),
            ],
          ),
        ),
        actions: [
          if (original != null)
            TextButton(
              onPressed: () => Navigator.pop(context, const MenuItem('', null)),
              child: const Text('Quitar'),
            ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () {
              if (form.currentState?.validate() != true) return;
              Navigator.pop(
                context,
                MenuItem(
                  name.text.trim(),
                  price.text.trim().isEmpty ? null : price.text.trim(),
                  description: description.text.trim().isEmpty
                      ? null
                      : description.text.trim(),
                  section: original?.section,
                  currency: original?.currency ?? r'$',
                ),
              );
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
    name.dispose();
    price.dispose();
    description.dispose();
    if (update != null)
      controller.edit(original, update.name.isEmpty ? null : update);
  }

  void _qr(BuildContext context) => showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Menú QR'),
      content: const Text(
        'La lectura de códigos QR todavía no está integrada. Puedes abrir el menú con la cámara de tu teléfono y cargar una captura desde Galería.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Entendido'),
        ),
      ],
    ),
  );

  @override
  Widget build(BuildContext context) {
    final c = controller;
    final names = c.selected.map((a) => allergyInfo(a).title).join(', ');
    return ListView(
      padding: const EdgeInsets.fromLTRB(14, 0, 14, 22),
      children: [
        Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: const Color(0xff172838),
            borderRadius: BorderRadius.circular(25),
          ),
          child: Column(
            children: [
              SizedBox(
                height: 360,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    if (c.image != null)
                      Image.memory(c.image!, fit: BoxFit.contain)
                    else
                      Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Color(0xff354e54),
                              Color(0xff132331),
                              Color(0xff203d40),
                            ],
                          ),
                        ),
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                c.demo
                                    ? Icons.restaurant_menu
                                    : Icons.document_scanner_outlined,
                                size: 75,
                                color: const Color(0xff7bd8b9),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                c.demo
                                    ? 'Menú de demostración'
                                    : 'Escanea un menú',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 23,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 40,
                                ),
                                child: Text(
                                  c.demo ? 'Ejemplo local, sin internet.' : 'Captura una fotografía legible con todos los precios.',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Color(0xffb2c6cb),
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    if (c.image != null)
                      Container(color: Colors.black.withValues(alpha: .12)),
                    Positioned(
                      top: 12,
                      left: 12,
                      right: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 11,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xe61c3041),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.shield_outlined,
                              color: Color(0xff8ce6c4),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    c.allergies.isEmpty
                                        ? 'CONFIGURA TU PERFIL'
                                        : 'PERFIL DE ALERGIAS ACTIVO',
                                    style: const TextStyle(
                                      color: Color(0xff8ce6c4),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  Text(
                                    c.allergies.isEmpty
                                        ? 'Selecciona tus alergias'
                                        : '${c.allergies.length} filtros: $names',
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              onPressed: c.busy ? null : onAllergies,
                              tooltip: 'Gestionar alergias',
                              icon: const Icon(Icons.tune, color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Positioned(
                      top: 92,
                      bottom: 47,
                      left: 18,
                      right: 18,
                      child: IgnorePointer(
                        child: CustomPaint(painter: _ScanFrame()),
                      ),
                    ),
                    Positioned(
                      bottom: 12,
                      left: 20,
                      right: 20,
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xe61c3041),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.center_focus_strong_outlined,
                                size: 17,
                                color: Color(0xff8ce6c4),
                              ),
                              const SizedBox(width: 7),
                              Flexible(
                                child: Text(
                                  c.busy
                                      ? 'Procesando menú…'
                                      : c.image != null
                                      ? 'Foto leída · ${c.items.length} productos'
                                      : 'Apunta al texto o párrafos del menú',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 0, 15, 14),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child: _Action(
                        icon: Icons.photo_library_outlined,
                        label: 'Galería',
                        onTap: c.busy
                            ? null
                            : () => c.pick(ImageSource.gallery),
                      ),
                    ),
                    Expanded(
                      child: _Action(
                        icon: Icons.camera_alt_outlined,
                        label: 'Escanear todo',
                        main: true,
                        onTap: c.busy ? null : () => c.pick(ImageSource.camera),
                      ),
                    ),
                    Expanded(
                      child: _Action(
                        icon: Icons.qr_code_scanner,
                        label: 'Menú QR',
                        onTap: c.busy ? null : () => _qr(context),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 15),
        if (c.busy) const LinearProgressIndicator(),
        if (c.error != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Text(
              c.error!,
              style: const TextStyle(color: BiteColors.amber),
            ),
          ),
        if (c.demo)
          const SurfaceCard(
            color: BiteColors.input,
            child: Text(
              'Modo demostración: catálogo ficticio. No realiza consultas a internet.',
            ),
          ),
        if (c.alerts && c.analysisStarted && c.count(MenuFilter.risk) > 0)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: SurfaceCard(
              color: BiteColors.dangerBg,
              child: Row(
                children: [
                  const Icon(
                    Icons.warning_amber_rounded,
                    color: BiteColors.danger,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '${c.count(MenuFilter.risk)} posibles riesgos encontrados',
                      style: const TextStyle(
                        color: BiteColors.danger,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        Row(
          children: [
            const Icon(Icons.manage_search, color: BiteColors.green),
            const SizedBox(width: 7),
            Expanded(
              child: Text(
                'Resumen instantáneo',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            StatusPill(
              label: '${c.items.length} PLATILLOS',
              background: BiteColors.blueBg,
              color: BiteColors.blueGray,
            ),
          ],
        ),
        const SizedBox(height: 10),
        if (c.items.isEmpty)
          const SurfaceCard(
            child: Text(
              'Toma una foto o selecciona una imagen para mostrar los productos detectados.',
            ),
          )
        else ...[
          if (!c.demo)
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Revisa nombres y precios antes de analizar.',
                    style: TextStyle(fontSize: 12, color: BiteColors.muted),
                  ),
                ),
                TextButton.icon(
                  onPressed: c.busy ? null : () => _edit(context),
                  icon: const Icon(Icons.add),
                  label: const Text('Añadir'),
                ),
              ],
            ),
          FilledButton.icon(
            onPressed: c.busy
                ? null
                : c.allergies.isEmpty
                ? onAllergies
                : () async {
                    final ok = await c.analyze();
                    if (ok) onAnalyzed();
                  },
            icon: const Icon(Icons.health_and_safety_outlined),
            label: Text(
              c.allergies.isEmpty
                  ? 'Configurar alergias y escanear'
                  : 'Analizar menú con mis alergias',
            ),
          ),
          const SizedBox(height: 12),
          ...c.items.map(
            (item) => ResultCard(
              item: item,
              result: c.results[item],
              compact: true,
              onEdit: c.busy || c.demo ? null : () => _edit(context, item),
            ),
          ),
        ],
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: c.busy ? null : c.loadDemo,
          icon: const Icon(Icons.play_circle_outline),
          label: const Text('Cargar menú de demostración sin internet'),
        ),
        const SizedBox(height: 10),
        SurfaceCard(
          padding: EdgeInsets.zero,
          child: SwitchListTile(
            value: c.useOnline && !c.demo,
            onChanged: c.busy || c.demo ? null : c.setOnline,
            secondary: const Icon(
              Icons.cloud_outlined,
              color: BiteColors.green,
            ),
            title: const Text('Consulta opcional a Spoonacular'),
            subtitle: Text(
              c.demo
                  ? 'Desactivada en la demostración.'
                  : c.useOnline
                  ? 'Solo para productos sin referencia local. ${c.repository.remote.quotaLeft == null ? '' : 'Puntos restantes: ${c.repository.remote.quotaLeft!.toStringAsFixed(2)}'}'
                  : 'Modo local · No consume puntos.',
            ),
          ),
        ),
        if (c.useOnline && !c.demo && c.repository.remote.blockedReason != null)
          Text(
            c.repository.remote.blockedReason!,
            style: const TextStyle(color: BiteColors.amber),
          ),
        const SizedBox(height: 10),
        const Text(
          'Las referencias no verifican los ingredientes reales de un restaurante.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 11, color: BiteColors.muted),
        ),
      ],
    );
  }
}

class _Action extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool main;
  final VoidCallback? onTap;
  const _Action({
    required this.icon,
    required this.label,
    required this.onTap,
    this.main = false,
  });
  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(18),
    child: Padding(
      padding: const EdgeInsets.all(5),
      child: Column(
        children: [
          Container(
            width: main ? 60 : 48,
            height: main ? 60 : 48,
            decoration: BoxDecoration(
              color: main ? BiteColors.green : const Color(0xff2b4153),
              borderRadius: BorderRadius.circular(main ? 30 : 15),
              border: main ? Border.all(color: Colors.white, width: 3) : null,
            ),
            child: Icon(
              icon,
              color: onTap == null ? Colors.white54 : Colors.white,
              size: main ? 30 : 23,
            ),
          ),
          const SizedBox(height: 7),
          Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 2,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    ),
  );
}

class _ScanFrame extends CustomPainter {
  const _ScanFrame();
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = const Color(0xff92f7cc)
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    final l = math.min(40.0, size.width * .18);
    final r = Rect.fromLTWH(0, 0, size.width, size.height);
    for (final c in [
      (r.topLeft, 1.0, 1.0),
      (r.topRight, -1.0, 1.0),
      (r.bottomLeft, 1.0, -1.0),
      (r.bottomRight, -1.0, -1.0),
    ]) {
      final v = c.$1;
      final path = Path()
        ..moveTo(v.dx + c.$2 * l, v.dy)
        ..lineTo(v.dx, v.dy)
        ..lineTo(v.dx, v.dy + c.$3 * l);
      canvas.drawPath(path, p);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
