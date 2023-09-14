import 'package:travel_point/src/features/map/data/models/nearby_places_response.dart';

class PlaceModel {
  final String name;
  final dynamic rating;
  final double lat;
  final double lng;
  final int? userRatingsTotal;
  final String placeId;
  final List<Photos>? photos;
  final List<String>? types;
  final OpeningHours? openingHours;

  PlaceModel({
    required this.name,
    this.rating,
    required this.lat,
    required this.lng,
    this.userRatingsTotal,
    required this.placeId,
    this.photos,
    this.types,
    this.openingHours,
  });
}
