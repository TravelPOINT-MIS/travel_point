import 'package:bloc/bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:travel_point/src/features/map/domain/usecase/get_nearby_places.dart';
import 'package:travel_point/src/features/map/domain/usecase/get_user_current_location.dart';
import 'package:travel_point/src/features/map/presentation/bloc/map_event.dart';
import 'package:travel_point/src/features/map/presentation/bloc/map_state.dart';
import 'package:travel_point/src/model/nearby_places_response.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  final GetUserCurrentLocationUsecase _getUserCurrentLocationUsecase;
  final GetNearbyPlacesUsecase _getNearbyPlacesUsecase;

  MapBloc(this._getUserCurrentLocationUsecase, this._getNearbyPlacesUsecase)
      : super(const InitialMapState()) {
    on<GetCurrentLocationEvent>(_getUserCurrentLocationHandler);
    on<GetCurrentLocationNearbyPlacesEvent>(_getCurrentNearbyPlacesHandler);
  }

  Future<void> _getUserCurrentLocationHandler(
      GetCurrentLocationEvent event, Emitter<MapState> emitter) async {
    emit(const LoadingMapState());

    final result = await _getUserCurrentLocationUsecase();

    result.fold(
        (failure) =>
            emit(ErrorMapState(failure.errorMessage, failure.errorCode)),
        (position) {
      CameraPosition cameraPosition = CameraPosition(
          target: LatLng(position.latitude, position.longitude), zoom: 12);

      final currentLocationMarker = Marker(
        markerId: const MarkerId('current-position-id'),
        position: LatLng(position.latitude, position.longitude),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      );

      final Set<Marker> markers = {currentLocationMarker};

      emit(ResultMapState(markers: markers, cameraPosition: cameraPosition));
    });
  }

  Future<void> _getCurrentNearbyPlacesHandler(
      GetCurrentLocationNearbyPlacesEvent event,
      Emitter<MapState> emitter) async {
    emit(const LoadingMapState());
    CameraPosition? cameraPosition;
    Set<Marker> markers = {};

    final resultCurrentLocation = await _getUserCurrentLocationUsecase();

    resultCurrentLocation.fold((failure) {
      emit(ErrorMapState(failure.errorMessage, failure.errorCode));
      return;
    }, (position) async {
      final result = await _getNearbyPlacesUsecase(GetNearbyPlacesParams(
          fromPosition: position, radius: event.radius, type: event.type));

      result.fold(
        (failure) {
          emit(ErrorMapState(failure.errorMessage, failure.errorCode));
          return;
        },
        (nearbyPlace) {
          cameraPosition = CameraPosition(
              target: LatLng(
                position.latitude,
                position.longitude,
              ),
              zoom: 12);

          final nearbyPlaceResult = nearbyPlace.results;

          if (nearbyPlaceResult != null) {
            for (Results result in nearbyPlaceResult) {
              if (result.geometry != null &&
                  result.geometry!.location != null &&
                  result.name != null) {
                markers.add(
                  Marker(
                    markerId: MarkerId(result.placeId ?? ''),
                    position: LatLng(
                      result.geometry!.location!.lat ?? 0.0,
                      result.geometry!.location!.lng ?? 0.0,
                    ),
                    infoWindow: InfoWindow(title: result.name ?? ""),
                  ),
                );
              }
            }
          }

          final currentLocationMarker = Marker(
            markerId: const MarkerId('current-position-id'),
            position: LatLng(position.latitude, position.longitude),
            icon:
                BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          );

          markers.add(currentLocationMarker);

          emit(
              ResultMapState(markers: markers, cameraPosition: cameraPosition));
        },
      );
    });
  }
}
