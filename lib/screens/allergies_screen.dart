import 'package:flutter/material.dart';

import '../controllers/bitesano_controller.dart';
import '../models/profile.dart';
import '../theme/app_theme.dart';
import '../utils/food_text.dart';
import '../utils/profile_validation.dart';
import '../widgets/allergy_tiles.dart';
import '../widgets/brand.dart';

class AllergiesScreen extends StatefulWidget {
  final BiteSanoController controller;
  final VoidCallback onContinue;
  const AllergiesScreen({
    super.key,
    required this.controller,
    required this.onContinue,
  });
  @override
  State<AllergiesScreen> createState() => _AllergiesScreenState();
}

class _AllergiesScreenState extends State<AllergiesScreen> {
  final _search = TextEditingController();
  final _custom = TextEditingController();
  String _query = '';
  BiteSanoController get c => widget.controller;
  @override
  void dispose() {
    _search.dispose();
    _custom.dispose();
    super.dispose();
  }

  Future<void> _severity(String key) async {
    final result = await showModalBottomSheet<AllergySeverity>(
      context: context,
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Severidad de ${allergyInfo(key).title}',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              ...AllergySeverity.values.map(
                (value) => ListTile(
                  leading: Icon(
                    value == c.allergies[key]
                        ? Icons.check_circle
                        : Icons.circle_outlined,
                    color: BiteColors.green,
                  ),
                  title: Text(value.label),
                  onTap: () => Navigator.pop(context, value),
                ),
              ),
            ],
          ),
        ),
      ),
    );
    if (result != null) c.setSeverity(key, result);
  }

  void _addCustom() {
    final name = _custom.text.trim();
    final validation = validateCustomAllergy(name);
    if (validation != null || !c.addAllergy(name)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(validation ?? 'El ingrediente ya está registrado.'),
        ),
      );
      return;
    }
    _custom.clear();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: c,
    builder: (context, _) {
      final suggestions = allergyOptions
          .where(
            (a) =>
                !c.allergies.containsKey(a.key) &&
                normalizeFood('${a.title} ${a.description} ${a.key}')
                    .contains(normalizeFood(_query)),
          )
          .toList();
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.maybePop(context),
          ),
          title: const Row(
            children: [
              BrandMark(size: 32),
              SizedBox(width: 9),
              Text(
                'BiteSano',
                style: TextStyle(
                  color: BiteColors.green,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(18, 12, 18, 26),
            children: [
              const Align(
                alignment: Alignment.centerLeft,
                child: StatusPill(
                  label: 'PERFIL DE PROTECCIÓN',
                  icon: Icons.verified_user_outlined,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Mi Perfil de Alergias',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 7),
              const Text(
                'Selecciona los ingredientes que necesitas evitar. BiteSano buscará posibles coincidencias al escanear un menú.',
                style: TextStyle(color: BiteColors.muted),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _search,
                onChanged: (v) => setState(() => _query = v),
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.search, color: BiteColors.green),
                  hintText: 'Buscar alérgeno (nuez, camarón…)',
                ),
              ),
              const SizedBox(height: 13),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  gradient: const LinearGradient(
                    colors: [BiteColors.input, Color(0xffd5f4ec)],
                  ),
                ),
                padding: const EdgeInsets.all(14),
                child: const Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: BiteColors.green,
                      foregroundColor: Colors.white,
                      child: Icon(Icons.manage_search),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Detección por nombre e ingredientes',
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                          Text(
                            'Referencias locales y términos en español/inglés.',
                            style: TextStyle(
                              color: BiteColors.muted,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Mis alergias activas',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  StatusPill(
                    label: '${c.allergies.length} REGISTRADAS',
                    background: BiteColors.green,
                    color: Colors.white,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              if (c.allergies.isEmpty)
                const SurfaceCard(
                  child: Text(
                    'Todavía no agregaste alergias. Selecciona una de las opciones abajo.',
                  ),
                ),
              ...c.allergies.entries.map(
                (entry) => ActiveAllergyTile(
                  allergy: entry.key,
                  severity: entry.value,
                  onRemove: c.busy ? null : () => c.removeAllergy(entry.key),
                  onEdit: c.busy ? null : () => _severity(entry.key),
                ),
              ),
              if (c.allergies.isNotEmpty)
                const Text(
                  'Toca una alergia para ajustar su severidad.',
                  style: TextStyle(fontSize: 12, color: BiteColors.muted),
                ),
              const SizedBox(height: 22),
              Text(
                'Agregar Alérgenos Frecuentes',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const Text(
                'Toca para incluirlos en tu análisis',
                style: TextStyle(color: BiteColors.muted),
              ),
              const SizedBox(height: 10),
              if (suggestions.isEmpty)
                const Text('No hay más coincidencias con tu búsqueda.'),
              LayoutBuilder(
                builder: (context, size) => Wrap(
                  spacing: 9,
                  runSpacing: 9,
                  children: suggestions
                      .map(
                        (info) => SizedBox(
                          width: (size.maxWidth - 9) / 2,
                          child: AllergyOptionTile(
                            info: info,
                            onTap: c.busy ? null : () => c.addAllergy(info.key),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Agregar Alimento Personalizado',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 5),
              const Text(
                '¿Algún ingrediente específico no listado?',
                style: TextStyle(color: BiteColors.muted),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _custom,
                      decoration: const InputDecoration(
                        hintText: 'Ej. apio, piña, cilantro',
                      ),
                      onSubmitted: (_) => _addCustom(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  FilledButton.icon(
                    onPressed: c.busy ? null : _addCustom,
                    icon: const Icon(Icons.add),
                    label: const Text('Añadir'),
                  ),
                ],
              ),
              const SizedBox(height: 17),
              SurfaceCard(
                color: BiteColors.input,
                padding: EdgeInsets.zero,
                child: SwitchListTile(
                  value: c.crossContact,
                  onChanged: c.setCrossContact,
                  secondary: const Icon(
                    Icons.restaurant,
                    color: BiteColors.green,
                  ),
                  title: const Text(
                    'Alerta de contaminación cruzada',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  subtitle: const Text(
                    'Recordatorio para preguntar por utensilios y superficies compartidos.',
                  ),
                ),
              ),
              const SizedBox(height: 23),
              FilledButton.icon(
                onPressed: c.busy
                    ? null
                    : () async {
                        await c.saveProfile();
                        if (context.mounted) widget.onContinue();
                      },
                icon: const Icon(Icons.check_circle_outline),
                label: const Text('Guardar y continuar al escáner'),
              ),
              const SizedBox(height: 9),
              const Text(
                'Tu perfil se usa para orientar el análisis; no sustituye la información del restaurante.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 11, color: BiteColors.muted),
              ),
            ],
          ),
        ),
      );
    },
  );
}
