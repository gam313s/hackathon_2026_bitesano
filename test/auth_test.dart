import 'package:flutter_test/flutter_test.dart';
import 'package:hackathon_2026_bitesano/controllers/bitesano_controller.dart';
import 'package:hackathon_2026_bitesano/services/auth_service.dart';
import 'package:hackathon_2026_bitesano/utils/profile_validation.dart';

void main() {
  group('validaciones de registro', () {
    test('usuario', () {
      expect(validateUsername(''), isNotNull);
      expect(validateUsername('ab'), isNotNull);
      expect(validateUsername('con espacio'), isNotNull);
      expect(validateUsername('maria_g.1'), isNull);
    });
    test('correo obligatorio', () {
      expect(validateRequiredEmail(''), isNotNull);
      expect(validateRequiredEmail('abc'), isNotNull);
      expect(validateRequiredEmail('maria@correo.com'), isNull);
    });
    test('contraseña', () {
      expect(validatePassword(''), isNotNull);
      expect(validatePassword('corta1'), isNotNull);
      expect(validatePassword('sololetras'), isNotNull);
      expect(validatePassword('12345678'), isNotNull);
      expect(validatePassword('clave1234'), isNull);
    });
  });

  group('cuentas', () {
    test('el hash cambia con la sal y no contiene la contraseña', () {
      final a = hashPassword('clave1234', 'sal-a');
      expect(a, isNot(contains('clave1234')));
      expect(a, isNot(hashPassword('clave1234', 'sal-b')));
      expect(a, hashPassword('clave1234', 'sal-a'));
    });

    test('registra e inicia sesión con correo o usuario', () async {
      final auth = InMemoryAuthService();
      await auth.register(
        username: 'Maria',
        email: 'Maria@Correo.com',
        password: 'clave1234',
      );
      expect((await auth.login('maria@correo.com', 'clave1234')).username, 'Maria');
      expect((await auth.login('maria', 'clave1234')).email, 'maria@correo.com');
    });

    test('rechaza contraseña incorrecta y usuario inexistente', () async {
      final auth = InMemoryAuthService();
      await auth.register(
        username: 'Maria',
        email: 'maria@correo.com',
        password: 'clave1234',
      );
      expect(auth.login('maria', 'otra12345'), throwsA(isA<AuthException>()));
      expect(auth.login('nadie', 'clave1234'), throwsA(isA<AuthException>()));
    });

    test('no permite correo ni usuario repetidos', () async {
      final auth = InMemoryAuthService();
      await auth.register(
        username: 'Maria',
        email: 'maria@correo.com',
        password: 'clave1234',
      );
      expect(
        auth.register(username: 'Otra', email: 'MARIA@correo.com', password: 'clave1234'),
        throwsA(isA<AuthException>()),
      );
      expect(
        auth.register(username: 'maria', email: 'otra@correo.com', password: 'clave1234'),
        throwsA(isA<AuthException>()),
      );
    });
  });

  group('controlador', () {
    test('registrar crea la cuenta pero NO inicia la sesión', () async {
      final c = BiteSanoController(auth: InMemoryAuthService());
      final error = await c.register(
        username: 'Pedro',
        email: 'pedro@correo.com',
        password: 'clave1234',
      );
      expect(error, isNull);
      expect(c.signedIn, isFalse);
      // Después puede iniciar sesión con esa cuenta.
      expect(await c.login('pedro@correo.com', 'clave1234', false), isNull);
      expect(c.signedIn, isTrue);
      expect(c.name, 'Pedro');
      expect(c.email, 'pedro@correo.com');
    });

    test('login con datos incorrectos devuelve el mensaje y no entra', () async {
      final c = BiteSanoController(auth: InMemoryAuthService());
      final error = await c.login('nadie', 'clave1234', false);
      expect(error, isNotNull);
      expect(c.signedIn, isFalse);
    });
  });
}
