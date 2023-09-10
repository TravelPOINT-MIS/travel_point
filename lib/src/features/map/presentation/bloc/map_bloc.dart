import 'package:bloc/bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:travel_point/src/features/map/domain/usecase/get_nearby_places.dart';
import 'package:travel_point/src/features/map/domain/usecase/get_user_current_location.dart';
import 'package:travel_point/src/features/map/presentation/bloc/map_event.dart';
import 'package:travel_point/src/features/map/presentation/bloc/map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  final GetUserCurrentLocationUsecase _getUserCurrentLocationUsecase;
  final GetNearbyPlacesUsecase _getNearbyPlacesUsecase;

  MapBloc(this._getUserCurrentLocationUsecase, this._getNearbyPlacesUsecase)
      : super(const InitialMapState()) {
    on<GetCurrentLocationEvent>(_getUserCurrentLocationHandler);
    on<GetCurrentLocationNearbyPlacesEvent>(_getNearbyPlacesHandler);
  }

  Future<void> _getUserCurrentLocationHandler(
      GetCurrentLocationEvent event, Emitter<MapState> emitter) async {
    emit(const LoadingMapState());

    final result = await _getUserCurrentLocationUsecase();

    result.fold(
      (failure) => emit(ErrorMapState(failure.errorMessage, failure.errorCode)),
      (position) => emit(ResultMapState(position)),
    );
  }

  Future<void> _getNearbyPlacesHandler(
      GetCurrentLocationNearbyPlacesEvent event,
      Emitter<MapState> emitter) async {
    emit(const LoadingMapState());

    final result = await _getNearbyPlacesUsecase(GetNearbyPlacesParams(
        fromPosition: event.fromPosition,
        radius: event.radius,
        type: event.type));

    result.fold(
      (failure) => emit(ErrorMapState(failure.errorMessage, failure.errorCode)),
      (nearbyPlace) {
        // Create markers from nearbyPlaces here
        final markers = Set<Marker>.from(nearbyPlace.map((place) {
          return Marker(
            markerId: MarkerId(place.id.toString()), // Unique identifier for the marker
            position: LatLng(place.latitude, place.longitude), // Position of the marker
            // Add any other properties you need for the marker here
          );
        }));

        // Emit the updated state with the markers
        emit(ResultMapState(event.fromPosition, markers));
      },
    );
  }
}
