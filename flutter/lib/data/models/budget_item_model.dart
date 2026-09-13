class BudgetDataModel {
  final String currency;
  final double totalPerPerson;
  final double subtotalActivities;
  final double subtotalAccommodation;
  final List<BudgetItemModel> items;

  BudgetDataModel({
    required this.currency,
    required this.totalPerPerson,
    required this.subtotalActivities,
    required this.subtotalAccommodation,
    required this.items,
  });

  factory BudgetDataModel.fromJson(Map<String, dynamic> json) {
    return BudgetDataModel(
      currency: json['currency'] as String? ?? '€',
      totalPerPerson: (json['totalPerPerson'] as num).toDouble(),
      subtotalActivities: (json['subtotalActivities'] as num).toDouble(),
      subtotalAccommodation: (json['subtotalAccommodation'] as num).toDouble(),
      items: (json['items'] as List<dynamic>)
          .map((e) => BudgetItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class BudgetItemModel {
  final String id;
  final String day;
  final String concept;
  final String category;
  final double priceOfficial;
  final double priceActual;
  final bool isFree;
  final String notes;

  BudgetItemModel({
    required this.id,
    required this.day,
    required this.concept,
    required this.category,
    required this.priceOfficial,
    required this.priceActual,
    required this.isFree,
    required this.notes,
  });

  factory BudgetItemModel.fromJson(Map<String, dynamic> json) {
    return BudgetItemModel(
      id: json['id'] as String,
      day: json['day'] as String,
      concept: json['concept'] as String,
      category: json['category'] as String,
      priceOfficial: (json['priceOfficial'] as num).toDouble(),
      priceActual: (json['priceActual'] as num).toDouble(),
      isFree: json['isFree'] as bool? ?? false,
      notes: json['notes'] as String? ?? '',
    );
  }
}
