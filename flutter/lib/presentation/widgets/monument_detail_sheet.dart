import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/theme/toledo_colors.dart';
import '../../data/models/itinerary_item_model.dart';
import '../providers/audio_player_provider.dart';
import 'toledo_badge.dart';
import 'full_player_sheet.dart';

class MonumentDetailSheet extends ConsumerWidget {
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

  Future<void> _openGoogleMaps(double lat, double lng, String label) async {
    final uri = Uri.parse('https://www.google.com/maps/search/?api=1&query=$lat,$lng');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final audioListAsync = ref.watch(audioguidesListProvider);

    return Container(
      height: MediaQuery.of(context).size.height * 0.82,
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

          // Contenido desplazable
          Expanded(
            child: SingleChildScrollView(
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
                      fontSize: 14.5,
                      color: ToledoColors.textMain,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Botón de Audioguía si está disponible
                  if (item.audioId != null) ...[
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
                                padding: EdgeInsets.only(top: 4, right: 8),
                                child: Icon(Icons.star_rounded, size: 14, color: ToledoColors.accent),
                              ),
                              Expanded(
                                child: Text(
                                  h,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 13.5,
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

                  // Consejos Prácticos
                  if (item.tips.isNotEmpty) ...[
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: ToledoColors.badgePriceBg,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: ToledoColors.badgePriceBorder),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.lightbulb_outline_rounded, color: ToledoColors.badgePriceText, size: 20),
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
                                    color: ToledoColors.badgePriceText,
                                    letterSpacing: 0.6,
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  item.tips,
                                  style: TextStyle(
                                    fontSize: 12.5,
                                    color: ToledoColors.badgePriceText.withOpacity(0.95),
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

                  // Botón Abrir en Google Maps exterior
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.navigation_outlined, size: 18),
                      label: const Text('Cómo llegar con Google Maps'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: ToledoColors.primary,
                        side: const BorderSide(color: ToledoColors.primary, width: 1.5),
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      onPressed: () => _openGoogleMaps(item.lat, item.lng, item.title),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
