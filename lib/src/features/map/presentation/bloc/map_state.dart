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

  const MapState(
      {this.distanceMatrixResponse,
      Set<Marker>? markers,
      CameraPosition? cameraPosition,
      List<PlaceModel>? places})
      : markers = markers ?? const {},
        cameraPosition = cameraPosition ??
            const CameraPosition(
              target: LatLng(41.555418, 21.77),
              zoom: 7.7,
            ),
        places = places ?? const [];

  @override
  List<Object?> get props => [markers, cameraPosition, places];
}

class InitialMapState extends MapState {
  final List<Prediction> predictions;
  final PlaceDetails placeDetails;

  InitialMapState({
    super.markers,
    super.cameraPosition,
    super.places,
    List<Prediction>? predictions,
    PlaceDetails? placeDetails,
  })  : predictions = predictions ?? const [],
        placeDetails = placeDetails ?? PlaceDetails(name: '', placeId: '');

  @override
  List<Object?> get props => [predictions, placeDetails];
}

class LoadingMapState extends MapState {
  final String loadingMessage;

  const LoadingMapState({String? loadingMessage})
      : loadingMessage = loadingMessage ?? 'Loading map locations...';
}

class ResultMapState extends MapState {
  const ResultMapState(
      {super.distanceMatrixResponse,
      super.markers,
      super.cameraPosition,
      super.places});
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
