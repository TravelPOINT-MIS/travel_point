import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
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
  final BuildContext context;
  final int radius;
  final List<PlaceType> types;

  @override
  List<Object?> get props => [radius, types];

  const GetCurrentLocationNearbyPlacesEvent(
      {required this.radius, required this.types, required this.context});
}

class GetChosenLocationNearbyPlacesEvent extends MapEvent {
  final BuildContext context;
  final int radius;
  final Position position;
  final List<PlaceType> types;

  @override
  List<Object?> get props => [radius, types];

  const GetChosenLocationNearbyPlacesEvent(
      {required this.radius, required this.position, required this.types, required this.context});
}

class ClearMarkersEvent extends MapEvent {
  final CameraPosition? keepSameCameraPosition;

  const ClearMarkersEvent({this.keepSameCameraPosition});
}

class ClearResultMapStateEvent extends MapEvent {}

class GetDistanceForNearbyPlacesEvent extends MapEvent {
  final TravelModeEnum travelMode;

  const GetDistanceForNearbyPlacesEvent({required this.travelMode});
}

class GetPredictionsFromAutocompleteEvent extends MapEvent {
  final String inputSearchText;

  @override
  List<Object?> get props => [inputSearchText];

  const GetPredictionsFromAutocompleteEvent({required this.inputSearchText});
}

class GetPlaceFromPlaceIdEvent extends MapEvent {
  final String placeId;

  const GetPlaceFromPlaceIdEvent({required this.placeId});
}

class ResetStateToInitialEvent extends MapEvent {
  const ResetStateToInitialEvent();
}
