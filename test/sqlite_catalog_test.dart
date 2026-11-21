import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hackathon_2026_bitesano/controllers/bitesano_controller.dart';
import 'package:hackathon_2026_bitesano/data/allergens.dart' as seed_allergens;
import 'package:hackathon_2026_bitesano/data/catalog.dart';
import 'package:hackathon_2026_bitesano/data/food_catalog.dart' as seed_food;
import 'package:hackathon_2026_bitesano/repositories/catalog_repository.dart';
import 'package:hackathon_2026_bitesano/repositories/local_food_repository.dart';
import 'package:hackathon_2026_bitesano/services/auth_service.dart';
import 'package:hackathon_2026_bitesano/services/database_service.dart';
import 'package:sqflite/sqflite.dart' show Sqflite;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

/// Comprueba con SQLite real que la base contiene TODO lo que hay en
/// lib/data/allergens.dart y lib/data/food_catalog.dart.
void main() {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  late Directory dir;
  late String path;
  setUp(() {
    dir = Directory.systemTemp.createTempSync('bitesano_catalog');
    path = '${dir.path}/bitesano.db';
  });
  tearDown(() {
    currentCatalog = const FoodCatalog.builtIn();
    dir.deleteSync(recursive: true);
  });

  test('la base guarda todos los alérgenos y sus términos', () async {
    final db = DatabaseService(path: path);
    final catalog = await CatalogRepository(db).load();
    expect(catalog.allergyTerms.keys.toList(),
        seed_allergens.allergyTerms.keys.toList());
    seed_allergens.allergyTerms.forEach((key, terms) {
      expect(catalog.allergyTerms[key], terms, reason: key);
    });
    await db.close();
  });

  test('la base guarda todos los platillos con sus ingredientes', () async {
    final db = DatabaseService(path: path);
    final catalog = await CatalogRepository(db).load();
    expect(catalog.references.length, seed_food.localReferences.length);
    expect(catalog.references.length, greaterThanOrEqualTo(180));
    seed_food.localReferences.forEach((key, reference) {
      final saved = catalog.references[key];
      expect(saved, isNotNull, reason: key);
      expect(saved!.name, reference.name, reason: key);
      expect(saved.ingredients, reference.ingredients, reason: key);
    });
    await db.close();
  });

  test('la base guarda los alias y el menú de demostración', () async {
    final db = DatabaseService(path: path);
    final catalog = await CatalogRepository(db).load();
    expect(catalog.aliases, seed_food.foodAliases);
    expect(catalog.demoMenu.length, seed_food.demoMenu.length);
    for (var i = 0; i < seed_food.demoMenu.length; i++) {
      final a = catalog.demoMenu[i];
      final b = seed_food.demoMenu[i];
      expect([a.name, a.price, a.description, a.section, a.currency],
          [b.name, b.price, b.description, b.section, b.currency]);
    }
    await db.close();
  });

  test('se llena una sola vez y sobrevive a reabrir la base', () async {
    var db = DatabaseService(path: path);
    await CatalogRepository(db).load();
    await CatalogRepository(db).load();
    final d = await db.database;
    final foods = Sqflite.firstIntValue(await d.rawQuery('SELECT COUNT(*) FROM foods'));
    expect(foods, seed_food.localReferences.length);
    await db.close();

    db = DatabaseService(path: path);
    final again = await CatalogRepository(db).load();
    expect(again.references.length, seed_food.localReferences.length);
    await db.close();
  });

  test('actualizar desde la versión 1 conserva los usuarios', () async {
    // Base antigua: solo la tabla de usuarios, versión 1.
    final old = await databaseFactory.openDatabase(
      path,
      options: OpenDatabaseOptions(
        version: 1,
        onCreate: (db, _) => db.execute('''
          CREATE TABLE users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            username TEXT NOT NULL UNIQUE COLLATE NOCASE,
            email TEXT NOT NULL UNIQUE COLLATE NOCASE,
            password_hash TEXT NOT NULL,
            salt TEXT NOT NULL,
            created_at TEXT NOT NULL
          )'''),
      ),
    );
    final salt = 's';
    await old.insert('users', {
      'username': 'Maria',
      'email': 'maria@correo.com',
      'password_hash': hashPassword('clave1234', salt),
      'salt': salt,
      'created_at': 'x',
    });
    await old.close();

    final db = DatabaseService(path: path);
    final catalog = await CatalogRepository(db).load();
    expect(catalog.references, isNotEmpty);
    expect((await SqliteAuthService(db).login('maria', 'clave1234')).email,
        'maria@correo.com');
    await db.close();
  });

  test('la app usa el catálogo de la base (localFood y demo)', () async {
    final db = DatabaseService(path: path);
    final controller = BiteSanoController(
      catalog: CatalogRepository(db),
      auth: InMemoryAuthService(),
    );
    await controller.initialize();
    expect(identical(currentCatalog.references, seed_food.localReferences), isFalse);
    expect(localFood('Quesadillas'), isNotNull);
    expect(localFood('Especial secreto del chef'), isNull);
    controller.loadDemo();
    expect(controller.items.length, seed_food.demoMenu.length);
    await db.close();
  });
}
