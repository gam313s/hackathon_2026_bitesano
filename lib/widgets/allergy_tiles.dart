import 'package:flutter/material.dart';

import '../models/profile.dart';
import '../theme/app_theme.dart';
import 'brand.dart';

class AllergyInfo {
  final String key;
  final String title;
  final String description;
  final IconData icon;
  const AllergyInfo(this.key, this.title, this.description, this.icon);
}

const allergyOptions = <AllergyInfo>[
  AllergyInfo(
    'cacahuate',
    'Maní / Cacahuates',
    'Incluye aceites no refinados y harinas',
    Icons.warning_amber_rounded,
  ),
  AllergyInfo(
    'mariscos',
    'Mariscos y Crustáceos',
    'Camarón, langosta, cangrejo, moluscos',
    Icons.set_meal_outlined,
  ),
  AllergyInfo(
    'trigo',
    'Gluten / Trigo',
    'Trigo y preparaciones con harina',
    Icons.grain,
  ),
  AllergyInfo(
    'leche',
    'Lácteos / Leche',
    'Leche, mantequilla, queso y crema',
    Icons.water_drop_outlined,
  ),
  AllergyInfo(
    'nuez',
    'Frutos secos',
    'Nueces, almendras, avellanas',
    Icons.eco_outlined,
  ),
  AllergyInfo(
    'pescado',
    'Pescados',
    'Atún, salmón, bacalao',
    Icons.set_meal_outlined,
  ),
  AllergyInfo(
    'huevo',
    'Huevo',
    'Clara, yema y preparaciones',
    Icons.egg_outlined,
  ),
  AllergyInfo('soya', 'Soya', 'Tofu, soya y salsa', Icons.spa_outlined),
  AllergyInfo(
    'ajonjolí',
    'Sésamo',
    'Tahini y semillas',
    Icons.scatter_plot_outlined,
  ),
  AllergyInfo(
    'sulfitos',
    'Sulfitos',
    'Conservas y algunas bebidas',
    Icons.wine_bar_outlined,
  ),
  AllergyInfo(
    'mostaza',
    'Mostaza',
    'Aderezos y condimentos',
    Icons.grass_outlined,
  ),
];
AllergyInfo allergyInfo(String key) => allergyOptions.firstWhere(
  (a) => a.key == key,
  orElse: () => AllergyInfo(
    key,
    key,
    'Ingrediente personalizado',
    Icons.restaurant_outlined,
  ),
);

(Color, Color) severityColors(AllergySeverity severity) => switch (severity) {
  AllergySeverity.high => (BiteColors.danger, BiteColors.dangerBg),
  AllergySeverity.moderate => (BiteColors.amber, BiteColors.amberBg),
  AllergySeverity.intolerance => (BiteColors.blueGray, BiteColors.blueBg),
};

class ActiveAllergyTile extends StatelessWidget {
  final String allergy;
  final AllergySeverity severity;
  final VoidCallback? onRemove;
  final VoidCallback? onEdit;
  const ActiveAllergyTile({
    super.key,
    required this.allergy,
    required this.severity,
    this.onRemove,
    this.onEdit,
  });
  @override
  Widget build(BuildContext context) {
    final info = allergyInfo(allergy);
    final (color, bg) = severityColors(severity);
    return Container(
      margin: const EdgeInsets.only(bottom: 9),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(17),
      ),
      child: Material(
        type: MaterialType.transparency,
        child: ListTile(
          onTap: onEdit,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 4,
          ),
          leading: Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(info.icon, color: Colors.white),
          ),
          title: Text(
            info.title,
            style: TextStyle(color: color, fontWeight: FontWeight.w800),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 3),
              StatusPill(
                label: severity.label,
                color: Colors.white,
                background: color,
              ),
              const SizedBox(height: 4),
              Text(
                info.description,
                style: TextStyle(color: color, fontSize: 12),
              ),
            ],
          ),
          trailing: IconButton(
            onPressed: onRemove,
            tooltip: 'Quitar ${info.title}',
            icon: Icon(Icons.close, color: color, size: 20),
          ),
        ),
      ),
    );
  }
}

class AllergyOptionTile extends StatelessWidget {
  final AllergyInfo info;
  final VoidCallback? onTap;
  const AllergyOptionTile({super.key, required this.info, required this.onTap});
  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(16),
    child: Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: BiteColors.input,
        borderRadius: BorderRadius.circular(17),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 35,
                height: 35,
                decoration: BoxDecoration(
                  color: BiteColors.blueBg,
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Icon(info.icon, color: BiteColors.green, size: 20),
              ),
              const Spacer(),
              const Icon(
                Icons.add_circle_outline,
                color: BiteColors.green,
                size: 20,
              ),
            ],
          ),
          const SizedBox(height: 9),
          Text(info.title, style: const TextStyle(fontWeight: FontWeight.w700)),
          Text(
            info.description,
            style: const TextStyle(
              color: BiteColors.muted,
              fontSize: 11,
              height: 1.35,
            ),
          ),
        ],
      ),
    ),
  );
}
