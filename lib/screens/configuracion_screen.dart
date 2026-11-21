import 'package:flutter/material.dart';

import '../widgets/brand_components.dart';

const _ink = Color(0xFF0B1C30);
const _inkSoft = Color(0xFF3D4A42);
const _mint = Color(0xFF85F8C4);

class _Allergen {
  const _Allergen(this.name, this.desc, this.icon, [this.level = 'Moderada']);
  final String name;
  final String desc;
  final IconData icon;
  final String level;
}

/// (fondo, color fuerte) según severidad.
(Color, Color) _levelColors(String level) {
  if (level.startsWith('Alta')) return (const Color(0xFFFFDAD6), const Color(0xFFBA1A1A));
  if (level.startsWith('Intol')) return (const Color(0xFFDAE2FD), const Color(0xFF565E74));
  return (const Color(0xFFFFDDB8), const Color(0xFF825100));
}

class ConfiguracionScreen extends StatefulWidget {
  const ConfiguracionScreen({super.key, this.onContinueToScanner});

  final VoidCallback? onContinueToScanner;

  @override
  State<ConfiguracionScreen> createState() => _ConfiguracionScreenState();
}

class _ConfiguracionScreenState extends State<ConfiguracionScreen> {
  final _searchCtrl = TextEditingController();
  final _customCtrl = TextEditingController();
  bool _crossContamination = true;

  final _active = <_Allergen>[
    const _Allergen('Maní / Cacahuates', 'Incluye aceites no refinados y harinas',
        Icons.warning_amber_rounded, 'Alta · Anafilaxia'),
    const _Allergen('Mariscos y Crustáceos', 'Camarón, langosta, cangrejo, moluscos',
        Icons.set_meal_outlined, 'Alta'),
    const _Allergen('Gluten / Trigo (Celiaquía)', 'Cebada, centeno, espelta y derivados',
        Icons.grain_rounded, 'Moderada'),
    const _Allergen('Lácteos / Lactosa', 'Leche, mantequilla, quesos maduros y crema',
        Icons.water_drop_outlined, 'Intolerancia'),
  ];

  final _common = <_Allergen>[
    const _Allergen('Frutos Secos', 'Nueces, Almendras, Avellanas', Icons.spa_outlined),
    const _Allergen('Pescados', 'Atún, Salmón, Bacalao', Icons.phishing_outlined),
    const _Allergen('Huevo', 'Clara, Yema y Trazas', Icons.egg_outlined),
    const _Allergen('Soya', 'Lecitina, Tofu, Salsa', Icons.eco_outlined),
    const _Allergen('Sésamo', 'Tahini, Aceites, Semilla', Icons.bubble_chart_outlined),
    const _Allergen('Sulfitos', 'Vinos, Conservas, Encurtidos', Icons.wine_bar_outlined),
    const _Allergen('Mostaza y Granos Derivados', 'Aderezos, vinagretas y condimentos preparados',
        Icons.balance_outlined),
  ];

  @override
  void dispose() {
    _searchCtrl.dispose();
    _customCtrl.dispose();
    super.dispose();
  }

  void _add(_Allergen a) => setState(() {
        _common.remove(a);
        _active.add(a);
      });

  void _addCustom() {
    final text = _customCtrl.text.trim();
    if (text.isEmpty) return;
    setState(() => _active.add(
        _Allergen(text, 'Alimento personalizado', Icons.restaurant_outlined)));
    _customCtrl.clear();
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final query = _searchCtrl.text.trim().toLowerCase();
    final visible = _common
        .where((a) =>
            query.isEmpty ||
            a.name.toLowerCase().contains(query) ||
            a.desc.toLowerCase().contains(query))
        .toList();

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 28, 24, 32),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 24),
                  _buildIntro(),
                  const SizedBox(height: 18),
                  _buildSearch(),
                  const SizedBox(height: 16),
                  _buildAiBanner(),
                  _title('Mis Alergias Activas',
                      trailing: '${_active.length} Registradas',
                      action: 'Gestionar severidad'),
                  for (final a in _active) _buildActiveCard(a),
                  _title('Agregar Alérgenos Frecuentes',
                      subtitle: 'Toca para incluirlo al instante en tu análisis'),
                  _buildQuickGrid(visible),
                  _title('Agregar Alimento Personalizado',
                      subtitle: '¿Algún ingrediente específico o condimento no listado?'),
                  _buildCustomInput(),
                  const SizedBox(height: 20),
                  _buildCrossContamination(),
                  const SizedBox(height: 28),
                  _buildSaveButton(),
                  const SizedBox(height: 12),
                  Text(
                    'Tus preferencias están cifradas y disponibles sin conexión.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: BiteSanoColors.mutedText, fontSize: 13),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        if (Navigator.of(context).canPop())
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.arrow_back_rounded),
            color: BiteSanoColors.deepForest,
            tooltip: 'Volver',
          ),
        const BrandMark(size: 44),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const BiteSanoWordmark(fontSize: 22),
              Text('Inicio / Alergias',
                  style: TextStyle(color: BiteSanoColors.mutedText, fontSize: 13)),
            ],
          ),
        ),
        Icon(Icons.account_circle_outlined, color: BiteSanoColors.mutedText, size: 30),
      ],
    );
  }

  Widget _buildIntro() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
          decoration: BoxDecoration(color: _mint, borderRadius: BorderRadius.circular(20)),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.gpp_good_outlined, size: 16, color: Color(0xFF005137)),
              SizedBox(width: 6),
              Text('ESCUDO DE PROTECCIÓN ACTIVO',
                  style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF005137))),
            ],
          ),
        ),
        const SizedBox(height: 14),
        const Text('Mi Perfil de Alergias',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600, color: _ink)),
        const SizedBox(height: 6),
        const Text(
          'Selecciona los ingredientes que debes evitar. La IA de BiteSano los detectará automáticamente al escanear cualquier menú.',
          style: TextStyle(fontSize: 15, height: 1.5, color: _inkSoft),
        ),
      ],
    );
  }

  Widget _buildSearch() {
    return TextField(
      controller: _searchCtrl,
      onChanged: (_) => setState(() {}),
      decoration: _inputDecoration('Buscar alérgeno (ej. nueces, gluten...)',
          prefix: const Icon(Icons.search_rounded)),
    );
  }

  Widget _buildAiBanner() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFFE1E6FF), Color(0xFFD6F6EA)]),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 24,
            backgroundColor: BiteSanoColors.forest,
            child: Icon(Icons.psychology_outlined, color: Colors.white),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Detección Multilingüe 99.4%',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: _ink)),
                Text('Reconoce salsas ocultas, caldos e ingredientes en 12 idiomas.',
                    style: TextStyle(fontSize: 13, color: _inkSoft)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _title(String text, {String? trailing, String? action, String? subtitle}) {
    return Padding(
      padding: const EdgeInsets.only(top: 30, bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(text,
                    style: const TextStyle(
                        fontSize: 19, fontWeight: FontWeight.w600, color: _ink)),
              ),
              if (trailing != null) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                  decoration: BoxDecoration(
                    color: BiteSanoColors.forest,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(trailing,
                      style: const TextStyle(
                          color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
                ),
              ],
              if (action != null) ...[
                const SizedBox(width: 8),
                Text(action,
                    style: const TextStyle(
                        color: BiteSanoColors.forest,
                        fontSize: 12,
                        fontWeight: FontWeight.w600)),
              ],
            ],
          ),
          if (subtitle != null)
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Text(subtitle, style: const TextStyle(fontSize: 13, color: _inkSoft)),
            ),
        ],
      ),
    );
  }

  Widget _buildActiveCard(_Allergen a) {
    final (bg, strong) = _levelColors(a.level);
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(22)),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(color: strong, borderRadius: BorderRadius.circular(14)),
            child: Icon(a.icon, color: Colors.white),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(a.name,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600, color: strong)),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                      decoration: BoxDecoration(
                          color: strong, borderRadius: BorderRadius.circular(20)),
                      child: Text(a.level.toUpperCase(),
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
                Text(a.desc, style: TextStyle(fontSize: 13, color: strong)),
              ],
            ),
          ),
          IconButton(
            onPressed: () => setState(() => _active.remove(a)),
            icon: Icon(Icons.close_rounded, color: strong),
            tooltip: 'Eliminar alérgeno',
          ),
        ],
      ),
    );
  }

  Widget _buildQuickGrid(List<_Allergen> items) {
    return LayoutBuilder(builder: (context, c) {
      final half = (c.maxWidth - 12) / 2;
      return Wrap(
        spacing: 12,
        runSpacing: 12,
        children: [
          for (final (i, a) in items.indexed)
            // Si queda un elemento solo en la última fila, ocupa todo el ancho.
            SizedBox(
              width: (i == items.length - 1 && i.isEven) ? c.maxWidth : half,
              child: _buildQuickCard(a, wide: i == items.length - 1 && i.isEven),
            ),
        ],
      );
    });
  }

  Widget _buildQuickCard(_Allergen a, {required bool wide}) {
    final icon = Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
          color: const Color(0xFFDAE8FF), borderRadius: BorderRadius.circular(12)),
      child: Icon(a.icon, color: BiteSanoColors.deepForest, size: 22),
    );
    final plus = Icon(Icons.add_circle_outline_rounded, color: BiteSanoColors.forest);
    final texts = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(a.name,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: _ink)),
        Text(a.desc, style: const TextStyle(fontSize: 12.5, color: _inkSoft)),
      ],
    );
    return InkWell(
      onTap: () => _add(a),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: BiteSanoColors.fieldBackground,
          borderRadius: BorderRadius.circular(20),
        ),
        child: wide
            ? Row(children: [icon, const SizedBox(width: 14), Expanded(child: texts), plus])
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [icon, plus]),
                  const SizedBox(height: 12),
                  texts,
                ],
              ),
      ),
    );
  }

  Widget _buildCustomInput() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _customCtrl,
            onSubmitted: (_) => _addCustom(),
            decoration: _inputDecoration('Ej. Cilantro, Apio, Piña...'),
          ),
        ),
        const SizedBox(width: 12),
        SizedBox(
          height: 56,
          child: FilledButton.icon(
            onPressed: _addCustom,
            icon: const Icon(Icons.add_rounded),
            label: const Text('Añadir'),
            style: FilledButton.styleFrom(
              backgroundColor: BiteSanoColors.forest,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
              textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCrossContamination() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: BiteSanoColors.fieldBackground,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
                color: const Color(0xFFDAE2FD), borderRadius: BorderRadius.circular(14)),
            child: const Icon(Icons.restaurant_rounded, color: _inkSoft),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Alerta de Contaminación Cruzada',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: _ink)),
                Text('Notificar si el restaurante suele freír o procesar en superficies compartidas.',
                    style: TextStyle(fontSize: 13, color: _inkSoft)),
              ],
            ),
          ),
          Switch(
            value: _crossContamination,
            onChanged: (v) => setState(() => _crossContamination = v),
            activeThumbColor: Colors.white,
            activeTrackColor: BiteSanoColors.forest,
          ),
        ],
      ),
    );
  }

  Widget _buildSaveButton() {
    return Container(
      height: 62,
      decoration: BoxDecoration(
        color: BiteSanoColors.forest,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: BiteSanoColors.forest.withValues(alpha: 0.24),
            blurRadius: 14,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: widget.onContinueToScanner,
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.check_circle_rounded, color: Colors.white),
              SizedBox(width: 12),
              Text('Guardar y Continuar al Escáner',
                  style: TextStyle(
                      color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500)),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint, {Widget? prefix}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: BiteSanoColors.mutedText, fontSize: 15),
      filled: true,
      fillColor: BiteSanoColors.fieldBackground,
      prefixIcon: prefix,
      prefixIconColor: BiteSanoColors.forest,
      contentPadding: const EdgeInsets.symmetric(vertical: 17, horizontal: 16),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18), borderSide: BorderSide.none),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: BiteSanoColors.forest, width: 1.4),
      ),
    );
  }
}
