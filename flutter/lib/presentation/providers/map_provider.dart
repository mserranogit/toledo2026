import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/map_point_model.dart';
import 'itinerary_provider.dart';

final mapPointsDataProvider = FutureProvider<MapPointsDataModel>((ref) async {
  final dataSource = ref.watch(localDataSourceProvider);
  return dataSource.getMapPointsData();
});

// Ruta seleccionada actualmente (0: Sendero del Valle, 1: Judería Mayor, -1: Todos los puntos)
final selectedMapRouteIndexProvider = StateProvider<int>((ref) => 0);
