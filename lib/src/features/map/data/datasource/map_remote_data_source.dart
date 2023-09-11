import 'dart:convert';

import 'package:geolocator/geolocator.dart';
import 'package:travel_point/core/constants/constants.dart';
import 'package:travel_point/core/errors/exception.dart';
import 'package:travel_point/core/type/type_def.dart';
import 'package:http/http.dart' as http;
import 'package:travel_point/src/model/nearby_places_response.dart';

abstract class MapRemoteDataSource {
  Future<Position> getCurrentLocation();

  Future<NearbyPlacesResponse> getNearbyPlaces(
      {required Position fromPosition,
      required int radius,
      required List<PlaceType> types});
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
    NearbyPlacesResponse combinedResponse = NearbyPlacesResponse(
        results: []);

    try {
      for (PlaceType type in types) {
        final response = await _client.post(Uri.parse(
            '${NEARBY_SEARCH_API}?location=${fromPosition.latitude},${fromPosition.longitude}&radius=$radius&type=${type.name}&key=$API_KEY'));

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
}
