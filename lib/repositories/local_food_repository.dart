import '../data/catalog.dart';
import '../models/menu.dart';
import '../utils/food_text.dart';

FoodReference? localFood(String name) {
  final key = normalizeFood(name).replaceFirst(
    RegExp(r'^(?:orden de |plato de |\d+ piezas de |\d+ (?=tacos\b))'),
    '',
  );
  final references = currentCatalog.references;
  final aliases = currentCatalog.aliases;
  final direct = references[key] ?? references[aliases[key]];
  if (direct != null) return direct;
  // Los catálogos suelen agregar tamaños, sabores o descripciones.
  // Solo se amplía un nombre cuando coincide con una referencia completa y el
  // resto empieza por un modificador reconocible; nunca se usa distancia difusa.
  final keys = [...references.keys, ...aliases.keys]
    ..sort((a, b) => b.length.compareTo(a.length));
  for (final known in keys) {
    if (!key.startsWith('$known ')) continue;
    final suffix = key.substring(known.length).trim();
    if (RegExp(
      r'^(?:con |sin |de |al |a la |en |doble\b|grande\b|chico\b|mediano\b|individual\b|familiar\b|\d+ ?(?:oz|ml|g|gr|pzas?)\b)',
    ).hasMatch(suffix)) {
      final reference =
          references[known] ?? references[aliases[known]];
      // No reutilizar una preparación genérica si el nombre indica una variante
      // completamente ajena (p. ej. «agua de ...» o «jugo de ...»).
      if (['agua', 'fruta', 'te', 'refresco', 'arroz'].contains(known))
        continue;
      if (reference != null) return reference;
    }
  }
  return null;
}
