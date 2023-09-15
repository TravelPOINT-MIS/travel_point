import 'package:geolocator/geolocator.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:travel_point/core/type/type_def.dart';
import 'package:travel_point/src/features/map/data/models/nearby_places_response.dart';

abstract class MapRepository {
  const MapRepository();

  ResultFuture<Position> determinePosition();

  ResultFuture<NearbyPlacesResponse> getNearbyPlaces(
      {required Position fromPosition,
      required int radius,
      required List<PlaceType> types});

  ResultFuture<List<Prediction>> getPredictionsFromAutocomplete(
      {required String searchInputText});
}
