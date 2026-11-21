import 'package:sqflite/sqflite.dart';

import '../data/allergens.dart' as seed_allergens;
import '../data/catalog.dart';
import '../data/food_catalog.dart' as seed_food;
import '../models/menu.dart';
import '../services/database_service.dart';

/// Guarda y lee el catálogo de alimentos y alérgenos en SQLite.
///
/// La primera vez la base se llena con todo lo que hay en `lib/data`
/// (alérgenos y términos, platillos con ingredientes, alias y menú de demo).
/// Después la app lee siempre desde la base.
class CatalogRepository {
  final DatabaseService _database;
  CatalogRepository([DatabaseService? database])
    : _database = database ?? DatabaseService.instance;

  Future<FoodCatalog> load() async {
    final db = await _database.database;
    await _seedIfEmpty(db);
    return _read(db);
  }

  Future<void> _seedIfEmpty(Database db) async {
    final count = Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM foods'),
    );
    if ((count ?? 0) > 0) return;
    await db.transaction((txn) async {
      final batch = txn.batch();
      seed_allergens.allergyTerms.forEach((key, terms) {
        batch.insert('allergens', {'key': key});
        for (var i = 0; i < terms.length; i++) {
          batch.insert('allergen_terms', {
            'allergen_key': key,
            'position': i,
            'term': terms[i],
          });
        }
      });
      seed_food.localReferences.forEach((key, reference) {
        batch.insert('foods', {'key': key, 'name': reference.name});
        for (var i = 0; i < reference.ingredients.length; i++) {
          batch.insert('food_ingredients', {
            'food_key': key,
            'position': i,
            'ingredient': reference.ingredients[i],
          });
        }
      });
      seed_food.foodAliases.forEach((alias, key) {
        batch.insert('food_aliases', {'alias': alias, 'food_key': key});
      });
      for (var i = 0; i < seed_food.demoMenu.length; i++) {
        final item = seed_food.demoMenu[i];
        batch.insert('demo_menu', {
          'position': i,
          'name': item.name,
          'price': item.price,
          'description': item.description,
          'section': item.section,
          'currency': item.currency,
        });
      }
      await batch.commit(noResult: true);
    });
  }

  Future<FoodCatalog> _read(Database db) async {
    final terms = <String, List<String>>{};
    for (final row in await db.query('allergens', orderBy: 'rowid')) {
      terms[row['key'] as String] = [];
    }
    for (final row in await db.query(
      'allergen_terms',
      orderBy: 'allergen_key, position',
    )) {
      terms[row['allergen_key'] as String]?.add(row['term'] as String);
    }

    final ingredients = <String, List<String>>{};
    for (final row in await db.query(
      'food_ingredients',
      orderBy: 'food_key, position',
    )) {
      (ingredients[row['food_key'] as String] ??= []).add(
        row['ingredient'] as String,
      );
    }
    final references = <String, FoodReference>{};
    for (final row in await db.query('foods', orderBy: 'rowid')) {
      final key = row['key'] as String;
      references[key] = FoodReference(
        row['name'] as String,
        List.unmodifiable(ingredients[key] ?? const []),
      );
    }

    final aliases = <String, String>{};
    for (final row in await db.query('food_aliases', orderBy: 'rowid')) {
      aliases[row['alias'] as String] = row['food_key'] as String;
    }

    final demo = <MenuItem>[
      for (final row in await db.query('demo_menu', orderBy: 'position'))
        MenuItem(
          row['name'] as String,
          row['price'] as String?,
          description: row['description'] as String?,
          section: row['section'] as String?,
          currency: row['currency'] as String,
        ),
    ];

    return FoodCatalog(
      references: references,
      aliases: aliases,
      allergyTerms: terms,
      demoMenu: demo,
    );
  }
}
