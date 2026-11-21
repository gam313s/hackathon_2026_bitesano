import '../data/catalog.dart';
import '../models/menu.dart';
import '../services/allergy_service.dart';
import '../services/spoonacular_service.dart';
import '../utils/food_text.dart';
import 'local_food_repository.dart';

class FoodRepository {
  final SpoonacularService remote;
  FoodRepository({SpoonacularService? remote})
    : remote = remote ?? SpoonacularService();

  Future<AllergyResult> analyze(
    MenuItem item,
    Set<String> allergies, {
    required bool demo,
    required bool useOnline,
  }) async {
    final terms = <String, List<String>>{...currentCatalog.allergyTerms};
    for (final allergy in allergies) {
      terms.putIfAbsent(allergy, () => [allergy]);
    }
    final local = localFood(item.name);
    final direct = <String, List<String>>{};
    final menuText = '${item.name} ${item.description ?? ''}';
    for (final allergy in allergies) {
      final evidence = terms[allergy]!
          .where((term) => foodContains(menuText, term))
          .toList();
      if (evidence.isNotEmpty) direct[allergy] = evidence;
    }
    if (direct.isNotEmpty && local != null) {
      return classifyReference(
        FoodReference(local.name, [
          ...local.ingredients,
          ...direct.values.expand((v) => v),
        ]),
        allergies,
        terms,
        demo
            ? 'receta ficticia y texto del menú'
            : 'referencia local y texto del menú',
      );
    }
    if (direct.isNotEmpty) {
      return AllergyResult(
        AllergyStatus.risk,
        'Posibles alérgenos: ${direct.keys.join(', ')}.\nMención en el menú: ${direct.values.expand((v) => v).join(', ')}.\nConfirma ingredientes y contacto cruzado.',
      );
    }
    if (local != null) {
      return classifyReference(
        local,
        allergies,
        terms,
        demo ? 'receta ficticia de demostración' : 'receta genérica local',
      );
    }
    if (demo || !useOnline)
      return const AllergyResult(
        AllergyStatus.insufficient,
        'No encontramos una referencia local. Consulta sus ingredientes con el restaurante.',
      );
    if (!remote.configured)
      return const AllergyResult(
        AllergyStatus.insufficient,
        'No hay referencia local y falta configurar Spoonacular.',
      );
    return remote.lookup(item, allergies, terms);
  }
}
