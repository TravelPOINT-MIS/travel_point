import 'package:dartz/dartz.dart';
import 'package:geolocator_platform_interface/src/models/position.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/src/places.dart';
import 'package:travel_point/core/errors/exception.dart';
import 'package:travel_point/core/errors/failure.dart';
import 'package:travel_point/core/type/type_def.dart';
import 'package:travel_point/src/features/map/data/datasource/map_remote_data_source.dart';
import 'package:travel_point/src/features/map/data/models/distance_matrix_response.dart';
import 'package:travel_point/src/features/map/data/models/place_model.dart';
import 'package:travel_point/src/features/map/domain/repository/map_repository.dart';
import 'package:travel_point/src/features/map/data/models/nearby_places_response.dart';

class MapRepositoryImpl implements MapRepository {
  const MapRepositoryImpl(this._remoteDataSource);

  final MapRemoteDataSource _remoteDataSource;

  @override
  ResultFuture<Position> determinePosition() async {
    try {
      Position position = await _remoteDataSource.getCurrentLocation();
      return Right(position);
    } on ApiException catch (error) {
      final ApiFailure apiFailure = ApiFailure.fromApiException(error);
      return Left(apiFailure);
    }
  }

  @override
  ResultFuture<NearbyPlacesResponse> getNearbyPlaces(
      {required Position fromPosition,
      required int radius,
      required List<PlaceType> types}) async {
    try {
      NearbyPlacesResponse nearbyPlacesResponse =
          await _remoteDataSource.getNearbyPlaces(
              fromPosition: fromPosition, radius: radius, types: types);

      return Right(nearbyPlacesResponse);
    } on ApiException catch (error) {
      final ApiFailure apiFailure = ApiFailure.fromApiException(error);
      return Left(apiFailure);
    }
  }

  @override
  ResultFuture<List<Prediction>> getPredictionsFromAutocomplete(
      {required String searchInputText}) async {
    try {
      List<Prediction> predictions = await _remoteDataSource
          .getPredictionsFromAutocomplete(searchInputText: searchInputText);
      return Right(predictions);
    } on ApiException catch (error) {
      final ApiFailure apiFailure = ApiFailure.fromApiException(error);
      return Left(apiFailure);
    }
  }

  @override
  ResultFuture<PlaceDetails> getPlaceFromPlaceId(
      {required String placeId}) async {
    try {
      PlaceDetails placesDetailsResponse =
          await _remoteDataSource.getPlaceFromPlaceId(placeId: placeId);
      return Right(placesDetailsResponse);
    } on ApiException catch (error) {
      final ApiFailure apiFailure = ApiFailure.fromApiException(error);
      return Left(apiFailure);
    }
  }

  @override
  ResultFuture<DistanceMatrixResponse> getDistanceForNearbyPlaces(
      {required List<PlaceModel> destinationAddresses,
      required LatLng originAddress,
      required TravelModeEnum travelMode}) async {
    try {
      DistanceMatrixResponse distanceMatrixDistance =
          await _remoteDataSource.getDistanceForNearbyPlaces(
              destinationAddresses: destinationAddresses,
              originAddress: originAddress,
              travelMode: travelMode);

      return Right(distanceMatrixDistance);
    } on ApiException catch (error) {
      final ApiFailure apiFailure = ApiFailure.fromApiException(error);
      return Left(apiFailure);
    }
  }
}
