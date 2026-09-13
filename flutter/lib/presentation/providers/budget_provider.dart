import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/models/budget_item_model.dart';
import 'itinerary_provider.dart';

final budgetDataProvider = FutureProvider<BudgetDataModel>((ref) async {
  final dataSource = ref.watch(localDataSourceProvider);
  return dataSource.getBudgetData();
});

class PaidItemsNotifier extends StateNotifier<Set<String>> {
  static const _prefKey = 'toledo_paid_items';

  PaidItemsNotifier() : super({}) {
    _loadFromPrefs();
  }

  Future<void> _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_prefKey);
    if (list != null) {
      state = list.toSet();
    }
  }

  Future<void> toggleItem(String itemId) async {
    final newState = Set<String>.from(state);
    if (newState.contains(itemId)) {
      newState.remove(itemId);
    } else {
      newState.add(itemId);
    }
    state = newState;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_prefKey, newState.toList());
  }

  bool isPaid(String itemId) => state.contains(itemId);
}

final paidItemsProvider = StateNotifierProvider<PaidItemsNotifier, Set<String>>((ref) {
  return PaidItemsNotifier();
});
