import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:travel_point/src/features/map/data/models/place_model.dart';

abstract class MapState extends Equatable {
  final CameraPosition cameraPosition;
  final Set<Marker> markers;
  final List<PlaceModel> places;
  final bool? isSidebarOpen;

  const MapState(
      {Set<Marker>? markers,
      CameraPosition? cameraPosition,
      List<PlaceModel>? places,
      bool? isSidebarOpen})
      : markers = markers ?? const {},
        cameraPosition = cameraPosition ??
            const CameraPosition(
              target: LatLng(41.555418, 22.349499),
              zoom: 7,
            ),
        places = places ?? const [],
        isSidebarOpen = isSidebarOpen ?? false;

  @override
  List<Object?> get props => [markers, cameraPosition, places, isSidebarOpen];
}

class InitialMapState extends MapState {
  const InitialMapState({super.markers, super.cameraPosition, super.places});
}

class LoadingMapState extends MapState {
  final String loadingMessage;

  const LoadingMapState({String? loadingMessage})
      : loadingMessage = loadingMessage ?? 'Loading map locations...';
}

class ResultMapState extends MapState {
  const ResultMapState(
      {super.markers, super.cameraPosition, super.places, super.isSidebarOpen});
}

class ErrorMapState extends MapState {
  const ErrorMapState(this.errorMessage, this.errorCode);

  final String errorMessage;
  final String errorCode;

  @override
  List<Object?> get props =>
      [errorMessage, errorCode, super.markers, super.cameraPosition];
}
