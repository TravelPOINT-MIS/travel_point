import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:travel_point/src/features/map/data/models/distance_matrix_response.dart';
import 'package:travel_point/src/features/map/data/models/place_model.dart';

abstract class MapState extends Equatable {
  final DistanceMatrixResponse? distanceMatrixResponse;
  final CameraPosition cameraPosition;
  final Set<Marker> markers;
  final List<PlaceModel> places;
  final List<Prediction> predictions;

  const MapState(
      {this.distanceMatrixResponse,
      Set<Marker>? markers,
      CameraPosition? cameraPosition,
      List<PlaceModel>? places,
      List<Prediction>? predictions})
      : markers = markers ?? const {},
        cameraPosition = cameraPosition ??
            const CameraPosition(
              target: LatLng(41.555418, 21.77),
              zoom: 7.7,
            ),
        places = places ?? const [],
        predictions = predictions ?? const [];

  @override
  List<Object?> get props => [markers, cameraPosition, places];
}

class InitialMapState extends MapState {
  final PlaceDetails placeDetails;

  InitialMapState({
    super.markers,
    super.cameraPosition,
    super.places,
    super.predictions,
    PlaceDetails? placeDetails,
  }) : placeDetails = placeDetails ?? PlaceDetails(name: '', placeId: '');

  @override
  List<Object?> get props => [markers, places, predictions, placeDetails];
}

class LoadingMapState extends MapState {
  final String loadingMessage;

  const LoadingMapState(
      {String? loadingMessage,
      super.cameraPosition,
      super.distanceMatrixResponse,
      super.markers,
      super.places,
      super.predictions})
      : loadingMessage = loadingMessage ?? 'Loading map locations...';
}

class ResultMapState extends MapState {
  const ResultMapState({
    super.distanceMatrixResponse,
    super.markers,
    super.cameraPosition,
    super.places,
    super.predictions,
  });
}

class ErrorMapState extends MapState {
  const ErrorMapState(this.errorMessage, this.errorCode);

  final String errorMessage;
  final String errorCode;

  @override
  List<Object?> get props =>
      [errorMessage, errorCode, super.markers, super.cameraPosition];
}

class ResultDistanceMatrixState extends MapState {
  const ResultDistanceMatrixState(
      {super.distanceMatrixResponse,
      super.markers,
      super.cameraPosition,
      super.places});
}
