import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/restaurant_model.dart';
import 'itinerary_provider.dart';

final restaurantsDataProvider = FutureProvider<RestaurantsDataModel>((ref) async {
  final dataSource = ref.watch(localDataSourceProvider);
  return dataSource.getRestaurantsData();
});

// Filtro de restaurante seleccionado para detalle o mapa
final selectedRestaurantFilterProvider = StateProvider<String?>((ref) => null);
