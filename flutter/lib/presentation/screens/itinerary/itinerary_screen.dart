import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong.dart';
import '../../../core/theme/toledo_colors.dart';
import '../../../core/utils/map_launcher.dart';
import '../../../data/models/itinerary_item_model.dart';
import '../../providers/itinerary_provider.dart';
import '../../providers/audio_player_provider.dart';
import '../../widgets/toledo_badge.dart';
import '../../widgets/monument_detail_sheet.dart';

// Provider para la vista del día (0: Lista de Tarjetas, 1: Vista de Mapa)
final dayViewModeProvider = StateProvider<int>((ref) => 0);

class ItineraryScreen extends ConsumerWidget {
  const ItineraryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itineraryAsync = ref.watch(itineraryDaysProvider);
    final selectedDay = ref.watch(selectedDayIndexProvider);
    final viewMode = ref.watch(dayViewModeProvider);

    return Scaffold(
      backgroundColor: ToledoColors.bgBody,
      body: itineraryAsync.when(
        data: (days) {
          final currentDay = days.firstWhere(
            (d) => d.dayNumber == selectedDay,
            orElse: () => days.first,
          );

          return Column(
            children: [
              // Header de Selección de Día
              Container(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
                decoration: const BoxDecoration(
                  color: ToledoColors.darkSlate,
                  borderRadius: BorderRadius.vertical(bottom: Radius.circular(22)),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: ToledoColors.accent.withOpacity(0.18),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: ToledoColors.accent.withOpacity(0.4)),
                            ),
                            child: Text(
                              'GUÍA EXPERTA · 21 Y 22 OCTUBRE 2026',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 9.5,
                                fontWeight: FontWeight.w800,
                                color: ToledoColors.accent,
                                letterSpacing: 0.8,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          currentDay.dateFormatted,
                          style: GoogleFonts.cinzel(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w700,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Selector Segmentado de Días
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: _DayTabButton(
                              title: 'Día 1 · Miér 21',
                              subtitle: 'Consorcio & Judería',
                              isSelected: selectedDay == 1,
                              onTap: () => ref.read(selectedDayIndexProvider.notifier).state = 1,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: _DayTabButton(
                              title: 'Día 2 · Juev 22',
                              subtitle: 'Catedral & Orgaz',
                              isSelected: selectedDay == 2,
                              onTap: () => ref.read(selectedDayIndexProvider.notifier).state = 2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Contenido según el modo de vista (0: Tarjetas, 1: Mapa del Día)
              Expanded(
                child: viewMode == 0
                    ? _CardListView(currentDay: currentDay)
                    : _DayMapView(currentDay: currentDay),
              ),
            ],
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(color: ToledoColors.primary),
        ),
        error: (err, _) => Center(
          child: Text('Error cargando el itinerario: $err'),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: ToledoColors.border, width: 1)),
        ),
        child: BottomNavigationBar(
          currentIndex: viewMode,
          onTap: (index) => ref.read(dayViewModeProvider.notifier).state = index,
          backgroundColor: Colors.white,
          selectedItemColor: ToledoColors.primary,
          unselectedItemColor: ToledoColors.textMuted,
          selectedLabelStyle: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            fontWeight: FontWeight.w800,
          ),
          unselectedLabelStyle: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.style_outlined),
              activeIcon: Icon(Icons.style_rounded),
              label: 'Lista de Tarjetas',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.map_outlined),
              activeIcon: Icon(Icons.map_rounded),
              label: 'Vista de Mapa',
            ),
          ],
        ),
      ),
    );
  }
}

class _DayTabButton extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool isSelected;
  final VoidCallback onTap;

  const _DayTabButton({
    required this.title,
    required this.subtitle,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        decoration: BoxDecoration(
          color: isSelected ? ToledoColors.accent : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: ToledoColors.accent.withOpacity(0.35),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  )
                ]
              : [],
        ),
        child: Column(
          children: [
            Text(
              title,
              style: GoogleFonts.cinzel(
                fontSize: 12.5,
                fontWeight: FontWeight.w700,
                color: isSelected ? Colors.white : Colors.white70,
              ),
            ),
            const SizedBox(height: 1),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 10,
                color: isSelected ? Colors.white.withOpacity(0.9) : Colors.white54,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CardListView extends StatelessWidget {
  final ItineraryDayModel currentDay;

  const _CardListView({required this.currentDay});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
      children: [
        // Título y resumen del día seleccionado
        Padding(
          padding: const EdgeInsets.only(bottom: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                currentDay.title,
                style: GoogleFonts.cinzel(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: ToledoColors.primaryDark,
                  letterSpacing: 0.6,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                currentDay.summary,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12.5,
                  color: ToledoColors.textMuted,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),

        // Lista de Tarjetas del Día
        ...List.generate(currentDay.items.length, (index) {
          final item = currentDay.items[index];
          final isLast = index == currentDay.items.length - 1;
          return _TimelineCard(item: item, isLast: isLast);
        }),
      ],
    );
  }
}

class _DayMapView extends StatefulWidget {
  final ItineraryDayModel currentDay;

  const _DayMapView({required this.currentDay});

  @override
  State<_DayMapView> createState() => _DayMapViewState();
}

class _DayMapViewState extends State<_DayMapView> {
  final MapController _mapController = MapController();
  LatLng? _userLocation;
  bool _isLocating = false;

  @override
  Widget build(BuildContext context) {
    final points = widget.currentDay.items.map((i) => LatLng(i.lat, i.lng)).toList();
    final LatLng center = points.isNotEmpty ? points.first : const LatLng(39.8571, -4.0238);

    final List<Polyline> polylines = [
      Polyline(
        points: points,
        strokeWidth: 4.5,
        color: ToledoColors.primary.withOpacity(0.85),
      ),
    ];

    final List<Marker> markers = [];

    for (int i = 0; i < widget.currentDay.items.length; i++) {
      final item = widget.currentDay.items[i];
      markers.add(
        Marker(
          point: LatLng(item.lat, item.lng),
          width: 38,
          height: 38,
          child: GestureDetector(
            onTap: () => MonumentDetailSheet.show(context, item),
            child: Container(
              decoration: BoxDecoration(
                color: ToledoColors.primary,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2.2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.28),
                    blurRadius: 5,
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  '${i + 1}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }

    if (_userLocation != null) {
      markers.add(
        Marker(
          point: _userLocation!,
          width: 38,
          height: 38,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.25),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Container(
                width: 18,
                height: 18,
                decoration: BoxDecoration(
                  color: Colors.blue.shade600,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2.5),
                  boxShadow: const [
                    BoxShadow(color: Colors.black26, blurRadius: 4),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }

    return Stack(
      children: [
        FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            initialCenter: center,
            initialZoom: 15.2,
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

        // Cartel flotante indicando el itinerario del día
        Positioned(
          top: 12,
          left: 14,
          right: 14,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.95),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: ToledoColors.border),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.12),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                const Icon(Icons.place_rounded, color: ToledoColors.primary, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '${widget.currentDay.items.length} Paradas · Toca cualquier número para ver detalles',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w700,
                      color: ToledoColors.primaryDark,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // Botón GPS
        Positioned(
          right: 16,
          bottom: 20,
          child: FloatingActionButton.small(
            heroTag: 'btn_day_map_gps',
            backgroundColor: Colors.white,
            foregroundColor: Colors.blue.shade700,
            tooltip: 'Mi Ubicación GPS',
            onPressed: () async {
              setState(() => _isLocating = true);
              final pos = await MapLauncher.getCurrentLocation();
              if (pos != null && mounted) {
                final userLatLng = LatLng(pos.latitude, pos.longitude);
                setState(() {
                  _userLocation = userLatLng;
                  _isLocating = false;
                });
                _mapController.move(userLatLng, 16.5);
              } else if (mounted) {
                setState(() => _isLocating = false);
              }
            },
            child: _isLocating
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.blue),
                  )
                : const Icon(Icons.my_location_rounded),
          ),
        ),
      ],
    );
  }
}

class _TimelineCard extends ConsumerWidget {
  final ItineraryItemModel item;
  final bool isLast;

  const _TimelineCard({required this.item, required this.isLast});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final audioListAsync = ref.watch(audioguidesListProvider);
    final playerState = ref.watch(audioPlayerProvider);

    return Stack(
      children: [
        // Línea vertical continua de la línea de tiempo
        if (!isLast)
          Positioned(
            top: 20,
            bottom: 0,
            left: 7,
            child: Container(
              width: 2,
              color: ToledoColors.primary.withOpacity(0.25),
            ),
          ),

        // Círculo indicador de la línea de tiempo
        Positioned(
          top: 14,
          left: 0,
          child: Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              color: ToledoColors.primary,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 3),
              boxShadow: [
                BoxShadow(
                  color: ToledoColors.primary.withOpacity(0.3),
                  blurRadius: 4,
                  offset: const Offset(0, 1),
                )
              ],
            ),
          ),
        ),

        // Tarjeta de Contenido con margen para el timeline
        Padding(
          padding: const EdgeInsets.only(left: 28, bottom: 16),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: ToledoColors.border),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () => MonumentDetailSheet.show(context, item),
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Franja horaria y Badges
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            item.timeSlot,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: ToledoColors.accentDark,
                            ),
                          ),
                          ToledoBadge.fromType(item.badgeType, item.badgeText),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // Título
                      Text(
                        item.title,
                        style: GoogleFonts.cinzel(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: ToledoColors.textMain,
                          letterSpacing: 0.4,
                          height: 1.25,
                        ),
                      ),
                      const SizedBox(height: 6),

                      // Descripción recortada
                      Text(
                        item.shortDescription,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12.5,
                          color: ToledoColors.textMuted,
                          height: 1.45,
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Barra inferior con botón de audio y precio
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              item.isFree ? 'Entrada Libre' : 'Coste: ${item.cost}',
                              style: TextStyle(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w700,
                                color: item.isFree ? ToledoColors.badgeFreeText : ToledoColors.badgePriceText,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),

                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Si tiene audioguía, botón rápido
                              if (item.audioId != null) ...[
                                audioListAsync.when(
                                  data: (tracks) {
                                    final track = tracks.firstWhere(
                                      (t) => t.id == item.audioId,
                                      orElse: () => tracks.first,
                                    );
                                    final isThisPlaying = playerState.isPlaying && playerState.currentTrack?.id == track.id;

                                    return InkWell(
                                      onTap: () {
                                        ref.read(audioPlayerProvider.notifier).playTrack(track);
                                      },
                                      borderRadius: BorderRadius.circular(16),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4.5),
                                        decoration: BoxDecoration(
                                          color: isThisPlaying ? ToledoColors.primary : ToledoColors.primaryLight,
                                          borderRadius: BorderRadius.circular(16),
                                          border: Border.all(color: ToledoColors.primary.withOpacity(0.3)),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              isThisPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                                              size: 14,
                                              color: isThisPlaying ? Colors.white : ToledoColors.primary,
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              isThisPlaying ? 'Pausar' : 'Escuchar',
                                              style: TextStyle(
                                                fontSize: 11,
                                                fontWeight: FontWeight.w700,
                                                color: isThisPlaying ? Colors.white : ToledoColors.primary,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                  loading: () => const SizedBox.shrink(),
                                  error: (_, stack) => const SizedBox.shrink(),
                                ),
                                const SizedBox(width: 8),
                              ] else ...[
                                InkWell(
                                  onTap: () {
                                    MapLauncher.openOsmRoute(
                                      destLat: item.lat,
                                      destLng: item.lng,
                                      title: item.title,
                                    );
                                  },
                                  borderRadius: BorderRadius.circular(16),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4.5),
                                    decoration: BoxDecoration(
                                      color: ToledoColors.primaryLight,
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(color: ToledoColors.primary.withOpacity(0.3)),
                                    ),
                                    child: const Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.map_outlined,
                                          size: 14,
                                          color: ToledoColors.primary,
                                        ),
                                        SizedBox(width: 4),
                                        Text(
                                          'Ver mapa',
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w700,
                                            color: ToledoColors.primary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                              ],

                              const Text(
                                'Ver detalles →',
                                style: TextStyle(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w600,
                                  color: ToledoColors.primary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
