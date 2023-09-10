import 'package:geolocator/geolocator.dart';
import 'package:travel_point/core/type/type_def.dart';
import 'package:travel_point/src/model/nearby_places_response.dart';

abstract class MapRepository {
  const MapRepository();

  ResultFuture<Position> determinePosition();

  ResultFuture<NearbyPlacesResponse> getNearbyPlaces(
      {required Position fromPosition,
      required int radius,
      required PlaceType type});
}
