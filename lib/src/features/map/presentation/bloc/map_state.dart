import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

abstract class MapState extends Equatable {
  final CameraPosition cameraPosition;
  final Set<Marker> markers;

  const MapState({Set<Marker>? markers, CameraPosition? cameraPosition})
      : markers = markers ?? const {},
        cameraPosition = cameraPosition ??
            const CameraPosition(
              target: LatLng(41.555418, 22.349499),
              zoom: 7,
            );

  @override
  List<Object?> get props => [markers, cameraPosition];
}

class InitialMapState extends MapState {
  const InitialMapState();
}

class LoadingMapState extends MapState {
  const LoadingMapState();
}

class ResultMapState extends MapState {
  const ResultMapState({super.markers, super.cameraPosition});
}

class ErrorMapState extends MapState {
  const ErrorMapState(this.errorMessage, this.errorCode);

  final String errorMessage;
  final String errorCode;

  @override
  List<Object?> get props =>
      [errorMessage, errorCode, super.markers, super.cameraPosition];
}
