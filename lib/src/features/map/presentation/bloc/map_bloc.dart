import 'package:bloc/bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:travel_point/src/features/map/data/models/place_model.dart';
import 'package:travel_point/src/features/map/domain/usecase/get_nearby_places.dart';
import 'package:travel_point/src/features/map/domain/usecase/get_search_autocomplete_predictions.dart';
import 'package:travel_point/src/features/map/domain/usecase/get_user_current_location.dart';
import 'package:travel_point/src/features/map/presentation/bloc/map_event.dart';
import 'package:travel_point/src/features/map/presentation/bloc/map_state.dart';
import 'package:travel_point/src/features/map/data/models/nearby_places_response.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  final GetUserCurrentLocationUsecase _getUserCurrentLocationUsecase;
  final GetNearbyPlacesUsecase _getNearbyPlacesUsecase;
  final GetSearchAutocompleteUsecase _getPredictionsFromAutocompleteUseCase;

  MapBloc(this._getUserCurrentLocationUsecase, this._getNearbyPlacesUsecase,
      this._getPredictionsFromAutocompleteUseCase)
      : super(const InitialMapState()) {
    on<GetCurrentLocationEvent>(_getUserCurrentLocationHandler);
    on<GetCurrentLocationNearbyPlacesEvent>(_getCurrentNearbyPlacesHandler);
    on<ClearMarkersEvent>(_handleClearMarkers);
    on<ClearResultMapStateEvent>(_clearResultMapStateEvent);
    on<GetPredictionsFromAutocompleteEvent>(_getautocompletePredictionsHandler);
  }

  Future<void> _handleClearMarkers(
      ClearMarkersEvent event, Emitter<MapState> emitter) async {
    emit(InitialMapState(cameraPosition: event.keepSameCameraPosition));
  }

  Future<void> _getUserCurrentLocationHandler(
      GetCurrentLocationEvent event, Emitter<MapState> emitter) async {
    emit(const LoadingMapState(
        loadingMessage: 'Loading your current location..'));

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
    emit(const LoadingMapState(loadingMessage: 'Loading nearby places..'));
    CameraPosition? cameraPosition;
    Set<Marker> markers = {};
    List<PlaceModel> places = [];

    final resultCurrentLocation = await _getUserCurrentLocationUsecase();

    resultCurrentLocation.fold((failure) {
      emit(ErrorMapState(failure.errorMessage, failure.errorCode));
      return;
    }, (position) async {
      final result = await _getNearbyPlacesUsecase(GetNearbyPlacesParams(
          fromPosition: position, radius: event.radius, types: event.types));

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

                final place = PlaceModel(
                    name: result.name!,
                    rating: result.rating,
                    lat: result.geometry!.location!.lat ?? 0.0,
                    lng: result.geometry!.location!.lng ?? 0.0,
                    userRatingsTotal: result.userRatingsTotal,
                    placeId: result.placeId ?? '',
                    photos: result.photos,
                    openingHours: result.openingHours,
                    types: result.types);

                places.add(place);
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

          emit(ResultMapState(
              markers: markers,
              cameraPosition: cameraPosition,
              places: places));
        },
      );
    });
  }

  Future<void> _clearResultMapStateEvent(
      ClearResultMapStateEvent event, Emitter<MapState> emitter) async {
    emit(InitialMapState(
      markers: state.markers,
      cameraPosition: state.cameraPosition,
      places: state.places,
    ));
  }

  Future<void> _getautocompletePredictionsHandler(
      GetPredictionsFromAutocompleteEvent event, Emitter<MapState> emitter) async {
    final result = await _getPredictionsFromAutocompleteUseCase(event.inputSearchText);

    result.fold(
          (failure) {
            emit(ErrorMapState(failure.errorMessage, failure.errorCode));
      },
          (predictions) {
            emit(InitialMapState(predictions: predictions));
      },
    );
  }

}
