class MapPointsDataModel {
  final List<MapRouteModel> routes;
  final List<MapLandmarkModel> landmarks;

  MapPointsDataModel({required this.routes, required this.landmarks});

  factory MapPointsDataModel.fromJson(Map<String, dynamic> json) {
    return MapPointsDataModel(
      routes: (json['routes'] as List<dynamic>)
          .map((e) => MapRouteModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      landmarks: (json['landmarks'] as List<dynamic>)
          .map((e) => MapLandmarkModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class MapRouteModel {
  final String id;
  final String title;
  final String color;
  final String distance;
  final String time;
  final List<MapRoutePointModel> points;

  MapRouteModel({
    required this.id,
    required this.title,
    required this.color,
    required this.distance,
    required this.time,
    required this.points,
  });

  factory MapRouteModel.fromJson(Map<String, dynamic> json) {
    return MapRouteModel(
      id: json['id'] as String,
      title: json['title'] as String,
      color: json['color'] as String,
      distance: json['distance'] as String,
      time: json['time'] as String,
      points: (json['points'] as List<dynamic>)
          .map((e) => MapRoutePointModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class MapRoutePointModel {
  final double lat;
  final double lng;
  final String title;
  final String type;

  MapRoutePointModel({
    required this.lat,
    required this.lng,
    required this.title,
    required this.type,
  });

  factory MapRoutePointModel.fromJson(Map<String, dynamic> json) {
    return MapRoutePointModel(
      lat: (json['lat'] as num).toDouble(),
      lng: (json['lng'] as num).toDouble(),
      title: json['title'] as String,
      type: json['type'] as String,
    );
  }
}

class MapLandmarkModel {
  final String id;
  final String title;
  final String category;
  final double lat;
  final double lng;
  final String icon;

  MapLandmarkModel({
    required this.id,
    required this.title,
    required this.category,
    required this.lat,
    required this.lng,
    required this.icon,
  });

  factory MapLandmarkModel.fromJson(Map<String, dynamic> json) {
    return MapLandmarkModel(
      id: json['id'] as String,
      title: json['title'] as String,
      category: json['category'] as String,
      lat: (json['lat'] as num).toDouble(),
      lng: (json['lng'] as num).toDouble(),
      icon: json['icon'] as String,
    );
  }
}
