import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:travel_point/core/constants/constants.dart';
import 'package:travel_point/core/errors/exception.dart';
import 'package:travel_point/core/type/type_def.dart';
import 'package:http/http.dart' as http;
import 'package:travel_point/src/features/map/data/models/distance_matrix_response.dart';
import 'package:travel_point/src/features/map/data/models/nearby_places_response.dart';
import 'package:travel_point/src/features/map/data/models/place_model.dart';

abstract class MapRemoteDataSource {
  Future<Position> getCurrentLocation();

  Future<NearbyPlacesResponse> getNearbyPlaces(
      {required Position fromPosition,
      required int radius,
      required List<PlaceType> types});

  Future<List<Prediction>> getPredictionsFromAutocomplete(
      {required String searchInputText});

  Future<PlaceDetails> getPlaceFromPlaceId({required String placeId});

  Future<DistanceMatrixResponse> getDistanceForNearbyPlaces(
      {required List<PlaceModel> destinationAddresses,
      required LatLng originAddress,
      required TravelModeEnum travelMode});
}

class MapRemoteDataSourceImpl implements MapRemoteDataSource {
  MapRemoteDataSourceImpl(this._client);

  final http.Client _client;

  @override
  Future<Position> getCurrentLocation() async {
    //it should be here while testing, to enable location services when disabled permanently
    // OpenAppSettings.openLocationSettings();

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw const ApiException(
            errorMessage: 'Location services are disabled!',
            errorCode: 'location-services-disabled');
      }

      LocationPermission locationPermission =
          await Geolocator.checkPermission();
      if (locationPermission == LocationPermission.denied) {
        locationPermission = await Geolocator.requestPermission();
        if (locationPermission == LocationPermission.denied) {
          throw const ApiException(
              errorMessage: 'Location permission are disabled!',
              errorCode: 'location-permission-disabled');
        }
      }
      if (locationPermission == LocationPermission.deniedForever) {
        throw const ApiException(
            errorMessage: 'Location permissions are permanently denied!',
            errorCode: 'location-permission-denied');
      }
      Position position = await Geolocator.getCurrentPosition();
      return position;
    } on LocationServiceDisabledException catch (e) {
      throw ApiException(
          errorMessage: e.toString(), errorCode: 'location-permission-denied');
    }
  }

  @override
  Future<NearbyPlacesResponse> getNearbyPlaces(
      {required Position fromPosition,
      required int radius,
      required List<PlaceType> types}) async {
    List<NearbyPlacesResponse> responses = [];
    NearbyPlacesResponse combinedResponse = NearbyPlacesResponse(results: []);

    try {
      for (PlaceType type in types) {
        final response = await _client.post(Uri.parse(
            '$NEARBY_SEARCH_API?location=${fromPosition.latitude},${fromPosition.longitude}&radius=$radius&type=${type.name}&key=$API_KEY'));

        if (response.statusCode != 200 && response.statusCode != 201) {
          throw ApiException(
              errorMessage: response.body,
              errorCode: response.statusCode.toString());
        }

        NearbyPlacesResponse nearbyPlacesResponse =
            NearbyPlacesResponse.fromJson(jsonDecode(response.body));
        combinedResponse.results?.addAll(nearbyPlacesResponse.results ?? []);
      }
      return combinedResponse;
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(
          errorMessage: e.toString(), errorCode: 'error-fetching-data');
    }
  }

  @override
  Future<List<Prediction>> getPredictionsFromAutocomplete(
      {required String searchInputText}) async {
    if (searchInputText.isEmpty) {
      return <Prediction>[];
    }
    final places = GoogleMapsPlaces(apiKey: API_KEY);
    final response = await places.autocomplete(searchInputText);
    return response.predictions;
  }

  @override
  Future<PlaceDetails> getPlaceFromPlaceId({required String placeId}) async {
    final places = GoogleMapsPlaces(apiKey: API_KEY);
    final placeDetailsResponse = await places.getDetailsByPlaceId(placeId);
    final placeDetails = placeDetailsResponse.result;
    return placeDetails;
  }

  @override
  Future<DistanceMatrixResponse> getDistanceForNearbyPlaces(
      {required List<PlaceModel> destinationAddresses,
      required LatLng originAddress,
      required TravelModeEnum travelMode}) async {
    try {
      final originLatLong =
          '${originAddress.latitude},${originAddress.longitude}';
      final destinationsLatLong = destinationAddresses
          .map(
              (address) => Uri.encodeComponent('${address.lat},${address.lng}'))
          .join('|');

      final response = await _client.post(Uri.parse(
          '$DISTANCE_MATRIX_API?origins=$originLatLong&destinations=$destinationsLatLong&mode=$travelMode&key=$API_KEY'));

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw ApiException(
            errorMessage: response.body,
            errorCode: response.statusCode.toString());
      }

      final responseBody = response.body;

      final dynamic jsonBody = jsonDecode(responseBody);

      DistanceMatrixResponse distanceMatrixResponse =
          DistanceMatrixResponse.fromJson(jsonBody);

      return distanceMatrixResponse;
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(
          errorMessage: e.toString(), errorCode: 'error-getting-distance-data');
    }
  }
}
