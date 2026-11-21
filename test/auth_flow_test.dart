import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hackathon_2026_bitesano/controllers/bitesano_controller.dart';
import 'package:hackathon_2026_bitesano/screens/access_screen.dart';
import 'package:hackathon_2026_bitesano/screens/allergies_screen.dart';
import 'package:hackathon_2026_bitesano/screens/app_shell.dart';
import 'package:hackathon_2026_bitesano/screens/register_screen.dart';
import 'package:hackathon_2026_bitesano/services/auth_service.dart';
import 'package:hackathon_2026_bitesano/theme/app_theme.dart';

void main() {
  testWidgets('acceso → registro → app → cerrar sesión → login', (tester) async {
    const channel = MethodChannel('bitesano/preferences');
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
      channel,
      (_) async => null,
    );
    addTearDown(
      () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        channel,
        null,
      ),
    );
    tester.view.physicalSize = const Size(390, 1200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final c = BiteSanoController(auth: InMemoryAuthService());
    await tester.pumpWidget(
      MaterialApp(theme: buildTheme(), home: AppShell(controller: c)),
    );
    await tester.pumpAndSettle();

    Future<void> tap(Finder finder) async {
      await tester.ensureVisible(finder);
      await tester.pumpAndSettle();
      await tester.tap(finder);
      await tester.pumpAndSettle();
    }

    final login = find.widgetWithText(FilledButton, 'Iniciar sesión');
    final goRegister = find.widgetWithText(TextButton, 'Crear cuenta');
    final submitRegister = find.widgetWithText(FilledButton, 'Crear cuenta');

    // 1. Arranca en acceso, pidiendo contraseña.
    expect(find.byType(AccessScreen), findsOneWidget);
    expect(find.text('Contraseña'), findsOneWidget);

    // 2. Login con una cuenta que no existe → error, sigue en acceso.
    await tester.enterText(find.byType(TextFormField).at(0), 'nadie');
    await tester.enterText(find.byType(TextFormField).at(1), 'clave1234');
    await tap(login);
    expect(find.text('Correo, usuario o contraseña incorrectos'), findsOneWidget);
    expect(find.byType(AccessScreen), findsOneWidget);

    // 3. Ir al registro; solo hay una pantalla de cada tipo en pila.
    await tap(goRegister);
    expect(find.byType(RegisterScreen), findsOneWidget);

    // 4. Contraseñas distintas → no registra.
    final fields = find.byType(TextFormField);
    await tester.enterText(fields.at(0), 'maria@correo.com');
    await tester.enterText(fields.at(1), 'maria_g');
    await tester.enterText(fields.at(2), 'clave1234');
    await tester.enterText(fields.at(3), 'otraclave1');
    await tap(submitRegister);
    expect(find.text('Las contraseñas no coinciden'), findsOneWidget);
    expect(c.signedIn, isFalse);

    // 5. Datos correctos → crea la cuenta y REGRESA al inicio de sesión (sin entrar).
    await tester.enterText(fields.at(3), 'clave1234');
    await tap(submitRegister);
    expect(c.signedIn, isFalse);
    expect(find.byType(RegisterScreen), findsNothing);
    expect(find.byType(AccessScreen), findsOneWidget);
    expect(find.text('Cuenta creada. Inicia sesión con tu contraseña.'), findsOneWidget);
    // El correo registrado ya viene escrito en el campo de acceso.
    expect(find.text('maria@correo.com'), findsOneWidget);

    // 6. Login con la cuenta recién creada (el correo ya estaba escrito).
    await tester.enterText(find.byType(TextFormField).at(1), 'clave1234');
    await tap(login);
    expect(c.signedIn, isTrue);
    expect(c.name, 'maria_g');
    expect(find.byType(AccessScreen), findsNothing);
    expect(find.byType(AllergiesScreen), findsOneWidget);
  });
}
