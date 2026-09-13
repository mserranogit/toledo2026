import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/theme/toledo_colors.dart';
import '../../../data/models/map_point_model.dart';
import '../../providers/map_provider.dart';

class OsmMapScreen extends ConsumerStatefulWidget {
  const OsmMapScreen({super.key});

  @override
  ConsumerState<OsmMapScreen> createState() => _OsmMapScreenState();
}

class _OsmMapScreenState extends ConsumerState<OsmMapScreen> {
  final MapController _mapController = MapController();
  dynamic _selectedPoint; // Landmark or RoutePoint seleccionado

  static const LatLng _toledoCenter = LatLng(39.8571, -4.0238);
  static const LatLng _valleCenter = LatLng(39.8524, -4.0185);

  void _centerOn(LatLng point, double zoom) {
    _mapController.move(point, zoom);
  }

  Future<void> _openExternalGps(double lat, double lng) async {
    final uri = Uri.parse('https://www.google.com/maps/search/?api=1&query=$lat,$lng');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'local_parking':
        return Icons.local_parking_rounded;
      case 'escalator':
        return Icons.stairs_rounded;
      case 'hotel':
        return Icons.hotel_rounded;
      case 'church':
        return Icons.church_rounded;
      case 'museum':
        return Icons.museum_rounded;
      case 'castle':
        return Icons.castle_rounded;
      case 'explore':
        return Icons.explore_rounded;
      case 'account_balance':
        return Icons.account_balance_rounded;
      default:
        return Icons.place_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final mapDataAsync = ref.watch(mapPointsDataProvider);
    final selectedRouteIndex = ref.watch(selectedMapRouteIndexProvider);

    return Scaffold(
      backgroundColor: ToledoColors.bgBody,
      body: mapDataAsync.when(
        data: (mapData) {
          // Rutas y marcadores
          final List<Polyline> polylines = [];
          final List<Marker> markers = [];

          // Procesar rutas
          for (int i = 0; i < mapData.routes.length; i++) {
            final route = mapData.routes[i];
            final isCurrent = (selectedRouteIndex == i || selectedRouteIndex == -1);

            if (isCurrent) {
              final points = route.points.map((p) => LatLng(p.lat, p.lng)).toList();
              final routeColor = route.color == '#852221'
                  ? ToledoColors.primary
                  : (route.color == '#C28833' ? ToledoColors.accent : Colors.blue);

              polylines.add(
                Polyline(
                  points: points,
                  strokeWidth: 4.5,
                  color: routeColor.withOpacity(0.85),
                ),
              );

              // Marcadores de paradas de la ruta
              for (int pIdx = 0; pIdx < route.points.length; pIdx++) {
                final pt = route.points[pIdx];
                markers.add(
                  Marker(
                    point: LatLng(pt.lat, pt.lng),
                    width: 32,
                    height: 32,
                    child: GestureDetector(
                      onTap: () {
                        setState(() => _selectedPoint = pt);
                        _centerOn(LatLng(pt.lat, pt.lng), 16.0);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: routeColor,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.25),
                              blurRadius: 4,
                            )
                          ],
                        ),
                        child: Center(
                          child: Text(
                            '${pIdx + 1}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }
            }
          }

          // Procesar monumentos y puntos de interés generales
          for (final l in mapData.landmarks) {
            final isHotelOrParking = l.category == 'Parking' || l.category == 'Alojamiento';
            final markerColor = l.category == 'Parking'
                ? Colors.blue.shade700
                : (l.category == 'Alojamiento' ? ToledoColors.accentDark : ToledoColors.primaryDark);

            markers.add(
              Marker(
                point: LatLng(l.lat, l.lng),
                width: 36,
                height: 36,
                child: GestureDetector(
                  onTap: () {
                    setState(() => _selectedPoint = l);
                    _centerOn(LatLng(l.lat, l.lng), 16.2);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: markerColor,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.28),
                          blurRadius: 5,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Icon(
                        _getIconData(l.icon),
                        size: isHotelOrParking ? 18 : 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }

          return Stack(
            children: [
              // Visor OpenStreetMap Nativo
              FlutterMap(
                mapController: _mapController,
                options: const MapOptions(
                  initialCenter: _toledoCenter,
                  initialZoom: 14.5,
                  minZoom: 11.0,
                  maxZoom: 18.0,
                ),
                children: [
                  TileLayer(
                    urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'es.toledo2026.guia',
                    tileProvider: NetworkTileProvider(),
                  ),
                  PolylineLayer(polylines: polylines),
                  MarkerLayer(markers: markers),
                ],
              ),

              // Barra Superior con Selector de Rutas
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            _RouteFilterChip(
                              label: 'Sendero Valle (1,3 km)',
                              icon: Icons.terrain_rounded,
                              isSelected: selectedRouteIndex == 0,
                              onTap: () {
                                ref.read(selectedMapRouteIndexProvider.notifier).state = 0;
                                _centerOn(_valleCenter, 15.5);
                              },
                            ),
                            const SizedBox(width: 8),
                            _RouteFilterChip(
                              label: 'Judería Mayor (850 m)',
                              icon: Icons.directions_walk_rounded,
                              isSelected: selectedRouteIndex == 1,
                              onTap: () {
                                ref.read(selectedMapRouteIndexProvider.notifier).state = 1;
                                _centerOn(const LatLng(39.8565, -4.0280), 16.2);
                              },
                            ),
                            const SizedBox(width: 8),
                            _RouteFilterChip(
                              label: 'Todos los Puntos',
                              icon: Icons.map_rounded,
                              isSelected: selectedRouteIndex == -1,
                              onTap: () {
                                ref.read(selectedMapRouteIndexProvider.notifier).state = -1;
                                _centerOn(_toledoCenter, 14.0);
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Botones Flotantes de Navegación Rápida
              Positioned(
                right: 16,
                bottom: _selectedPoint != null ? 140 : 20,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FloatingActionButton.small(
                      heroTag: 'btn_center_toledo',
                      backgroundColor: Colors.white,
                      foregroundColor: ToledoColors.primary,
                      tooltip: 'Centrar en Toledo',
                      onPressed: () => _centerOn(_toledoCenter, 15.0),
                      child: const Icon(Icons.my_location_rounded),
                    ),
                    const SizedBox(height: 8),
                    FloatingActionButton.small(
                      heroTag: 'btn_center_valle',
                      backgroundColor: Colors.white,
                      foregroundColor: ToledoColors.accentDark,
                      tooltip: 'Centrar en Mirador del Valle',
                      onPressed: () => _centerOn(_valleCenter, 15.5),
                      child: const Icon(Icons.landscape_rounded),
                    ),
                  ],
                ),
              ),

              // Tarjeta Flotante Inferior de Punto Seleccionado
              if (_selectedPoint != null)
                Positioned(
                  left: 14,
                  right: 14,
                  bottom: 16,
                  child: _SelectedPointCard(
                    point: _selectedPoint,
                    onClose: () => setState(() => _selectedPoint = null),
                    onOpenGps: () => _openExternalGps(_selectedPoint.lat, _selectedPoint.lng),
                  ),
                ),
            ],
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(color: ToledoColors.primary),
        ),
        error: (err, _) => Center(
          child: Text('Error cargando el mapa de OpenStreetMap: $err'),
        ),
      ),
    );
  }
}

class _RouteFilterChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _RouteFilterChip({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: isSelected ? ToledoColors.primary : Colors.white.withOpacity(0.95),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? ToledoColors.primary : ToledoColors.border,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.12),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 15,
              color: isSelected ? Colors.white : ToledoColors.primary,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: isSelected ? Colors.white : ToledoColors.textMain,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SelectedPointCard extends StatelessWidget {
  final dynamic point;
  final VoidCallback onClose;
  final VoidCallback onOpenGps;

  const _SelectedPointCard({
    required this.point,
    required this.onClose,
    required this.onOpenGps,
  });

  @override
  Widget build(BuildContext context) {
    final String title = point.title ?? 'Punto de Interés';
    final String category = (point is MapLandmarkModel)
        ? (point as MapLandmarkModel).category
        : 'Parada de Ruta';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: ToledoColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.18),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: ToledoColors.accent.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  category.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: ToledoColors.accentDark,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, size: 18),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: onClose,
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            title,
            style: GoogleFonts.cinzel(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: ToledoColors.primaryDark,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.navigation_outlined, size: 16),
              label: const Text('Navegar con Google Maps'),
              style: ElevatedButton.styleFrom(
                backgroundColor: ToledoColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(vertical: 10),
              ),
              onPressed: onOpenGps,
            ),
          ),
        ],
      ),
    );
  }
}
