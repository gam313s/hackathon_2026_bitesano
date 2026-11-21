class MenuItem {
  final String name;
  final String? price;
  final String? description;
  final String? section;
  final String currency;
  String get priceLabel => price == null ? 'Sin precio' : '$currency$price';

  const MenuItem(
    this.name,
    this.price, {
    this.description,
    this.section,
    this.currency = '\$',
  });
}

enum AllergyStatus { noMatch, risk, insufficient, pending }

enum MenuFilter { all, noMatch, risk, insufficient }

class AllergyResult {
  final AllergyStatus status;
  final String reason;
  const AllergyResult(this.status, this.reason);
}

class FoodReference {
  final String name;
  final List<String> ingredients;
  const FoodReference(this.name, this.ingredients);
}

List<MenuItem> filterMenuItems(
  List<MenuItem> items,
  Map<MenuItem, AllergyResult> results,
  MenuFilter filter,
) {
  if (filter == MenuFilter.all) return List.of(items);
  final status = switch (filter) {
    MenuFilter.noMatch => AllergyStatus.noMatch,
    MenuFilter.risk => AllergyStatus.risk,
    MenuFilter.insufficient => AllergyStatus.insufficient,
    MenuFilter.all => AllergyStatus.pending,
  };
  return items.where((item) => results[item]?.status == status).toList();
}
