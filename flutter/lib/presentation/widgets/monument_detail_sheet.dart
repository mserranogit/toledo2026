import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/theme/toledo_colors.dart';
import '../../core/utils/map_launcher.dart';
import '../../data/models/itinerary_item_model.dart';
import '../providers/audio_player_provider.dart';
import 'toledo_badge.dart';
import 'full_player_sheet.dart';

class MonumentDetailSheet extends ConsumerStatefulWidget {
  final ItineraryItemModel item;

  const MonumentDetailSheet({super.key, required this.item});

  static void show(BuildContext context, ItineraryItemModel item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => MonumentDetailSheet(item: item),
    );
  }

  @override
  ConsumerState<MonumentDetailSheet> createState() => _MonumentDetailSheetState();
}

class _MonumentDetailSheetState extends ConsumerState<MonumentDetailSheet> {
  int _tabIndex = 0;

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    final audioListAsync = ref.watch(audioguidesListProvider);

    return Container(
      height: MediaQuery.of(context).size.height * 0.88,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Agarre
          Container(
            margin: const EdgeInsets.only(top: 12, bottom: 8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.access_time_rounded, size: 15, color: ToledoColors.accentDark),
                    const SizedBox(width: 5),
                    Text(
                      item.timeSlot,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: ToledoColors.accentDark,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: ToledoColors.textMuted),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),

          const Divider(height: 1, color: ToledoColors.border),

          // Contenido según la pestaña (0: Lista de Sitios, 1: Vista de Mapa)
          Expanded(
            child: _tabIndex == 0
                ? SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Badges
                        Wrap(
                          spacing: 8,
                          runSpacing: 6,
                          children: [
                            ToledoBadge.fromType(item.badgeType, item.badgeText),
                            ToledoBadge(
                              text: item.cost,
                              variant: item.isFree ? BadgeVariant.free : BadgeVariant.price,
                              icon: Icons.monetization_on_outlined,
                            ),
                            ToledoBadge(
                              text: item.distance,
                              variant: BadgeVariant.neutral,
                              icon: Icons.place_outlined,
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),

                        // Título
                        Text(
                          item.title,
                          style: GoogleFonts.cinzel(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: ToledoColors.primaryDark,
                            height: 1.25,
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Descripción principal
                        Text(
                          item.shortDescription,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 14,
                            color: ToledoColors.textMain,
                            height: 1.55,
                          ),
                        ),
                        const SizedBox(height: 18),

                        // Sub-sitios (cuando una tarjeta agrupa varios sitios)
                        if (item.subSites.isNotEmpty) ...[
                          Text(
                            'SITIOS A VISITAR (${item.subSites.length})',
                            style: GoogleFonts.cinzel(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: ToledoColors.primary,
                              letterSpacing: 1.0,
                            ),
                          ),
                          const SizedBox(height: 12),
                          ...item.subSites.map((subSite) => _SubSiteCard(
                                subSite: subSite,
                              )),
                          const SizedBox(height: 16),
                        ] else if (item.audioId != null) ...[
                          audioListAsync.when(
                            data: (tracks) {
                              final track = tracks.firstWhere(
                                (t) => t.id == item.audioId,
                                orElse: () => tracks.first,
                              );
                              return Container(
                                width: double.infinity,
                                margin: const EdgeInsets.only(bottom: 20),
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [ToledoColors.primary, ToledoColors.primaryDark],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: ToledoColors.primary.withOpacity(0.3),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 44,
                                      height: 44,
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.15),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(Icons.headphones, color: Colors.white, size: 24),
                                    ),
                                    const SizedBox(width: 14),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'AUDIOGUÍA INCLUIDA',
                                            style: GoogleFonts.cinzel(
                                              fontSize: 11,
                                              fontWeight: FontWeight.w700,
                                              color: ToledoColors.accent,
                                              letterSpacing: 1.0,
                                            ),
                                          ),
                                          Text(
                                            'Duración: ${track.durationFormatted}',
                                            style: const TextStyle(fontSize: 12, color: Colors.white70),
                                          ),
                                        ],
                                      ),
                                    ),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: ToledoColors.accent,
                                        foregroundColor: Colors.white,
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                      ),
                                      onPressed: () {
                                        ref.read(audioPlayerProvider.notifier).playTrack(track);
                                        Navigator.pop(context);
                                        FullPlayerSheet.show(context);
                                      },
                                      child: const Row(
                                        children: [
                                          Icon(Icons.play_arrow, size: 18),
                                          SizedBox(width: 4),
                                          Text('Escuchar', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                            loading: () => const SizedBox.shrink(),
                            error: (_, stack) => const SizedBox.shrink(),
                          ),
                        ],

                        // Tarjeta Punto de Inicio (especial para Toledo Subterráneo)
                        if (item.id == 'item-d1-7') ...[
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            margin: const EdgeInsets.only(bottom: 20),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFDFBF7),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: ToledoColors.accent.withOpacity(0.55), width: 1.5),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.04),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.place_rounded, color: ToledoColors.primary, size: 20),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        'PUNTO DE INICIO DE LA RUTA',
                                        style: GoogleFonts.cinzel(
                                          fontSize: 12.5,
                                          fontWeight: FontWeight.w700,
                                          color: ToledoColors.primaryDark,
                                          letterSpacing: 0.8,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Calle Sixto Ramón Parro, número 9 (detrás de la Catedral)',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: ToledoColors.textMain,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  'Toledo Subterráneo inicia su recorrido detrás de la Catedral de Toledo, en la Calle Sixto Ramón Parro, número 9, donde podrás visitar un hermoso patio toledano. Es conveniente pasar por nuestra oficina a recoger la entrada al menos 15 minutos antes del comienzo de la ruta.',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 12.5,
                                    color: ToledoColors.textMain,
                                    height: 1.45,
                                  ),
                                ),
                                const SizedBox(height: 14),
                                Row(
                                  children: [
                                    Expanded(
                                      child: ElevatedButton.icon(
                                        onPressed: () => MapLauncher.openOsmRoute(
                                          destLat: item.lat,
                                          destLng: item.lng,
                                          title: 'Inicio: Toledo Subterráneo',
                                        ),
                                        icon: const Icon(Icons.map_rounded, size: 16),
                                        label: const Text(
                                          'Ver mapa',
                                          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: ToledoColors.primary,
                                          foregroundColor: Colors.white,
                                          elevation: 0,
                                          padding: const EdgeInsets.symmetric(vertical: 10),
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    OutlinedButton.icon(
                                      onPressed: () => launchUrl(
                                        Uri.parse('https://www.rutasdetoledo.es/tours/toledo-subterraneo/'),
                                        mode: LaunchMode.externalApplication,
                                      ),
                                      icon: const Icon(Icons.language_rounded, size: 16),
                                      label: const Text(
                                        'Web ↗',
                                        style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
                                      ),
                                      style: OutlinedButton.styleFrom(
                                        foregroundColor: ToledoColors.primary,
                                        side: const BorderSide(color: ToledoColors.primary),
                                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],

                        // Puntos Clave
                        if (item.highlights.isNotEmpty) ...[
                          Text(
                            'PUNTOS DESTACADOS',
                            style: GoogleFonts.cinzel(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: ToledoColors.primary,
                              letterSpacing: 1.0,
                            ),
                          ),
                          const SizedBox(height: 10),
                          ...item.highlights.map((h) => Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.only(top: 2, right: 8),
                                      child: Icon(Icons.star, size: 14, color: ToledoColors.accentDark),
                                    ),
                                    Expanded(
                                      child: Text(
                                        h,
                                        style: GoogleFonts.plusJakartaSans(
                                          fontSize: 13,
                                          color: ToledoColors.textMain,
                                          height: 1.4,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                          const SizedBox(height: 16),
                        ],

                        // Consejos / Tips
                        if (item.tips.isNotEmpty) ...[
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFEF9C3),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: const Color(0xFFFDE047)),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(Icons.lightbulb_outline, color: Color(0xFF854D0E), size: 18),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'CONSEJO PRÁCTICO',
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w800,
                                          color: Color(0xFF854D0E),
                                          letterSpacing: 0.8,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        item.tips,
                                        style: const TextStyle(
                                          fontSize: 12.5,
                                          color: Color(0xFF713F12),
                                          height: 1.4,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],

                        // Botón de Abrir Mapa / GPS
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            icon: const Icon(Icons.navigation_outlined, size: 18),
                            label: const Text('Cómo llegar con OpenStreetMap (GPS)'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: ToledoColors.primary,
                              side: const BorderSide(color: ToledoColors.primary, width: 1.5),
                              padding: const EdgeInsets.symmetric(vertical: 13),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                            ),
                            onPressed: () => MapLauncher.openOsmRoute(
                              destLat: item.lat,
                              destLng: item.lng,
                              title: item.title,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : _SubSitesMapView(item: item),
          ),

          // Bottom Navigation Bar : "Lista de Sitios", "Vista de Mapa"
          Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: ToledoColors.border, width: 1)),
            ),
            child: BottomNavigationBar(
              currentIndex: _tabIndex,
              onTap: (index) => setState(() => _tabIndex = index),
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
                  label: 'Lista de Sitios',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.map_outlined),
                  activeIcon: Icon(Icons.map_rounded),
                  label: 'Vista de Mapa',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SubSiteCard extends ConsumerWidget {
  final ItinerarySubSiteModel subSite;

  const _SubSiteCard({
    required this.subSite,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playerState = ref.watch(audioPlayerProvider);
    final audioListAsync = ref.watch(audioguidesListProvider);

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header con horario y precio
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (subSite.timeSlot != null)
                Row(
                  children: [
                    const Icon(Icons.access_time_rounded, size: 13, color: ToledoColors.accentDark),
                    const SizedBox(width: 5),
                    Text(
                      subSite.timeSlot!,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700,
                        color: ToledoColors.accentDark,
                      ),
                    ),
                  ],
                )
              else
                const SizedBox.shrink(),
              if (subSite.price != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: ToledoColors.badgePriceBg,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: ToledoColors.badgePriceBorder),
                  ),
                  child: Text(
                    subSite.price!,
                    style: const TextStyle(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w700,
                      color: ToledoColors.badgePriceText,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),

          // Título del sitio
          Text(
            subSite.title,
            style: GoogleFonts.cinzel(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: ToledoColors.primaryDark,
              height: 1.25,
            ),
          ),
          const SizedBox(height: 8),

          // Pequeña descripción como en la versión HTML
          Text(
            subSite.description,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              color: ToledoColors.textMain,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 14),

          // Barra inferior con botón de audioguía individualizada y GPS
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (subSite.audioId != null)
                audioListAsync.when(
                  data: (tracks) {
                    final matching = tracks.where((t) => t.id == subSite.audioId);
                    if (matching.isEmpty) return const SizedBox.shrink();
                    final track = matching.first;
                    final isThisPlaying = playerState.isPlaying && playerState.currentTrack?.id == track.id;

                    return InkWell(
                      onTap: () {
                        ref.read(audioPlayerProvider.notifier).playTrack(track);
                      },
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                        decoration: BoxDecoration(
                          color: isThisPlaying ? ToledoColors.primary : ToledoColors.primaryLight,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: ToledoColors.primary.withOpacity(0.3)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              isThisPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                              size: 16,
                              color: isThisPlaying ? Colors.white : ToledoColors.primary,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              isThisPlaying ? 'Pausar' : 'Escuchar (${track.durationFormatted})',
                              style: TextStyle(
                                fontSize: 11.5,
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
                )
              else
                const SizedBox.shrink(),

              if (subSite.lat != null && subSite.lng != null)
                InkWell(
                  onTap: () => MapLauncher.openOsmRoute(
                    destLat: subSite.lat!,
                    destLng: subSite.lng!,
                    title: subSite.title,
                  ),
                  borderRadius: BorderRadius.circular(8),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.place_outlined, size: 14, color: ToledoColors.primary),
                        SizedBox(width: 4),
                        Text(
                          'GPS ↗',
                          style: TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w700,
                            color: ToledoColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SubSitesMapView extends ConsumerStatefulWidget {
  final ItineraryItemModel item;

  const _SubSitesMapView({required this.item});

  @override
  ConsumerState<_SubSitesMapView> createState() => _SubSitesMapViewState();
}

class _SubSitesMapViewState extends ConsumerState<_SubSitesMapView> {
  final MapController _mapController = MapController();
  int _selectedIndex = 0;
  LatLng? _userLocation;
  bool _isLocating = false;

  @override
  Widget build(BuildContext context) {
    final subSites = widget.item.subSites;
    final bool hasSubSites = subSites.isNotEmpty;

    final List<LatLng> points = hasSubSites
        ? subSites
            .where((s) => s.lat != null && s.lng != null)
            .map((s) => LatLng(s.lat!, s.lng!))
            .toList()
        : [LatLng(widget.item.lat, widget.item.lng)];

    final LatLng center = points.isNotEmpty ? points.first : const LatLng(39.8571, -4.0238);

    final List<Polyline> polylines = points.length > 1
        ? [
            Polyline(
              points: points,
              strokeWidth: 4.5,
              color: ToledoColors.primary.withOpacity(0.85),
            ),
          ]
        : [];

    final List<Marker> markers = [];

    if (hasSubSites) {
      for (int i = 0; i < subSites.length; i++) {
        final s = subSites[i];
        if (s.lat == null || s.lng == null) continue;
        final isSelected = _selectedIndex == i;

        markers.add(
          Marker(
            point: LatLng(s.lat!, s.lng!),
            width: isSelected ? 46 : 38,
            height: isSelected ? 46 : 38,
            child: GestureDetector(
              onTap: () {
                setState(() => _selectedIndex = i);
                _mapController.move(LatLng(s.lat!, s.lng!), _mapController.camera.zoom);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  color: isSelected ? ToledoColors.accent : ToledoColors.primary,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: isSelected ? 3.0 : 2.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    '${i + 1}',
                    style: TextStyle(
                      color: isSelected ? ToledoColors.primaryDark : Colors.white,
                      fontSize: isSelected ? 15 : 13,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      }
    } else {
      markers.add(
        Marker(
          point: LatLng(widget.item.lat, widget.item.lng),
          width: 44,
          height: 44,
          child: Container(
            decoration: BoxDecoration(
              color: ToledoColors.primary,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2.5),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 6,
                ),
              ],
            ),
            child: const Icon(Icons.location_on_rounded, color: Colors.white, size: 24),
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
                ),
              ),
            ),
          ),
        ),
      );
    }

    final activeSubSite = hasSubSites && _selectedIndex < subSites.length
        ? subSites[_selectedIndex]
        : null;

    return Stack(
      children: [
        FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            initialCenter: center,
            initialZoom: 16.8,
            minZoom: 13.0,
            maxZoom: 18.5,
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'es.toledo2026.toledo_mobile',
            ),
            if (polylines.isNotEmpty) PolylineLayer(polylines: polylines),
            MarkerLayer(markers: markers),
          ],
        ),

        // Botón Mi Ubicación GPS
        Positioned(
          top: 14,
          right: 14,
          child: FloatingActionButton.small(
            heroTag: 'subsite_locate_fab_${widget.item.id}',
            backgroundColor: Colors.white,
            foregroundColor: ToledoColors.primary,
            elevation: 3,
            onPressed: _locateUser,
            child: _isLocating
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2, color: ToledoColors.primary),
                  )
                : const Icon(Icons.my_location, size: 20),
          ),
        ),

        // Tarjeta flotante inferior del sitio seleccionado
        if (activeSubSite != null)
          Positioned(
            left: 14,
            right: 14,
            bottom: 14,
            child: _SubSiteMapCard(
              subSite: activeSubSite,
              index: _selectedIndex,
              total: subSites.length,
            ),
          )
        else
          Positioned(
            left: 14,
            right: 14,
            bottom: 14,
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: ToledoColors.border),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.12),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          widget.item.title,
                          style: GoogleFonts.cinzel(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: ToledoColors.textMain,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 3),
                        Text(
                          widget.item.locationName,
                          style: const TextStyle(fontSize: 11.5, color: ToledoColors.textMuted),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => MapLauncher.openOsmRoute(
                      destLat: widget.item.lat,
                      destLng: widget.item.lng,
                      title: widget.item.title,
                    ),
                    icon: const Icon(Icons.directions, size: 16),
                    label: const Text('Cómo llegar', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ToledoColors.primary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Future<void> _locateUser() async {
    setState(() => _isLocating = true);
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.whileInUse || permission == LocationPermission.always) {
        final pos = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
          timeLimit: const Duration(seconds: 5),
        );
        setState(() {
          _userLocation = LatLng(pos.latitude, pos.longitude);
          _isLocating = false;
        });
        _mapController.move(_userLocation!, 16.8);
      } else {
        setState(() => _isLocating = false);
      }
    } catch (_) {
      setState(() => _isLocating = false);
    }
  }
}

class _SubSiteMapCard extends ConsumerWidget {
  final ItinerarySubSiteModel subSite;
  final int index;
  final int total;

  const _SubSiteMapCard({
    required this.subSite,
    required this.index,
    required this.total,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playerState = ref.watch(audioPlayerProvider);
    final audioListAsync = ref.watch(audioguidesListProvider);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: ToledoColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2.5),
                decoration: BoxDecoration(
                  color: ToledoColors.primaryLight,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Sitio ${index + 1} de $total',
                  style: const TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w700,
                    color: ToledoColors.primary,
                  ),
                ),
              ),
              if (subSite.timeSlot != null)
                Text(
                  subSite.timeSlot!,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: ToledoColors.accentDark,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 6),

          Text(
            subSite.title,
            style: GoogleFonts.cinzel(
              fontSize: 13.5,
              fontWeight: FontWeight.w700,
              color: ToledoColors.primaryDark,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),

          Text(
            subSite.description,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 11.5,
              color: ToledoColors.textMuted,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 10),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (subSite.audioId != null)
                audioListAsync.when(
                  data: (tracks) {
                    final matching = tracks.where((t) => t.id == subSite.audioId);
                    if (matching.isEmpty) return const SizedBox.shrink();
                    final track = matching.first;
                    final isPlaying = playerState.isPlaying && playerState.currentTrack?.id == track.id;

                    return InkWell(
                      onTap: () => ref.read(audioPlayerProvider.notifier).playTrack(track),
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: isPlaying ? ToledoColors.primary : ToledoColors.primaryLight,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: ToledoColors.primary.withOpacity(0.3)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                              size: 15,
                              color: isPlaying ? Colors.white : ToledoColors.primary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              isPlaying ? 'Pausar' : 'Escuchar (${track.durationFormatted})',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: isPlaying ? Colors.white : ToledoColors.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  loading: () => const SizedBox.shrink(),
                  error: (_, stack) => const SizedBox.shrink(),
                )
              else
                const SizedBox.shrink(),

              if (subSite.lat != null && subSite.lng != null)
                ElevatedButton.icon(
                  onPressed: () => MapLauncher.openOsmRoute(
                    destLat: subSite.lat!,
                    destLng: subSite.lng!,
                    title: subSite.title,
                  ),
                  icon: const Icon(Icons.navigation_outlined, size: 14),
                  label: const Text('Ruta GPS', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ToledoColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
