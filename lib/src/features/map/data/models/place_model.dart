class PlaceModel {
  final String name;
  final dynamic? rating;
  final double lat;
  final double lng;
  final int? userRatingsTotal;
  final String placeId;

  PlaceModel({
    required this.name,
    this.rating,
    required this.lat,
    required this.lng,
    this.userRatingsTotal,
    required this.placeId,
  });
}
