import 'dart:ui';

import 'package:hackathon_2026_bitesano/services/menu_ocr_service.dart';
import 'package:flutter_test/flutter_test.dart';

MenuOcrLine line(String s, double x, double y, [double width = 140]) =>
    MenuOcrLine(s, Rect.fromLTWH(x, y, width, 10));

void main() {
  test('reconstruye 11 bebidas con columnas desordenadas', () {
    final names = [
      line('BASE DE AGUA', 10, 0),
      line('FRUTOS ROJOS', 10, 20),
      line('MANGONEADA', 10, 40),
      line('FRESADA', 10, 60),
      line('CHAMOYADA MANGO O FRESA', 10, 80),
      line('PEPINO MENTA', 10, 100),
      line('(MINERAL)', 10, 111),
      line('LIMONADA Y NARANJADA', 10, 132),
      line('(NATURAL/MINERAL)', 10, 143),
      line('SALUDABLES', 10, 164),
      line('JUGO VERDE', 10, 184),
      line('JUGO NARANJA', 10, 204),
      line(r'LIMONADA FRUTOS ROJOS/FRESA $83', 10, 224),
      line('SMOOTHIES', 10, 244),
      line('SMOOTHIES (Con yogurt)', 10, 264),
      line('"MANGO "FRESA "FRUTOS', 10, 275),
      line('ROJOS PLATANO', 10, 286),
      line('SMOOTHIES COMBINADOS', 10, 308),
      line('(con yogurt)', 10, 319),
      line('"FRESA-PLATANO "MANGO', 10, 330),
      line('16oz', 180, 0, 20),
    ];
    final prices = [76, 76, 76, 82, 76, 76, 75, 82, 82, 94];
    final ys = [20, 40, 60, 80, 100, 132, 184, 204, 264, 308];
    final items = reconstructMenu([
      ...List.generate(
        prices.length,
        (i) => line('\$${prices[i]}', 200, ys[i].toDouble() + 1, 25),
      ).reversed,
      ...names.reversed,
    ]);
    expect(items.length, 11);
    expect(items.map((i) => i.price).toList(), [
      '76',
      '76',
      '76',
      '82',
      '76',
      '76',
      '75',
      '82',
      '83',
      '82',
      '94',
    ]);
    expect(items[4].name, 'PEPINO MENTA (MINERAL)');
    expect(items.last.name, contains('(con yogurt)'));
  });
  test('no descarta productos sin precio ni asigna uno dos veces', () {
    final items = reconstructMenu([
      line('Agua', 10, 10),
      line('Té', 10, 35),
      line('Café', 10, 60),
      line(r'$50', 200, 35, 25),
    ]);
    expect(items.map((i) => i.price).toList(), [null, '50', null]);
  });
  test('precio a la izquierda no se asigna a otro producto', () {
    final items = reconstructMenu([
      line('Smoothie', 10, 20),
      line(r'$94', 200, 20, 25),
      line('MOCHA', 250, 20),
    ]);
    expect(items.map((i) => i.price).toList(), ['94', null]);
  });
  test('menu sin importes conserva nombres y rechaza unidades', () {
    final items = reconstructMenu([
      line('BEBIDAS', 10, 0),
      line('Horchata', 10, 20),
      line('Jamaica', 10, 40),
      line('16oz', 200, 0, 25),
    ]);
    expect(items.map((i) => i.name).toList(), ['Horchata', 'Jamaica']);
    expect(items.every((i) => i.price == null), true);
  });
}
