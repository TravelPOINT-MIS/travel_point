import 'package:equatable/equatable.dart';
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
  final List<PlaceType> type;

  @override
  List<Object?> get props => [radius, type];

  const GetCurrentLocationNearbyPlacesEvent(
      {required this.radius, required this.type});
}
