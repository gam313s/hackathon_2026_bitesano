import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hackathon_2026_bitesano/main.dart';
import 'package:hackathon_2026_bitesano/models/menu.dart';
import 'package:hackathon_2026_bitesano/repositories/food_repository.dart';

void main() {
  test('el repositorio clasifica un platillo local sin conexión', () async {
    final repository = FoodRepository();
    final risk = await repository.analyze(
      const MenuItem('Quesadillas', '80'),
      {'leche'},
      demo: false,
      useOnline: false,
    );
    final unknown = await repository.analyze(
      const MenuItem('Especial secreto', '100'),
      {'leche'},
      demo: false,
      useOnline: false,
    );
    expect(risk.status, AllergyStatus.risk);
    expect(unknown.status, AllergyStatus.insufficient);
  });

  testWidgets('flujo visitante, alergias, demostración, análisis y perfil', (
    tester,
  ) async {
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
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(const BiteSanoApp());
    await tester.pumpAndSettle();
    Future<void> tapVisible(String text, {bool upward = false}) async {
      final target = find.text(text);
      for (var i = 0; i < 20 && target.hitTestable().evaluate().isEmpty; i++) {
        await tester.drag(
          find.byType(ListView).first,
          Offset(0, upward ? 230 : -230),
        );
        await tester.pumpAndSettle();
      }
      expect(target.hitTestable(), findsOneWidget);
      await tester.tap(target.hitTestable());
      await tester.pumpAndSettle();
    }

    await tapVisible('Explorar como invitado');
    expect(find.text('Mi Perfil de Alergias'), findsOneWidget);
    await tapVisible('Lácteos / Leche');
    await tapVisible('Frutos secos');
    await tapVisible('Guardar y continuar al escáner');
    await tapVisible('Cargar menú de demostración sin internet');
    await tapVisible('Analizar menú con mis alergias', upward: true);
    expect(find.text('Semáforo de resultados'), findsOneWidget);
    expect(find.text('Riesgo (4)'), findsOneWidget);
    expect(find.text('Sin riesgo* (5)'), findsOneWidget);
    expect(find.text('Precaución (1)'), findsOneWidget);
    await tester.tap(find.text('Riesgo (4)'));
    await tester.pumpAndSettle();
    final smoothie = find.text('Smoothie de fresa con yogurt');
    for (var i = 0; i < 6 && smoothie.evaluate().isEmpty; i++) {
      await tester.drag(find.byType(ListView).first, const Offset(0, -200));
      await tester.pumpAndSettle();
    }
    expect(smoothie, findsOneWidget);
    await tester.tap(find.text('Perfil'));
    await tester.pumpAndSettle();
    expect(find.text('Mi Perfil de Alergias'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
