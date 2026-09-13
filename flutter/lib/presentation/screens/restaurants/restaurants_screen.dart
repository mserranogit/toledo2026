import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/toledo_colors.dart';
import '../../../core/utils/map_launcher.dart';
import '../../../data/models/restaurant_model.dart';
import '../../providers/restaurants_provider.dart';
import '../../providers/map_provider.dart';
import '../main_shell.dart';

class RestaurantsScreen extends ConsumerWidget {
  const RestaurantsScreen({super.key});

  void _viewOnOfflineMap(BuildContext context, WidgetRef ref, RestaurantItemModel restaurant) {
    ref.read(mapCenterTargetProvider.notifier).state = MapCenterTarget(
      lat: restaurant.lat,
      lng: restaurant.lng,
      zoom: 17.0,
      title: restaurant.name,
    );
    // Cambiar a la pestaña del mapa (índice 1)
    ref.read(currentNavIndexProvider.notifier).state = 1;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final restaurantsAsync = ref.watch(restaurantsDataProvider);

    return Scaffold(
      backgroundColor: ToledoColors.bgBody,
      body: restaurantsAsync.when(
        data: (data) {
          return CustomScrollView(
            slivers: [
              // Cabecera Hero Imperial
              SliverToBoxAdapter(
                child: Container(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 22),
                  decoration: const BoxDecoration(
                    color: ToledoColors.darkSlate,
                    borderRadius: BorderRadius.vertical(bottom: Radius.circular(26)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: ToledoColors.accent.withOpacity(0.18),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: ToledoColors.accent.withOpacity(0.4)),
                        ),
                        child: Text(
                          'GUÍA GASTRONÓMICA · LA MALETA INQUIETA',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w800,
                            color: ToledoColors.accent,
                            letterSpacing: 1.1,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Dónde Comer Barato en Toledo',
                        style: GoogleFonts.cinzel(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Menús del día de 12€ a 15€, tabernas históricas donde nacieron las carcamusas y trucos para huir de las trampas turísticas.',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13,
                          color: ToledoColors.textLight,
                          height: 1.45,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Sección: 5 Reglas de Oro Antituristas
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.shield_rounded, color: ToledoColors.primary, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            '5 REGLAS DE ORO ANTITURISTAS',
                            style: GoogleFonts.cinzel(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: ToledoColors.primaryDark,
                              letterSpacing: 0.8,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      ...data.tips.map((tip) => _buildTipCard(tip)),
                    ],
                  ),
                ),
              ),

              // Sección: Platos Típicos Toledanos
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.restaurant_menu_rounded, color: ToledoColors.accentDark, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            'IMPRESCINDIBLES DE LA GASTRONOMÍA LOCAL',
                            style: GoogleFonts.cinzel(
                              fontSize: 14.5,
                              fontWeight: FontWeight.w800,
                              color: ToledoColors.primaryDark,
                              letterSpacing: 0.8,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 1.25,
                        ),
                        itemCount: data.typicalDishes.length,
                        itemBuilder: (context, index) {
                          final dish = data.typicalDishes[index];
                          return Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: ToledoColors.border),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.03),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  dish.name,
                                  style: GoogleFonts.cinzel(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: ToledoColors.primary,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 5),
                                Expanded(
                                  child: Text(
                                    dish.desc,
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 11,
                                      color: ToledoColors.textMuted,
                                      height: 1.35,
                                    ),
                                    maxLines: 4,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),

              // Sección: Restaurantes Recomendados
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
                  child: Row(
                    children: [
                      const Icon(Icons.star_rounded, color: ToledoColors.accentDark, size: 22),
                      const SizedBox(width: 8),
                      Text(
                        'RESTAURANTES SELECCIONADOS',
                        style: GoogleFonts.cinzel(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: ToledoColors.primaryDark,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Lista de Restaurantes
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 90),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final r = data.restaurants[index];
                      return _buildRestaurantCard(context, ref, r);
                    },
                    childCount: data.restaurants.length,
                  ),
                ),
              ),
            ],
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(color: ToledoColors.primary),
        ),
        error: (err, stack) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error_outline_rounded, color: Colors.red, size: 48),
                const SizedBox(height: 12),
                Text('Error al cargar la guía de restaurantes: $err', textAlign: TextAlign.center),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTipCard(RestaurantTipModel tip) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ToledoColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 26,
            height: 26,
            decoration: BoxDecoration(
              color: ToledoColors.primary.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '${tip.number}',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: ToledoColors.primary,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tip.title,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: ToledoColors.textMain,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  tip.desc,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    color: ToledoColors.textMuted,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRestaurantCard(BuildContext context, WidgetRef ref, RestaurantItemModel r) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: ToledoColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Barra superior con badge y precio
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: ToledoColors.accent.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: ToledoColors.accent.withOpacity(0.4)),
                        ),
                        child: Text(
                          r.badge,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            color: ToledoColors.accentDark,
                            letterSpacing: 0.6,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        r.name,
                        style: GoogleFonts.cinzel(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: ToledoColors.primaryDark,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: ToledoColors.primary.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: ToledoColors.primary.withOpacity(0.2)),
                  ),
                  child: Text(
                    r.price,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w800,
                      color: ToledoColors.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Subtítulo tipo de cocina y zona
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                const Icon(Icons.place_outlined, size: 14, color: ToledoColors.textLight),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    '${r.type} · ${r.zone}',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w500,
                      color: ToledoColors.textMuted,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // Descripción
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              r.description,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12.5,
                color: ToledoColors.textMain,
                height: 1.45,
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Caja Consejo Maleta Inquieta
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF9E6),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFFFD566)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.tips_and_updates_rounded, color: Color(0xFFD48806), size: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Consejo experto: ',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFFD48806),
                          ),
                        ),
                        TextSpan(
                          text: r.tip,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11.5,
                            color: const Color(0xFF594000),
                            height: 1.35,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          // Botones de acción
          Container(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 14),
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: ToledoColors.border)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      side: const BorderSide(color: ToledoColors.primary, width: 1.2),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      foregroundColor: ToledoColors.primary,
                    ),
                    icon: const Icon(Icons.map_rounded, size: 16),
                    label: Text(
                      'Ver en Mapa Offline',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    onPressed: () => _viewOnOfflineMap(context, ref, r),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      backgroundColor: ToledoColors.primary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    icon: const Icon(Icons.directions_rounded, size: 16),
                    label: Text(
                      'Cómo llegar (OSM)',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    onPressed: () => MapLauncher.openOsmRouteByAddress(
                      address: r.address,
                      fallbackLat: r.lat,
                      fallbackLng: r.lng,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
