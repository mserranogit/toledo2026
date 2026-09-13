import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import '../../data/models/audio_track_model.dart';
import 'itinerary_provider.dart';

final audioguidesListProvider = FutureProvider<List<AudioTrackModel>>((ref) async {
  final dataSource = ref.watch(localDataSourceProvider);
  return dataSource.getAudioguides();
});

class AudioPlayerState {
  final AudioTrackModel? currentTrack;
  final bool isPlaying;
  final bool isLoading;
  final Duration position;
  final Duration duration;
  final double speed;

  const AudioPlayerState({
    this.currentTrack,
    this.isPlaying = false,
    this.isLoading = false,
    this.position = Duration.zero,
    this.duration = Duration.zero,
    this.speed = 1.0,
  });

  AudioPlayerState copyWith({
    AudioTrackModel? currentTrack,
    bool? isPlaying,
    bool? isLoading,
    Duration? position,
    Duration? duration,
    double? speed,
  }) {
    return AudioPlayerState(
      currentTrack: currentTrack ?? this.currentTrack,
      isPlaying: isPlaying ?? this.isPlaying,
      isLoading: isLoading ?? this.isLoading,
      position: position ?? this.position,
      duration: duration ?? this.duration,
      speed: speed ?? this.speed,
    );
  }
}

class AudioPlayerNotifier extends StateNotifier<AudioPlayerState> {
  final AudioPlayer _player = AudioPlayer();
  final Ref ref;
  StreamSubscription? _playerStateSubscription;
  StreamSubscription? _positionSubscription;
  StreamSubscription? _durationSubscription;

  AudioPlayerNotifier(this.ref) : super(const AudioPlayerState()) {
    _initListeners();
  }

  void _initListeners() {
    _playerStateSubscription = _player.playerStateStream.listen((playerState) {
      final isPlaying = playerState.playing;
      final processingState = playerState.processingState;

      if (processingState == ProcessingState.completed) {
        state = state.copyWith(isPlaying: false, position: Duration.zero);
      } else if (processingState == ProcessingState.buffering ||
          processingState == ProcessingState.loading) {
        state = state.copyWith(isLoading: true);
      } else {
        state = state.copyWith(isPlaying: isPlaying, isLoading: false);
      }
    });

    _positionSubscription = _player.positionStream.listen((pos) {
      state = state.copyWith(position: pos);
    });

    _durationSubscription = _player.durationStream.listen((dur) {
      if (dur != null) {
        state = state.copyWith(duration: dur);
      }
    });
  }

  Future<void> playTrack(AudioTrackModel track) async {
    try {
      if (state.currentTrack?.id == track.id) {
        if (_player.playing) {
          await _player.pause();
        } else {
          await _player.play();
        }
        return;
      }

      state = state.copyWith(currentTrack: track, isLoading: true);
      await _player.stop();
      await _player.setAsset(track.audioAsset);
      await _player.setSpeed(state.speed);
      await _player.play();
    } catch (e) {
      state = state.copyWith(isLoading: false, isPlaying: false);
    }
  }

  Future<void> togglePlayPause() async {
    if (_player.playing) {
      await _player.pause();
    } else {
      await _player.play();
    }
  }

  Future<void> seek(Duration position) async {
    await _player.seek(position);
  }

  Future<void> seekRelative(int seconds) async {
    final newPos = state.position + Duration(seconds: seconds);
    final clamped = newPos < Duration.zero
        ? Duration.zero
        : (newPos > state.duration ? state.duration : newPos);
    await _player.seek(clamped);
  }

  Future<void> setSpeed(double speed) async {
    await _player.setSpeed(speed);
    state = state.copyWith(speed: speed);
  }

  Future<void> stop() async {
    await _player.stop();
    state = const AudioPlayerState();
  }

  @override
  void dispose() {
    _playerStateSubscription?.cancel();
    _positionSubscription?.cancel();
    _durationSubscription?.cancel();
    _player.dispose();
    super.dispose();
  }
}

final audioPlayerProvider =
    StateNotifierProvider<AudioPlayerNotifier, AudioPlayerState>((ref) {
  return AudioPlayerNotifier(ref);
});
