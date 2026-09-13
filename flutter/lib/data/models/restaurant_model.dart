class RestaurantTipModel {
  final int number;
  final String title;
  final String desc;

  const RestaurantTipModel({
    required this.number,
    required this.title,
    required this.desc,
  });

  factory RestaurantTipModel.fromJson(Map<String, dynamic> json) {
    return RestaurantTipModel(
      number: json['number'] as int? ?? 0,
      title: json['title'] as String? ?? '',
      desc: json['desc'] as String? ?? '',
    );
  }
}

class TypicalDishModel {
  final String name;
  final String desc;

  const TypicalDishModel({
    required this.name,
    required this.desc,
  });

  factory TypicalDishModel.fromJson(Map<String, dynamic> json) {
    return TypicalDishModel(
      name: json['name'] as String? ?? '',
      desc: json['desc'] as String? ?? '',
    );
  }
}

class RestaurantItemModel {
  final String id;
  final String name;
  final String badge;
  final String price;
  final String priceCategory;
  final String address;
  final String zone;
  final String type;
  final double lat;
  final double lng;
  final String description;
  final String tip;

  const RestaurantItemModel({
    required this.id,
    required this.name,
    required this.badge,
    required this.price,
    required this.priceCategory,
    required this.address,
    required this.zone,
    required this.type,
    required this.lat,
    required this.lng,
    required this.description,
    required this.tip,
  });

  factory RestaurantItemModel.fromJson(Map<String, dynamic> json) {
    return RestaurantItemModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      badge: json['badge'] as String? ?? '',
      price: json['price'] as String? ?? '',
      priceCategory: json['priceCategory'] as String? ?? '',
      address: json['address'] as String? ?? '',
      zone: json['zone'] as String? ?? '',
      type: json['type'] as String? ?? '',
      lat: (json['lat'] as num?)?.toDouble() ?? 0.0,
      lng: (json['lng'] as num?)?.toDouble() ?? 0.0,
      description: json['description'] as String? ?? '',
      tip: json['tip'] as String? ?? '',
    );
  }
}

class RestaurantsDataModel {
  final List<RestaurantTipModel> tips;
  final List<TypicalDishModel> typicalDishes;
  final List<RestaurantItemModel> restaurants;

  const RestaurantsDataModel({
    required this.tips,
    required this.typicalDishes,
    required this.restaurants,
  });

  factory RestaurantsDataModel.fromJson(Map<String, dynamic> json) {
    return RestaurantsDataModel(
      tips: (json['tips'] as List<dynamic>?)
              ?.map((e) => RestaurantTipModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      typicalDishes: (json['typicalDishes'] as List<dynamic>?)
              ?.map((e) => TypicalDishModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      restaurants: (json['restaurants'] as List<dynamic>?)
              ?.map((e) => RestaurantItemModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}
