import 'dart:ui';

import 'package:hackathon_2026_bitesano/models/menu.dart';
import 'package:hackathon_2026_bitesano/data/food_catalog.dart';
import 'package:hackathon_2026_bitesano/repositories/local_food_repository.dart';
import 'package:hackathon_2026_bitesano/services/allergy_service.dart';
import 'package:hackathon_2026_bitesano/services/menu_ocr_service.dart';
import 'package:flutter_test/flutter_test.dart';

MenuOcrLine line(String name, double x, double y, [double width = 140]) =>
    MenuOcrLine(name, Rect.fromLTWH(x, y, width, 10));

void main() {
  test('respeta dos columnas y precios sin símbolo de moneda', () {
    final items = reconstructMenu([
      line('TACOS', 10, 0),
      line('Tacos al pastor', 10, 20),
      line('Pozole rojo', 10, 45),
      line('HAMBURGUESAS', 300, 0),
      line('Hamburguesa clásica', 300, 20),
      line('Hamburguesa BBQ', 300, 45),
      line('115', 200, 20, 25),
      line('160', 500, 20, 25),
      line('180', 500, 45, 25),
    ]);
    expect(items.map((item) => item.name), [
      'Tacos al pastor',
      'Pozole rojo',
      'Hamburguesa clásica',
      'Hamburguesa BBQ',
    ]);
    expect(items.map((item) => item.price), ['115', null, '160', '180']);
  });

  test('catálogo mexicano y comida rápida reconocen nombres alternativos', () {
    for (final name in [
      'Pozole rojo',
      'ORDEN DE TACOS AL PASTOR',
      'Hamburguesa clásica',
      'Quesadillas',
      'Mole poblano',
      'Chicharrón en salsa verde',
      'Cochinita pibil',
      'Camarones empanizados',
      'Pastel de tres leches',
    ]) {
      expect(localFood(name), isNotNull, reason: name);
    }
    expect(localReferences.length, greaterThanOrEqualTo(180));
    expect(foodAliases.length, greaterThanOrEqualTo(100));
    expect(localFood('Especial secreto del chef'), isNull);
    expect(
      classifyReference(
        localFood('Quesadillas')!,
        {'leche'},
        {
          'leche': ['queso'],
        },
        'local',
      ).status,
      AllergyStatus.risk,
    );
    expect(
      classifyReference(
        localFood('Mole poblano')!,
        {'nuez'},
        {
          'nuez': ['almendra'],
        },
        'local',
      ).status,
      AllergyStatus.risk,
    );
  });
}
