import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/audio_track_model.dart';
import '../models/itinerary_item_model.dart';
import '../models/budget_item_model.dart';
import '../models/map_point_model.dart';

class LocalDataSource {
  Future<List<AudioTrackModel>> getAudioguides() async {
    final jsonString = await rootBundle.loadString('assets/data/audioguides.json');
    final List<dynamic> list = json.decode(jsonString);
    return list.map((e) => AudioTrackModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<List<ItineraryDayModel>> getItineraryDays() async {
    final jsonString = await rootBundle.loadString('assets/data/itinerary.json');
    final Map<String, dynamic> data = json.decode(jsonString);
    final List<dynamic> days = data['days'];
    return days.map((e) => ItineraryDayModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<BudgetDataModel> getBudgetData() async {
    final jsonString = await rootBundle.loadString('assets/data/budget.json');
    final Map<String, dynamic> data = json.decode(jsonString);
    return BudgetDataModel.fromJson(data);
  }

  Future<MapPointsDataModel> getMapPointsData() async {
    final jsonString = await rootBundle.loadString('assets/data/map_points.json');
    final Map<String, dynamic> data = json.decode(jsonString);
    return MapPointsDataModel.fromJson(data);
  }
}
