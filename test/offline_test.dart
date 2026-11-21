import 'package:hackathon_2026_bitesano/models/menu.dart';
import 'package:hackathon_2026_bitesano/data/food_catalog.dart';
import 'package:hackathon_2026_bitesano/repositories/local_food_repository.dart';
import 'package:hackathon_2026_bitesano/services/allergy_service.dart';
import 'package:hackathon_2026_bitesano/utils/food_text.dart';
import 'package:flutter_test/flutter_test.dart';

const terms = {
  'leche': ['leche', 'yogurt', 'yogur'],
  'nuez': ['nuez', 'nueces', 'almendra'],
};

void main() {
  test('demostración local separa correctamente los diez productos', () {
    final results = <MenuItem, AllergyResult>{};
    for (final item in demoMenu) {
      final reference = localFood(item.name);
      results[item] = reference == null
          ? const AllergyResult(AllergyStatus.insufficient, 'Desconocido')
          : classifyReference(reference, {'leche', 'nuez'}, terms, 'Demo');
    }
    expect(filterMenuItems(demoMenu, results, MenuFilter.all), hasLength(10));
    expect(
      filterMenuItems(demoMenu, results, MenuFilter.noMatch),
      hasLength(5),
    );
    expect(filterMenuItems(demoMenu, results, MenuFilter.risk), hasLength(4));
    expect(
      filterMenuItems(demoMenu, results, MenuFilter.insufficient),
      hasLength(1),
    );
  });

  test('normalización reconoce una bebida y conserva lo desconocido', () {
    expect(localFood('PEPINO MENTA (MINERAL)'), isNotNull);
    expect(localFood('Bebida especial desconocida'), isNull);
    expect(foodContains('Smoothie con yogurt', 'yogurt'), isTrue);
    expect(foodContains('Smoothie con yogurt', 'yogur'), isFalse);
  });

  test('las referencias se reevaluan al cambiar las alergias', () {
    final latte = localFood('Latte')!;
    expect(
      classifyReference(latte, {'leche'}, terms, 'Local').status,
      AllergyStatus.risk,
    );
    expect(
      classifyReference(latte, {'nuez'}, terms, 'Local').status,
      AllergyStatus.noMatch,
    );
  });
}
