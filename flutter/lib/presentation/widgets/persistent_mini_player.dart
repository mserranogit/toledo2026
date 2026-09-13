import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/toledo_colors.dart';
import '../providers/audio_player_provider.dart';
import 'full_player_sheet.dart';

class PersistentMiniPlayer extends ConsumerWidget {
  const PersistentMiniPlayer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playerState = ref.watch(audioPlayerProvider);
    final track = playerState.currentTrack;

    if (track == null) {
      return const SizedBox.shrink();
    }

    final double progress = playerState.duration.inMilliseconds > 0
        ? (playerState.position.inMilliseconds / playerState.duration.inMilliseconds).clamp(0.0, 1.0)
        : 0.0;

    return GestureDetector(
      onTap: () => FullPlayerSheet.show(context),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: ToledoColors.darkSlate.withOpacity(0.96),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: ToledoColors.accent.withOpacity(0.4), width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.22),
              blurRadius: 14,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Barra de progreso sutil superior
              LinearProgressIndicator(
                value: progress,
                backgroundColor: Colors.white.withOpacity(0.1),
                valueColor: const AlwaysStoppedAnimation<Color>(ToledoColors.accent),
                minHeight: 2.5,
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                child: Row(
                  children: [
                    // Icono de Disco Toledano
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: ToledoColors.primary,
                        shape: BoxShape.circle,
                        border: Border.all(color: ToledoColors.accent, width: 1.5),
                      ),
                      child: const Center(
                        child: Icon(Icons.audiotrack_rounded, color: Colors.white, size: 20),
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Títulos
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            track.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.cinzel(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 1),
                          Text(
                            track.monument,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 11,
                              color: ToledoColors.textLight,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Botón Rebobinar 10s
                    IconButton(
                      icon: const Icon(Icons.replay_10_rounded, color: Colors.white70, size: 22),
                      onPressed: () => ref.read(audioPlayerProvider.notifier).seekRelative(-10),
                    ),

                    // Botón Play / Pause
                    IconButton(
                      icon: Icon(
                        playerState.isPlaying ? Icons.pause_circle_filled_rounded : Icons.play_circle_fill_rounded,
                        color: ToledoColors.accent,
                        size: 34,
                      ),
                      onPressed: () => ref.read(audioPlayerProvider.notifier).togglePlayPause(),
                    ),

                    // Botón Cerrar
                    IconButton(
                      icon: const Icon(Icons.close_rounded, color: Colors.white54, size: 18),
                      onPressed: () => ref.read(audioPlayerProvider.notifier).stop(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
