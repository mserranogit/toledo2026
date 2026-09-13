class AudioTrackModel {
  final String id;
  final String title;
  final String subtitle;
  final String monument;
  final int durationSeconds;
  final String durationFormatted;
  final String audioAsset;
  final double lat;
  final double lng;
  final String transcript;

  AudioTrackModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.monument,
    required this.durationSeconds,
    required this.durationFormatted,
    required this.audioAsset,
    required this.lat,
    required this.lng,
    required this.transcript,
  });

  factory AudioTrackModel.fromJson(Map<String, dynamic> json) {
    return AudioTrackModel(
      id: json['id'] as String,
      title: json['title'] as String,
      subtitle: json['subtitle'] as String,
      monument: json['monument'] as String,
      durationSeconds: json['durationSeconds'] as int,
      durationFormatted: json['durationFormatted'] as String,
      audioAsset: json['audioAsset'] as String,
      lat: (json['lat'] as num).toDouble(),
      lng: (json['lng'] as num).toDouble(),
      transcript: json['transcript'] as String? ?? '',
    );
  }
}
