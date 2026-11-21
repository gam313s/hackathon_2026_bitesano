import 'package:flutter/material.dart';

import '../widgets/brand_components.dart';

enum _ResultFilter { all, danger, caution }

enum _ResultRisk { danger, caution, safe }

class _DishResult {
  const _DishResult({
    required this.name,
    required this.risk,
    required this.confidence,
    required this.tags,
    required this.detailTitle,
    required this.description,
    this.expandable = false,
  });

  final String name;
  final _ResultRisk risk;
  final String confidence;
  final List<String> tags;
  final String detailTitle;
  final String description;
  final bool expandable;
}

class AllergyResultsScreen extends StatefulWidget {
  const AllergyResultsScreen({super.key});

  @override
  State<AllergyResultsScreen> createState() => _AllergyResultsScreenState();
}

class _AllergyResultsScreenState extends State<AllergyResultsScreen> {
  _ResultFilter _filter = _ResultFilter.all;
  bool _showPreparation = false;

  static const _dishes = [
    _DishResult(
      name: 'Pasta ai Frutti di Mare con Salsa Pesto de Nueces',
      risk: _ResultRisk.danger,
      confidence: '99% Confianza',
      tags: ['Camarones y Calamares (Alto)', 'Nueces en salsa'],
      detailTitle: 'Diagnóstico del Asistente:',
      description: 'El plato contiene camarón fresco en la cocción de la pasta y nuez triturada como emulsionante en el pesto genovés.',
    ),
    _DishResult(
      name: 'Pollo a la Parrilla con Papas Rústicas',
      risk: _ResultRisk.caution,
      confidence: '84% Confianza',
      tags: ['Trazas de freidora compartida'],
      detailTitle: 'Riesgo de contaminación cruzada:',
      description: 'Posible uso de aceite con residuos de calamares fritos en las papas y mantequilla no declarada en el glaseado del pollo.',
    ),
    _DishResult(
      name: 'Salmón Grillado con Espárragos y Limón',
      risk: _ResultRisk.safe,
      confidence: '100% Compatible',
      tags: ['Sin Mariscos', 'Sin Frutos Secos', 'Sin Gluten'],
      detailTitle: 'Ingredientes y preparación limpia',
      description: 'Ingredientes revisados sin alérgenos de tu perfil ni señales de contaminación cruzada.',
      expandable: true,
    ),
    _DishResult(
      name: 'Risotto Clásico de Setas y Azafrán',
      risk: _ResultRisk.safe,
      confidence: '100% Compatible',
      tags: ['Libre de Alérgenos Perfil'],
      detailTitle: 'Ingredientes y preparación limpia',
      description: 'Ingredientes revisados sin alérgenos de tu perfil ni señales de contaminación cruzada.',
    ),
  ];

  List<_DishResult> get _visibleDishes => switch (_filter) {
    _ResultFilter.all => _dishes,
    _ResultFilter.danger =>
      _dishes.where((dish) => dish.risk == _ResultRisk.danger).toList(),
    _ResultFilter.caution =>
      _dishes.where((dish) => dish.risk == _ResultRisk.caution).toList(),
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BiteSanoColors.pageBackground,
      body: SafeArea(
        child: Column(
          children: [
            _header(),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
                children: [
                  _diagnosisHeader(),
                  const SizedBox(height: 16),
                  _safetySummary(),
                  const SizedBox(height: 22),
                  _filters(),
                  const SizedBox(height: 16),
                  ..._visibleDishes.map(_dishCard),
                  const SizedBox(height: 4),
                  _stressFreeBanner(),
                ],
              ),
            ),
            _chefButton(context),
          ],
        ),
      ),
    );
  }

  Widget _header() => Container(
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
    child: Row(
      children: [
        IconButton(
          tooltip: 'Volver al escáner',
          onPressed: () => Navigator.of(context).pop(),
          visualDensity: VisualDensity.compact,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints.tightFor(width: 36, height: 36),
          style: IconButton.styleFrom(
            foregroundColor: BiteSanoColors.deepForest,
            backgroundColor: Colors.white,
          ),
          icon: const Icon(Icons.arrow_back_rounded, size: 20),
        ),
        const SizedBox(width: 8),
        const BrandMark(size: 36),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BiteSanoWordmark(fontSize: 19),
            Text(
              'Historial / Análisis',
              style: TextStyle(fontSize: 12, color: BiteSanoColors.mutedText),
            ),
          ],
        ),
        Spacer(),
        CircleAvatar(
          radius: 19,
          backgroundColor: Color(0xFFE0F0EE),
          child: Icon(Icons.person_rounded, color: BiteSanoColors.deepForest),
        ),
      ],
    ),
  );

  Widget _diagnosisHeader() => const Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          Icon(
            Icons.check_circle_outline,
            size: 15,
            color: BiteSanoColors.forest,
          ),
          SizedBox(width: 6),
          Text(
            'DIAGNÓSTICO COMPLETADO',
            style: TextStyle(
              color: BiteSanoColors.deepForest,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.4,
            ),
          ),
        ],
      ),
      SizedBox(height: 7),
      Text(
        'Trattoria Bella Vista',
        style: TextStyle(
          fontSize: 23,
          fontWeight: FontWeight.w800,
          color: Color(0xFF111827),
        ),
      ),
      SizedBox(height: 3),
      Row(
        children: [
          Icon(Icons.restaurant_menu, size: 14, color: Color(0xFF374151)),
          SizedBox(width: 7),
          Expanded(
            child: Text.rich(
              TextSpan(
                style: TextStyle(fontSize: 12, color: Color(0xFF4B5563)),
                children: [
                  TextSpan(text: '18 platillos analizados • Perfil: '),
                  TextSpan(
                    text: 'Mariscos y Frutos Secos',
                    style: TextStyle(
                      color: Color(0xFF111827),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ],
  );

  Widget _safetySummary() => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: const Color(0xFF263B49).withValues(alpha: 0.05),
          blurRadius: 16,
          offset: const Offset(0, 5),
        ),
      ],
    ),
    child: Column(
      children: [
        Row(
          children: [
            const Icon(Icons.circle, size: 10, color: BiteSanoColors.forest),
            const SizedBox(width: 8),
            const Expanded(
              child: Text(
                'Semáforo de Seguridad',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: const Color(0xFFE8F0FE),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Text(
                'IA v2.4 Activa',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1E3A8A),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 11),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: const Row(
            children: [
              Expanded(
                flex: 13,
                child: SizedBox(
                  height: 11,
                  child: ColoredBox(color: BiteSanoColors.forest),
                ),
              ),
              Expanded(
                flex: 2,
                child: SizedBox(
                  height: 11,
                  child: ColoredBox(color: Color(0xFFA16207)),
                ),
              ),
              Expanded(
                flex: 3,
                child: SizedBox(
                  height: 11,
                  child: ColoredBox(color: Color(0xFFB91C1C)),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            _statCard(
              '13',
              'Seguros',
              Icons.verified_outlined,
              BiteSanoColors.forest,
            ),
            const SizedBox(width: 8),
            _statCard(
              '2',
              'Con Trazas',
              Icons.warning_amber_outlined,
              const Color(0xFFA16207),
            ),
            const SizedBox(width: 8),
            _statCard(
              '3',
              'Peligrosos',
              Icons.cancel_outlined,
              const Color(0xFFB91C1C),
            ),
          ],
        ),
      ],
    ),
  );

  Widget _statCard(String count, String label, IconData icon, Color color) =>
      Expanded(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 3),
          decoration: BoxDecoration(
            color: const Color(0xFFF0F4FF),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, size: 14, color: color),
                  const SizedBox(width: 4),
                  Text(
                    count,
                    style: TextStyle(
                      color: color,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
              Text(label, style: const TextStyle(fontSize: 10.5)),
            ],
          ),
        ),
      );

  Widget _filters() => Row(
    children: [
      _filterChip('Todos (18)', _ResultFilter.all, BiteSanoColors.forest),
      const SizedBox(width: 7),
      _filterChip('Peligro (3)', _ResultFilter.danger, const Color(0xFFB91C1C)),
      const SizedBox(width: 7),
      _filterChip(
        'Precaución (2)',
        _ResultFilter.caution,
        const Color(0xFFA16207),
      ),
    ],
  );

  Widget _filterChip(String label, _ResultFilter filter, Color color) {
    final selected = _filter == filter;
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _filter = filter),
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
          decoration: BoxDecoration(
            color: selected ? color : const Color(0xFFE7EEFF),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (!selected) ...[
                Icon(Icons.circle, size: 8, color: color),
                const SizedBox(width: 5),
              ],
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: selected ? Colors.white : const Color(0xFF111827),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _dishCard(_DishResult dish) {
    final color = switch (dish.risk) {
      _ResultRisk.danger => const Color(0xFFB91C1C),
      _ResultRisk.caution => const Color(0xFFA16207),
      _ResultRisk.safe => BiteSanoColors.forest,
    };
    final background = switch (dish.risk) {
      _ResultRisk.danger => const Color(0xFFFDE8E8),
      _ResultRisk.caution => const Color(0xFFFFE6C7),
      _ResultRisk.safe => const Color(0xFFE0F0EE),
    };
    final label = switch (dish.risk) {
      _ResultRisk.danger => 'PELIGRO • NO CONSUMIR',
      _ResultRisk.caution => 'PRECAUCIÓN • CONSULTAR',
      _ResultRisk.safe => 'SEGURO PARA TI',
    };
    final icon = switch (dish.risk) {
      _ResultRisk.danger => Icons.dangerous_outlined,
      _ResultRisk.caution => Icons.help_outline,
      _ResultRisk.safe => Icons.verified_outlined,
    };

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF263B49).withValues(alpha: 0.04),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          decoration: BoxDecoration(
            border: Border(left: BorderSide(color: color, width: 5)),
          ),
          padding: const EdgeInsets.fromLTRB(18, 15, 16, 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Flexible(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: background,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(icon, size: 13, color: color),
                          const SizedBox(width: 5),
                          Flexible(
                            child: Text(
                              label,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: color,
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    dish.confidence,
                    style: const TextStyle(
                      fontSize: 10.5,
                      color: Color(0xFF374151),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                dish.name,
                style: const TextStyle(
                  fontSize: 16,
                  height: 1.2,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF111827),
                ),
              ),
              const SizedBox(height: 9),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: dish.tags
                    .map((tag) => _tag(tag, background, color))
                    .toList(),
              ),
              const SizedBox(height: 10),
              if (dish.risk != _ResultRisk.safe)
                _riskDescription(dish, background, color, icon)
              else
                InkWell(
                  onTap: dish.expandable
                      ? () =>
                            setState(() => _showPreparation = !_showPreparation)
                      : null,
                  child: Row(
                    children: [
                      const Icon(
                        Icons.menu_book_outlined,
                        size: 15,
                        color: BiteSanoColors.deepForest,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          dish.detailTitle,
                          style: const TextStyle(
                            fontSize: 11.5,
                            color: BiteSanoColors.deepForest,
                          ),
                        ),
                      ),
                      if (dish.expandable)
                        Icon(
                          _showPreparation
                              ? Icons.keyboard_arrow_up
                              : Icons.keyboard_arrow_down,
                          size: 19,
                          color: BiteSanoColors.deepForest,
                        ),
                    ],
                  ),
                ),
              if (dish.expandable && _showPreparation) ...[
                const SizedBox(height: 8),
                Text(
                  dish.description,
                  style: const TextStyle(
                    fontSize: 11.5,
                    height: 1.3,
                    color: Color(0xFF4B5563),
                  ),
                ),
              ],
              if (dish.risk == _ResultRisk.caution) ...[
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton.icon(
                    onPressed: () => _showChefCard(context),
                    style: TextButton.styleFrom(
                      foregroundColor: const Color(0xFF7C4A03),
                      visualDensity: VisualDensity.compact,
                    ),
                    icon: const Icon(Icons.arrow_forward, size: 15),
                    label: const Text(
                      '¿Qué preguntarle al mesero?',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _riskDescription(
    _DishResult dish,
    Color background,
    Color color,
    IconData icon,
  ) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: background.withValues(alpha: 0.6),
      borderRadius: BorderRadius.circular(14),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 17, color: color),
        const SizedBox(width: 9),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                dish.detailTitle,
                style: TextStyle(
                  color: color,
                  fontSize: 11.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                dish.description,
                style: const TextStyle(
                  fontSize: 11.5,
                  height: 1.3,
                  color: Color(0xFF374151),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );

  Widget _tag(String label, Color background, Color color) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
    decoration: BoxDecoration(
      color: background.withValues(alpha: 0.65),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Text(
      label,
      style: TextStyle(
        fontSize: 10.5,
        color: color,
        fontWeight: FontWeight.w500,
      ),
    ),
  );

  Widget _stressFreeBanner() => Container(
    padding: const EdgeInsets.all(15),
    decoration: BoxDecoration(
      color: const Color(0xFFE9EDFF),
      borderRadius: BorderRadius.circular(18),
    ),
    child: const Row(
      children: [
        CircleAvatar(
          radius: 19,
          backgroundColor: Color(0xFFDCE3FF),
          child: Icon(Icons.chevron_left, color: BiteSanoColors.deepForest),
        ),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Come sin estrés',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
              ),
              Text(
                'Si tienes dudas, utiliza nuestra tarjeta de cocina para mostrársela directamente al personal.',
                style: TextStyle(
                  fontSize: 11.5,
                  height: 1.25,
                  color: Color(0xFF4B5563),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );

  Widget _chefButton(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
    child: SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton.icon(
        onPressed: () => _showChefCard(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: BiteSanoColors.forest,
          foregroundColor: Colors.white,
          elevation: 8,
          shadowColor: BiteSanoColors.forest.withValues(alpha: 0.25),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        icon: const Icon(Icons.record_voice_over_outlined, size: 20),
        label: const Text(
          'Mostrar Tarjeta al Mesero / Chef',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
    ),
  );

  void _showChefCard(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        icon: const Icon(
          Icons.health_and_safety_outlined,
          color: BiteSanoColors.forest,
        ),
        title: const Text('Aviso de alergias'),
        content: const Text(
          'Tengo alergia a mariscos y frutos secos. Por favor, confirme que el plato no los contiene ni tuvo contacto con ellos durante su preparación.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Entendido'),
          ),
        ],
      ),
    );
  }
}
