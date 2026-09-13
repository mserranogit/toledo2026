class ItineraryDayModel {
  final String id;
  final int dayNumber;
  final String dateFormatted;
  final String title;
  final String summary;
  final List<ItineraryItemModel> items;

  ItineraryDayModel({
    required this.id,
    required this.dayNumber,
    required this.dateFormatted,
    required this.title,
    required this.summary,
    required this.items,
  });

  factory ItineraryDayModel.fromJson(Map<String, dynamic> json) {
    return ItineraryDayModel(
      id: json['id'] as String,
      dayNumber: json['dayNumber'] as int,
      dateFormatted: json['dateFormatted'] as String,
      title: json['title'] as String,
      summary: json['summary'] as String,
      items: (json['items'] as List<dynamic>)
          .map((e) => ItineraryItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class ItineraryItemModel {
  final String id;
  final String timeSlot;
  final String title;
  final String category;
  final String badgeText;
  final String badgeType;
  final String duration;
  final String distance;
  final String cost;
  final bool isFree;
  final String locationName;
  final double lat;
  final double lng;
  final String? audioId;
  final String shortDescription;
  final List<String> highlights;
  final String tips;

  ItineraryItemModel({
    required this.id,
    required this.timeSlot,
    required this.title,
    required this.category,
    required this.badgeText,
    required this.badgeType,
    required this.duration,
    required this.distance,
    required this.cost,
    required this.isFree,
    required this.locationName,
    required this.lat,
    required this.lng,
    this.audioId,
    required this.shortDescription,
    required this.highlights,
    required this.tips,
  });

  factory ItineraryItemModel.fromJson(Map<String, dynamic> json) {
    return ItineraryItemModel(
      id: json['id'] as String,
      timeSlot: json['timeSlot'] as String,
      title: json['title'] as String,
      category: json['category'] as String,
      badgeText: json['badgeText'] as String,
      badgeType: json['badgeType'] as String,
      duration: json['duration'] as String,
      distance: json['distance'] as String,
      cost: json['cost'] as String,
      isFree: json['isFree'] as bool,
      locationName: json['locationName'] as String,
      lat: (json['lat'] as num).toDouble(),
      lng: (json['lng'] as num).toDouble(),
      audioId: json['audioId'] as String?,
      shortDescription: json['shortDescription'] as String,
      highlights: (json['highlights'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      tips: json['tips'] as String? ?? '',
    );
  }
}
