import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';

abstract class MapState extends Equatable {
  const MapState();

  @override
  List<Object?> get props => [];
}

class InitialMapState extends MapState {
  const InitialMapState();
}

class LoadingMapState extends MapState {
  const LoadingMapState();
}

class ResultMapState extends MapState {
  const ResultMapState(this.position);

  final Position position;

  @override
  List<Object?> get props => [position];
}

class ErrorMapState extends MapState {
  const ErrorMapState(this.errorMessage, this.errorCode);

  final String errorMessage;
  final String errorCode;

  @override
  List<Object?> get props => [errorMessage, errorCode];
}
