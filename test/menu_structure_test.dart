import 'dart:ui';

import 'package:hackathon_2026_bitesano/models/menu.dart';
import 'package:hackathon_2026_bitesano/repositories/food_repository.dart';
import 'package:hackathon_2026_bitesano/services/menu_ocr_service.dart';
import 'package:flutter_test/flutter_test.dart';

MenuOcrLine row(
  String text,
  double y, {
  double x = 10,
  double width = 160,
  double height = 10,
}) => MenuOcrLine(text, Rect.fromLTWH(x, y, width, height));

void main() {
  test('Tapas no es un platillo y las listas de ingredientes se agrupan', () {
    final rows = [
      row('TAPAS', 0, height: 17),
      row('PINCHO MORUNO', 25, height: 14),
      row('Ingrediente 1, ingrediente 2,', 42, height: 8),
      row('ingrediente 3', 52, height: 8),
      row('CROQUETAS CASERAS', 70, height: 14),
      row('Ingrediente 1, ingrediente 2,', 87, height: 8),
      row('ingrediente 3', 97, height: 8),
      row('PLATILLO SIN PRECIO', 115, height: 14),
      row('6,50 €', 72, x: 225, width: 45),
    ];
    final items = reconstructMenu(rows.reversed.toList());
    expect(items.map((item) => item.name), [
      'PINCHO MORUNO',
      'CROQUETAS CASERAS',
      'PLATILLO SIN PRECIO',
    ]);
    expect(items.every((item) => item.section == 'TAPAS'), isTrue);
    expect(
      items.first.description,
      'Ingrediente 1, ingrediente 2, ingrediente 3',
    );
    expect(items[1].description, 'Ingrediente 1, ingrediente 2, ingrediente 3');
    expect(items[1].priceLabel, '€6,50');
    expect(items.last.price, isNull);
  });
  test('descripciones reales se mantienen en su propia columna y aportan evidencia', () async {
    final items = reconstructMenu([
      row('TAPAS', 0),
      row('Especial del día', 25, height: 14),
      row('Ingredientes: queso, tomate, nuez', 42, height: 8),
      row('POSTRES', 0, x: 300),
      row('Pastel de chocolate', 25, x: 300, height: 14),
      row('Con harina y huevo', 42, x: 300, height: 8),
    ]);
    expect(items.length, 2);
    expect(items.first.description, contains('nuez'));
    expect(items.last.description, contains('huevo'));
    final result = await FoodRepository().analyze(
      items.first,
      {'nuez', 'leche'},
      demo: false,
      useOnline: false,
    );
    expect(result.status, AllergyStatus.risk);
    expect(result.reason, contains('nuez'));
  });
  test('una línea de ingredientes huérfana no genera un producto', () {
    expect(
      reconstructMenu([
        row('Ingredientes: nuez, queso', 0),
        row('TAPAS', 20),
        row('PINCHO MORUNO', 40),
      ]).map((item) => item.name),
      ['PINCHO MORUNO'],
    );
  });
}
