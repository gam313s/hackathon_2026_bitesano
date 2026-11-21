import '../models/menu.dart';
import 'allergens.dart' as seed_allergens;
import 'food_catalog.dart' as seed_food;

/// Catálogo de alimentos y alérgenos que usa la app.
///
/// Al iniciar se reemplaza por el que se lee de la base de datos SQLite
/// ([CatalogRepository]). Si la base no está disponible (web, pruebas) se usa
/// el catálogo incluido en `allergens.dart` y `food_catalog.dart`.
class FoodCatalog {
  final Map<String, FoodReference> references;
  final Map<String, String> aliases;
  final Map<String, List<String>> allergyTerms;
  final List<MenuItem> demoMenu;

  const FoodCatalog({
    required this.references,
    required this.aliases,
    required this.allergyTerms,
    required this.demoMenu,
  });

  /// Los mismos datos, tal como están escritos en `lib/data`.
  const FoodCatalog.builtIn()
    : references = seed_food.localReferences,
      aliases = seed_food.foodAliases,
      allergyTerms = seed_allergens.allergyTerms,
      demoMenu = seed_food.demoMenu;
}

/// Catálogo vigente. Lo reemplaza el controlador al leer la base de datos.
FoodCatalog currentCatalog = const FoodCatalog.builtIn();
