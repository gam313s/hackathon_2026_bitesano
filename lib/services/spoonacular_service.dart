import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/menu.dart';
import '../utils/food_text.dart';
import 'allergy_service.dart';

class SpoonacularService {
  static const apiKey = String.fromEnvironment('SPOONACULAR_API_KEY');
  bool get configured => apiKey.isNotEmpty;
  String? blockedReason;
  double? quotaLeft;
  final Map<String, FoodReference?> _sessionReferences = {};
  void resetConnection() {
    blockedReason = null;
    quotaLeft = null;
  }

  Future<AllergyResult> lookup(
    MenuItem item,
    Set<String> allergies,
    Map<String, List<String>> terms,
  ) async {
    final query = normalizeFood(item.name);
    if (_sessionReferences.containsKey(query)) {
      final cached = _sessionReferences[query];
      return cached == null
          ? const AllergyResult(
              AllergyStatus.insufficient,
              'No se encontró una referencia útil en esta sesión.',
            )
          : classifyReference(
              cached,
              allergies,
              terms,
              'Spoonacular, consulta de esta sesión',
            );
    }
    if (blockedReason != null) {
      return AllergyResult(AllergyStatus.insufficient, blockedReason!);
    }
    if (quotaLeft != null && quotaLeft! < 1.06) {
      blockedReason = 'No hay puntos suficientes en Spoonacular. Se conservan los resultados locales.';
      return AllergyResult(AllergyStatus.insufficient, blockedReason!);
    }

    try {
      // Una sola consulta: búsqueda e información de receta en la misma respuesta.
      final uri = Uri.https('api.spoonacular.com', '/recipes/complexSearch', {
        'query': item.name,
        'number': '1',
        'addRecipeInformation': 'true',
        'fillIngredients': 'true',
      });
      final response = await http
          .get(uri, headers: {'x-api-key': apiKey})
          .timeout(const Duration(seconds: 8));
      final remaining = response.headers['x-api-quota-left'];
      if (remaining != null) quotaLeft = double.tryParse(remaining.trim());

      if (response.statusCode != 200) {
        blockedReason = switch (response.statusCode) {
          402 => 'Cuota de Spoonacular agotada. El análisis local continúa.',
          429 => 'Límite temporal de consultas alcanzado. El análisis local continúa.',
          401 || 403 =>
            'Spoonacular rechazó las credenciales. Revisa la configuración.',
          _ =>
            'Spoonacular no está disponible (HTTP ${response.statusCode}). El análisis local continúa.',
        };
        return AllergyResult(AllergyStatus.insufficient, blockedReason!);
      }

      final decoded = jsonDecode(response.body);
      final recipes = (decoded['results'] as List?) ?? [];
      if (recipes.isEmpty) {
        _sessionReferences[query] = null;
        return const AllergyResult(
          AllergyStatus.insufficient,
          'Spoonacular no encontró una receta de referencia.',
        );
      }
      final recipe = recipes.first as Map<String, dynamic>;
      final ingredients = ((recipe['extendedIngredients'] as List?) ?? [])
          .whereType<Map>()
          .map((i) => (i['original'] ?? i['name'] ?? '').toString().trim())
          .where((i) => i.isNotEmpty)
          .toList();

      if (ingredients.isEmpty) {
        _sessionReferences[query] = null;
        return const AllergyResult(
          AllergyStatus.insufficient,
          'La respuesta no incluye una lista completa de ingredientes.',
        );
      }
      final reference = FoodReference(
        (recipe['title'] ?? 'Receta de referencia').toString(),
        ingredients,
      );
      _sessionReferences[query] = reference;
      return classifyReference(reference, allergies, terms, 'Spoonacular');
    } catch (_) {
      blockedReason = 'No se pudo conectar a Spoonacular. Se conservan las referencias locales y las menciones del menú.';
      return AllergyResult(AllergyStatus.insufficient, blockedReason!);
    }
  }
}
