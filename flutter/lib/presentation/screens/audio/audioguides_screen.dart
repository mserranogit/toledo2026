import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/toledo_colors.dart';
import '../../providers/audio_player_provider.dart';
import '../../widgets/full_player_sheet.dart';

class AudioguidesScreen extends ConsumerWidget {
  const AudioguidesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final audioguidesAsync = ref.watch(audioguidesListProvider);
    final playerState = ref.watch(audioPlayerProvider);

    return Scaffold(
      backgroundColor: ToledoColors.bgBody,
      body: audioguidesAsync.when(
        data: (tracks) {
          return CustomScrollView(
            slivers: [
              // Header Imperial
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
                          'REPRODUCTOR MULTIMEDIA 100% OFFLINE',
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
                        'Audioguías de Toledo',
                        style: GoogleFonts.cinzel(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '6 narraciones inmersivas con transcripción completa para escuchar incluso en el interior de conventos o sin cobertura móvil.',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12.5,
                          color: ToledoColors.textLight,
                          height: 1.45,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Lista de pistas
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 30),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final track = tracks[index];
                      final isCurrent = playerState.currentTrack?.id == track.id;
                      final isPlaying = isCurrent && playerState.isPlaying;

                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isCurrent ? ToledoColors.accent : ToledoColors.border,
                            width: isCurrent ? 1.5 : 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: isCurrent
                                  ? ToledoColors.accent.withOpacity(0.15)
                                  : Colors.black.withOpacity(0.04),
                              blurRadius: isCurrent ? 10 : 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(16),
                            onTap: () {
                              ref.read(audioPlayerProvider.notifier).playTrack(track);
                              FullPlayerSheet.show(context);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(14),
                              child: Row(
                                children: [
                                  // Botón de Play/Pause animado
                                  Container(
                                    width: 48,
                                    height: 48,
                                    decoration: BoxDecoration(
                                      color: isPlaying ? ToledoColors.primary : ToledoColors.primaryLight,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: isPlaying ? ToledoColors.accent : ToledoColors.primary.withOpacity(0.3),
                                        width: 1.5,
                                      ),
                                    ),
                                    child: Center(
                                      child: Icon(
                                        isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                                        color: isPlaying ? Colors.white : ToledoColors.primary,
                                        size: 26,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 14),

                                  // Información de la pista
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          track.title,
                                          style: GoogleFonts.cinzel(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w700,
                                            color: isCurrent ? ToledoColors.primaryDark : ToledoColors.textMain,
                                            letterSpacing: 0.3,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          track.subtitle,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.plusJakartaSans(
                                            fontSize: 11.5,
                                            color: ToledoColors.textMuted,
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        Row(
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                                              decoration: BoxDecoration(
                                                color: ToledoColors.badgeTourBg,
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  const Icon(Icons.timer_outlined, size: 11, color: ToledoColors.badgeTourText),
                                                  const SizedBox(width: 3),
                                                  Text(
                                                    track.durationFormatted,
                                                    style: const TextStyle(
                                                      fontSize: 10.5,
                                                      fontWeight: FontWeight.w700,
                                                      color: ToledoColors.badgeTourText,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            const Text(
                                              'MP3 Nativo',
                                              style: TextStyle(fontSize: 10.5, color: ToledoColors.textLight),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),

                                  const Icon(Icons.chevron_right_rounded, color: ToledoColors.textLight),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                    childCount: tracks.length,
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
          child: Text('Error cargando audioguías: $err'),
        ),
      ),
    );
  }
}
