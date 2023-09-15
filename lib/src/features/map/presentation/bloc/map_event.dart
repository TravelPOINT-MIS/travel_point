import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:travel_point/core/type/type_def.dart';

abstract class MapEvent extends Equatable {
  const MapEvent();

  @override
  List<Object?> get props => [];
}

class GetCurrentLocationEvent extends MapEvent {
  const GetCurrentLocationEvent();
}

class GetCurrentLocationNearbyPlacesEvent extends MapEvent {
  final int radius;
  final List<PlaceType> types;

  @override
  List<Object?> get props => [radius, types];

  const GetCurrentLocationNearbyPlacesEvent(
      {required this.radius, required this.types});
}

class ClearMarkersEvent extends MapEvent {
  final CameraPosition? keepSameCameraPosition;

  const ClearMarkersEvent({this.keepSameCameraPosition});
}

class ClearResultMapStateEvent extends MapEvent {}

class GetPredictionsFromAutocompleteEvent extends MapEvent {
  final String inputSearchText;

  @override
  List<Object?> get props => [inputSearchText];

  const GetPredictionsFromAutocompleteEvent({required this.inputSearchText});
}
