import 'package:hackathon_2026_bitesano/utils/profile_validation.dart';
import 'package:hackathon_2026_bitesano/controllers/bitesano_controller.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('valida nombre y correo sin imponer cuenta remota', () {
    expect(validateProfileName(''), isNotNull);
    expect(validateProfileName('123'), isNotNull);
    expect(validateProfileName('María González'), isNull);
    expect(validateOptionalEmail(''), isNull);
    expect(validateOptionalEmail('maria@@correo.com'), isNotNull);
    expect(validateOptionalEmail('maria@correo'), isNotNull);
    expect(validateOptionalEmail('maria@-correo.com'), isNotNull);
    expect(validateOptionalEmail('maria+demo@correo.com'), isNull);
  });
  test(
    'controlador rechaza perfiles inválidos y alergias duplicadas',
    () async {
      final c = BiteSanoController();
      expect(await c.enter('', 'abc', false), isFalse);
      expect(c.signedIn, isFalse);
      expect(await c.enter('Invitado', '', false), isTrue);
      expect(c.addAllergy('nuez'), isTrue);
      expect(c.addAllergy(' NUEZ '), isFalse);
      expect(c.addAllergy('123'), isFalse);
      expect(c.allergies.length, 1);
      c.dispose();
    },
  );
}
