import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/toledo_colors.dart';
import '../../../data/models/itinerary_item_model.dart';
import '../../providers/itinerary_provider.dart';
import '../../providers/audio_player_provider.dart';
import '../../widgets/toledo_badge.dart';
import '../../widgets/monument_detail_sheet.dart';

class ItineraryScreen extends ConsumerWidget {
  const ItineraryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itineraryAsync = ref.watch(itineraryDaysProvider);
    final selectedDay = ref.watch(selectedDayIndexProvider);

    return Scaffold(
      backgroundColor: ToledoColors.bgBody,
      body: itineraryAsync.when(
        data: (days) {
          final currentDay = days.firstWhere(
            (d) => d.dayNumber == selectedDay,
            orElse: () => days.first,
          );

          return CustomScrollView(
            slivers: [
              // Cabecera Hero Imperial
              SliverToBoxAdapter(
                child: Container(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                  decoration: const BoxDecoration(
                    color: ToledoColors.darkSlate,
                    borderRadius: BorderRadius.vertical(bottom: Radius.circular(26)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Badge Fecha
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: ToledoColors.accent.withOpacity(0.18),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: ToledoColors.accent.withOpacity(0.4)),
                        ),
                        child: Text(
                          'GUÍA EXPERTA · 21 Y 22 DE OCTUBRE 2026',
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
                        'Toledo Inolvidable',
                        style: GoogleFonts.cinzel(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          letterSpacing: 1.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Historia, senderos, misterio y arqueología visigoda a tu propio ritmo.',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13,
                          color: ToledoColors.textLight,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 18),

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
                                subtitle: 'Senderos & Judería',
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
              ),

              // Título y resumen del día seleccionado
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 18, 20, 8),
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
                      const SizedBox(height: 12),
                    ],
                  ),
                ),
              ),

              // Lista de Hitos (Timeline)
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final item = currentDay.items[index];
                      final isLast = index == currentDay.items.length - 1;
                      return _TimelineCard(item: item, isLast: isLast);
                    },
                    childCount: currentDay.items.length,
                  ),
                ),
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
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
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
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: isSelected ? Colors.white : Colors.white70,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 10.5,
                color: isSelected ? Colors.white.withOpacity(0.9) : Colors.white54,
              ),
            ),
          ],
        ),
      ),
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
                          Text(
                            item.isFree ? 'Entrada Libre' : 'Coste: ${item.cost}',
                            style: TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w700,
                              color: item.isFree ? ToledoColors.badgeFreeText : ToledoColors.badgePriceText,
                            ),
                          ),

                          // Si tiene audioguía, botón rápido
                          if (item.audioId != null)
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
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
                                          size: 15,
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
                            )
                          else
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
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
