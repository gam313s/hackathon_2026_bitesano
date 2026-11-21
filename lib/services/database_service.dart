import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

/// Base de datos SQLite local (archivo `bitesano.db` dentro del dispositivo).
/// Se abre la primera vez que se usa, no al iniciar la app.
///
/// Tablas:
/// - `users`: cuentas (contraseña con hash).
/// - Catálogo: `allergens`, `allergen_terms`, `foods`, `food_ingredients`,
///   `food_aliases` y `demo_menu` (se llenan desde `lib/data`).
class DatabaseService {
  /// Instancia compartida por toda la app.
  static final DatabaseService instance = DatabaseService();

  static const _name = 'bitesano.db';
  static const _version = 2;

  /// [path] permite usar otra ubicación (por ejemplo, en pruebas).
  final String? _path;
  DatabaseService({String? path}) : _path = path;
  Database? _db;

  Future<Database> get database async => _db ??= await _open();

  Future<Database> _open() async {
    final path = _path ?? p.join(await getDatabasesPath(), _name);
    return openDatabase(
      path,
      version: _version,
      onCreate: (db, _) async {
        await _createUsers(db);
        await _createCatalog(db);
      },
      // v1 solo tenía usuarios: se agrega el catálogo sin tocar las cuentas.
      onUpgrade: (db, oldVersion, _) async {
        if (oldVersion < 2) await _createCatalog(db);
      },
    );
  }

  static Future<void> _createUsers(Database db) => db.execute('''
    CREATE TABLE users (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      username TEXT NOT NULL UNIQUE COLLATE NOCASE,
      email TEXT NOT NULL UNIQUE COLLATE NOCASE,
      password_hash TEXT NOT NULL,
      salt TEXT NOT NULL,
      created_at TEXT NOT NULL
    )
  ''');

  static Future<void> _createCatalog(Database db) async {
    await db.execute('CREATE TABLE allergens (key TEXT PRIMARY KEY)');
    await db.execute('''
      CREATE TABLE allergen_terms (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        allergen_key TEXT NOT NULL REFERENCES allergens(key),
        position INTEGER NOT NULL,
        term TEXT NOT NULL
      )
    ''');
    await db.execute('''
      CREATE TABLE foods (
        key TEXT PRIMARY KEY,
        name TEXT NOT NULL
      )
    ''');
    await db.execute('''
      CREATE TABLE food_ingredients (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        food_key TEXT NOT NULL REFERENCES foods(key),
        position INTEGER NOT NULL,
        ingredient TEXT NOT NULL
      )
    ''');
    await db.execute('''
      CREATE TABLE food_aliases (
        alias TEXT PRIMARY KEY,
        food_key TEXT NOT NULL
      )
    ''');
    await db.execute('''
      CREATE TABLE demo_menu (
        position INTEGER PRIMARY KEY,
        name TEXT NOT NULL,
        price TEXT,
        description TEXT,
        section TEXT,
        currency TEXT NOT NULL
      )
    ''');
    await db.execute(
      'CREATE INDEX idx_ingredients_food ON food_ingredients(food_key, position)',
    );
    await db.execute(
      'CREATE INDEX idx_terms_allergen ON allergen_terms(allergen_key, position)',
    );
  }

  Future<void> close() async {
    await _db?.close();
    _db = null;
  }
}
