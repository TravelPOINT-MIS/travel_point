import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
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
  final Position fromPosition;
  final int radius;
  final PlaceType type;

  @override
  List<Object?> get props => [fromPosition, radius, type];

  const GetCurrentLocationNearbyPlacesEvent(
      {required this.fromPosition, required this.radius, required this.type});
}
