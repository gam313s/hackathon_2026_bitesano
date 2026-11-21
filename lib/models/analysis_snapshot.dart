import 'menu.dart';

class AnalysisSnapshot {
  final String title;
  final DateTime time;
  final List<MenuItem> items;
  final Map<MenuItem, AllergyResult> results;
  final Set<String> allergies;
  final bool demo;
  AnalysisSnapshot({
    required this.title,
    required this.time,
    required List<MenuItem> items,
    required Map<MenuItem, AllergyResult> results,
    required Set<String> allergies,
    required this.demo,
  }) : items = List.unmodifiable(items),
       results = Map.unmodifiable(results),
       allergies = Set.unmodifiable(allergies);
}
