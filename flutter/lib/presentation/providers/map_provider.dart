import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/map_point_model.dart';
import 'itinerary_provider.dart';

final mapPointsDataProvider = FutureProvider<MapPointsDataModel>((ref) async {
  final dataSource = ref.watch(localDataSourceProvider);
  return dataSource.getMapPointsData();
});

// Ruta seleccionada actualmente (0: Llegada Safont ➔ Centro, 1: Judería Mayor, 2: Restaurantes Baratos, -1: Todos los puntos)
final selectedMapRouteIndexProvider = StateProvider<int>((ref) => 0);

class MapCenterTarget {
  final double lat;
  final double lng;
  final double zoom;
  final String? title;

  const MapCenterTarget({
    required this.lat,
    required this.lng,
    this.zoom = 16.5,
    this.title,
  });
}

final mapCenterTargetProvider = StateProvider<MapCenterTarget?>((ref) => null);
