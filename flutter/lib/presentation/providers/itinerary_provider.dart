import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/local_data_source.dart';
import '../../data/models/itinerary_item_model.dart';

final localDataSourceProvider = Provider<LocalDataSource>((ref) {
  return LocalDataSource();
});

final itineraryDaysProvider = FutureProvider<List<ItineraryDayModel>>((ref) async {
  final dataSource = ref.watch(localDataSourceProvider);
  return dataSource.getItineraryDays();
});

// Selector de día actual (1: Día 1, 2: Día 2, 0: Alojamiento & ZBE)
final selectedDayIndexProvider = StateProvider<int>((ref) => 1);
