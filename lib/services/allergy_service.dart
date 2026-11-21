import '../models/menu.dart';
import '../utils/food_text.dart';

Map<String, List<String>> findRisks(
  Iterable<String> ingredients,
  Set<String> allergies,
  Map<String, List<String>> terms,
) {
  final result = <String, List<String>>{};
  for (final allergy in allergies) {
    final matches = ingredients
        .where(
          (ingredient) => (terms[allergy] ?? []).any(
            (term) => foodContains(ingredient, term),
          ),
        )
        .toSet()
        .toList();
    if (matches.isNotEmpty) result[allergy] = matches;
  }
  return result;
}

AllergyResult classifyReference(
  FoodReference reference,
  Set<String> allergies,
  Map<String, List<String>> terms,
  String source,
) {
  final risks = findRisks(reference.ingredients, allergies, terms);
  final note =
      'Fuente: $source (${reference.name}). No son ingredientes verificados del restaurante.';
  if (reference.ingredients.isEmpty) {
    return AllergyResult(
      AllergyStatus.insufficient,
      'No hay ingredientes disponibles. $note',
    );
  }
  if (risks.isEmpty) {
    return AllergyResult(
      AllergyStatus.noMatch,
      '$note\nIngredientes de referencia: ${reference.ingredients.join(', ')}.\nConfirma ingredientes y contacto cruzado.',
    );
  }
  return AllergyResult(
    AllergyStatus.risk,
    'Alérgenos posibles: ${risks.keys.join(', ')}.\nIngredientes relacionados: ${risks.entries.map((e) => '${e.key}: ${e.value.join(', ')}').join('; ')}.\n$note\nConfirma ingredientes y contacto cruzado.',
  );
}
