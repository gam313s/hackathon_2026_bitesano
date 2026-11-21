import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hackathon_2026_bitesano/services/auth_service.dart';
import 'package:hackathon_2026_bitesano/services/database_service.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

/// Prueba la base SQLite real (archivo temporal), no la versión en memoria.
void main() {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  late Directory dir;
  late String path;
  setUp(() {
    dir = Directory.systemTemp.createTempSync('bitesano_db');
    path = '${dir.path}/bitesano.db';
  });
  tearDown(() => dir.deleteSync(recursive: true));

  test('guarda la cuenta, sobrevive a reabrir la base y no guarda la clave', () async {
    var db = DatabaseService(path: path);
    var auth = SqliteAuthService(db);
    await auth.register(
      username: 'Maria',
      email: 'Maria@Correo.com',
      password: 'clave1234',
    );
    await db.close();

    // Reabrir = cerrar y volver a abrir la app.
    db = DatabaseService(path: path);
    auth = SqliteAuthService(db);
    expect((await auth.login('maria@correo.com', 'clave1234')).username, 'Maria');
    expect((await auth.login('MARIA', 'clave1234')).email, 'maria@correo.com');
    expect(auth.login('maria', 'incorrecta1'), throwsA(isA<AuthException>()));
    expect(auth.login('nadie', 'clave1234'), throwsA(isA<AuthException>()));

    final rows = await (await db.database).query('users');
    expect(rows, hasLength(1));
    expect(rows.first.values.join(' '), isNot(contains('clave1234')));
    await db.close();
  });

  test('rechaza correo y usuario repetidos', () async {
    final db = DatabaseService(path: path);
    final auth = SqliteAuthService(db);
    await auth.register(username: 'Maria', email: 'maria@correo.com', password: 'clave1234');
    await expectLater(
      auth.register(username: 'Otra', email: 'MARIA@correo.com', password: 'clave1234'),
      throwsA(isA<AuthException>().having((e) => e.message, 'mensaje', contains('correo'))),
    );
    await expectLater(
      auth.register(username: 'MARIA', email: 'otra@correo.com', password: 'clave1234'),
      throwsA(isA<AuthException>().having((e) => e.message, 'mensaje', contains('usuario'))),
    );
    await db.close();
  });
}
