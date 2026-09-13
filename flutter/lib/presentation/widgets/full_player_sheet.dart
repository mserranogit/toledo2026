import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/toledo_colors.dart';
import '../providers/audio_player_provider.dart';

class FullPlayerSheet extends ConsumerWidget {
  const FullPlayerSheet({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const FullPlayerSheet(),
    );
  }

  String _formatDuration(Duration d) {
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playerState = ref.watch(audioPlayerProvider);
    final track = playerState.currentTrack;

    if (track == null) {
      return const SizedBox.shrink();
    }

    final double maxSlider = playerState.duration.inMilliseconds.toDouble();
    final double currentSlider = playerState.position.inMilliseconds.toDouble().clamp(0.0, maxSlider > 0 ? maxSlider : 1.0);

    return Container(
      height: MediaQuery.of(context).size.height * 0.88,
      decoration: const BoxDecoration(
        color: ToledoColors.darkSlate,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        children: [
          // Barra de agarre
          Container(
            margin: const EdgeInsets.only(top: 12, bottom: 8),
            width: 44,
            height: 4.5,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.3),
              borderRadius: BorderRadius.circular(3),
            ),
          ),

          // Header con botón cerrar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: ToledoColors.accent.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: ToledoColors.accent.withOpacity(0.4)),
                  ),
                  child: Text(
                    'AUDIOGUÍA TOLEDO 2026',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: ToledoColors.accent,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white, size: 28),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),

          // Contenido desplazable (Arte + Controles + Transcripción)
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
              child: Column(
                children: [
                  // Emblema Toledano con Arte
                  Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [ToledoColors.primaryDark, ToledoColors.primary],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      shape: BoxShape.circle,
                      border: Border.all(color: ToledoColors.accent, width: 2.5),
                      boxShadow: [
                        BoxShadow(
                          color: ToledoColors.primary.withOpacity(0.4),
                          blurRadius: 24,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Icon(Icons.headphones_rounded, size: 68, color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Título & Subtítulo
                  Text(
                    track.title,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.cinzel(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      letterSpacing: 1.1,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    track.subtitle,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      color: ToledoColors.textLight,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Barra de Progreso
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      thumbColor: ToledoColors.accent,
                      activeTrackColor: ToledoColors.accent,
                      inactiveTrackColor: Colors.white.withOpacity(0.15),
                      trackHeight: 4,
                      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 7),
                    ),
                    child: Slider(
                      value: currentSlider,
                      max: maxSlider > 0 ? maxSlider : 1.0,
                      onChanged: (val) {
                        ref.read(audioPlayerProvider.notifier).seek(Duration(milliseconds: val.toInt()));
                      },
                    ),
                  ),

                  // Tiempos
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _formatDuration(playerState.position),
                          style: const TextStyle(fontSize: 11, color: ToledoColors.textLight, fontWeight: FontWeight.w600),
                        ),
                        Text(
                          _formatDuration(playerState.duration),
                          style: const TextStyle(fontSize: 11, color: ToledoColors.textLight, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Controles de Reproducción
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Selector de Velocidad
                      InkWell(
                        onTap: () {
                          final currentSpeed = playerState.speed;
                          final nextSpeed = currentSpeed == 1.0
                              ? 1.25
                              : (currentSpeed == 1.25 ? 1.5 : (currentSpeed == 1.5 ? 2.0 : 1.0));
                          ref.read(audioPlayerProvider.notifier).setSpeed(nextSpeed);
                        },
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white.withOpacity(0.2)),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            '${playerState.speed}x',
                            style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),

                      // Rebobinar 10s
                      IconButton(
                        icon: const Icon(Icons.replay_10_rounded, color: Colors.white, size: 32),
                        onPressed: () => ref.read(audioPlayerProvider.notifier).seekRelative(-10),
                      ),
                      const SizedBox(width: 14),

                      // Play / Pause Principal
                      GestureDetector(
                        onTap: () => ref.read(audioPlayerProvider.notifier).togglePlayPause(),
                        child: Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [ToledoColors.accent, ToledoColors.accentDark],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: ToledoColors.accent.withOpacity(0.4),
                                blurRadius: 16,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Icon(
                              playerState.isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                              size: 38,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),

                      // Avanzar 10s
                      IconButton(
                        icon: const Icon(Icons.forward_10_rounded, color: Colors.white, size: 32),
                        onPressed: () => ref.read(audioPlayerProvider.notifier).seekRelative(10),
                      ),
                      const SizedBox(width: 20),

                      // Espaciador estético balanceado
                      const SizedBox(width: 32),
                    ],
                  ),
                  const SizedBox(height: 30),

                  // Caja de Transcripción Completa
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: ToledoColors.darkCard,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: Colors.white.withOpacity(0.08)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.description_outlined, color: ToledoColors.accent, size: 18),
                            const SizedBox(width: 8),
                            Text(
                              'TRANSCRIPCIÓN COMPLETA',
                              style: GoogleFonts.cinzel(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: ToledoColors.accent,
                                letterSpacing: 1.0,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          track.transcript.isNotEmpty ? track.transcript : 'Sin transcripción disponible para esta pista.',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 14,
                            color: Colors.white.withOpacity(0.88),
                            height: 1.65,
                          ),
                        ),
                      ],
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
