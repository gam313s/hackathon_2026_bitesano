import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:sqflite/sqflite.dart';

import '../models/account.dart';
import 'database_service.dart';

class AuthException implements Exception {
  final String message;
  const AuthException(this.message);
  @override
  String toString() => message;
}

abstract class AuthService {
  Future<Account> register({
    required String username,
    required String email,
    required String password,
  });

  /// [identifier] puede ser el correo o el nombre de usuario.
  Future<Account> login(String identifier, String password);
}

String _newSalt() {
  final random = Random.secure();
  return base64UrlEncode(List<int>.generate(16, (_) => random.nextInt(256)));
}

/// SHA-256 con sal y 10 000 repeticiones. La contraseña nunca se guarda tal cual.
String hashPassword(String password, String salt) {
  var digest = sha256.convert(utf8.encode('$salt:$password')).bytes;
  for (var i = 0; i < 10000; i++) {
    digest = sha256.convert([...digest, ...utf8.encode(salt)]).bytes;
  }
  return base64UrlEncode(digest);
}

bool _sameHash(String a, String b) {
  if (a.length != b.length) return false;
  var diff = 0;
  for (var i = 0; i < a.length; i++) {
    diff |= a.codeUnitAt(i) ^ b.codeUnitAt(i);
  }
  return diff == 0;
}

const _badLogin = AuthException('Correo, usuario o contraseña incorrectos');

/// Guarda las cuentas en la base de datos SQLite del dispositivo.
class SqliteAuthService implements AuthService {
  final DatabaseService _database;
  SqliteAuthService([DatabaseService? database])
    : _database = database ?? DatabaseService.instance;

  @override
  Future<Account> register({
    required String username,
    required String email,
    required String password,
  }) async {
    final db = await _database.database;
    final user = username.trim();
    final mail = email.trim().toLowerCase();
    final taken = await db.query(
      'users',
      columns: ['username', 'email'],
      where: 'username = ? OR email = ?',
      whereArgs: [user, mail],
      limit: 1,
    );
    if (taken.isNotEmpty) {
      final sameMail = (taken.first['email'] as String).toLowerCase() == mail;
      throw AuthException(
        sameMail
            ? 'Ese correo ya está registrado'
            : 'Ese nombre de usuario ya existe',
      );
    }
    final salt = _newSalt();
    try {
      final id = await db.insert('users', {
        'username': user,
        'email': mail,
        'password_hash': hashPassword(password, salt),
        'salt': salt,
        'created_at': DateTime.now().toUtc().toIso8601String(),
      });
      return Account(id: id, username: user, email: mail);
    } on DatabaseException {
      throw const AuthException('No se pudo crear la cuenta. Inténtalo de nuevo.');
    }
  }

  @override
  Future<Account> login(String identifier, String password) async {
    final db = await _database.database;
    final key = identifier.trim();
    final rows = await db.query(
      'users',
      where: 'email = ? OR username = ?',
      whereArgs: [key.toLowerCase(), key],
      limit: 1,
    );
    if (rows.isEmpty) throw _badLogin;
    final row = rows.first;
    final hash = hashPassword(password, row['salt'] as String);
    if (!_sameHash(hash, row['password_hash'] as String)) throw _badLogin;
    return Account(
      id: row['id'] as int,
      username: row['username'] as String,
      email: row['email'] as String,
    );
  }
}

/// Versión en memoria para pruebas y plataformas sin SQLite.
class InMemoryAuthService implements AuthService {
  final List<({Account account, String salt, String hash})> _rows = [];

  @override
  Future<Account> register({
    required String username,
    required String email,
    required String password,
  }) async {
    final mail = email.trim().toLowerCase();
    final user = username.trim();
    for (final row in _rows) {
      if (row.account.email == mail) {
        throw const AuthException('Ese correo ya está registrado');
      }
      if (row.account.username.toLowerCase() == user.toLowerCase()) {
        throw const AuthException('Ese nombre de usuario ya existe');
      }
    }
    final salt = _newSalt();
    final account = Account(id: _rows.length + 1, username: user, email: mail);
    _rows.add((account: account, salt: salt, hash: hashPassword(password, salt)));
    return account;
  }

  @override
  Future<Account> login(String identifier, String password) async {
    final key = identifier.trim().toLowerCase();
    for (final row in _rows) {
      if (row.account.email == key || row.account.username.toLowerCase() == key) {
        if (_sameHash(hashPassword(password, row.salt), row.hash)) {
          return row.account;
        }
        break;
      }
    }
    throw _badLogin;
  }
}
