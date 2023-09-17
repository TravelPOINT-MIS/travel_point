import 'package:bloc/bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:travel_point/core/constants/constants.dart';
import 'package:travel_point/src/features/map/data/models/place_model.dart';
import 'package:travel_point/src/features/map/domain/usecase/get_distance_nearby_places.dart';
import 'package:travel_point/src/features/map/domain/usecase/get_nearby_places.dart';
import 'package:travel_point/src/features/map/domain/usecase/get_place_details.dart';
import 'package:travel_point/src/features/map/domain/usecase/get_search_autocomplete_predictions.dart';
import 'package:travel_point/src/features/map/domain/usecase/get_user_current_location.dart';
import 'package:travel_point/src/features/map/presentation/bloc/map_event.dart';
import 'package:travel_point/src/features/map/presentation/bloc/map_state.dart';
import 'package:travel_point/src/features/map/data/models/nearby_places_response.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  final GetUserCurrentLocationUsecase _getUserCurrentLocationUsecase;
  final GetNearbyPlacesUsecase _getNearbyPlacesUsecase;
  final GetDistanceForNearbyPlacesUsecase _getDistanceForNearbyPlaces;
  final GetSearchAutocompleteUsecase _getPredictionsFromAutocompleteUseCase;
  final GetPlaceDetailsUsecase _getPlaceDetailsUsecase;

  MapBloc(
      this._getUserCurrentLocationUsecase,
      this._getNearbyPlacesUsecase,
      this._getDistanceForNearbyPlaces,
      this._getPredictionsFromAutocompleteUseCase,
      this._getPlaceDetailsUsecase)
      : super(InitialMapState()) {
    on<GetCurrentLocationEvent>(_getUserCurrentLocationHandler);
    on<GetCurrentLocationNearbyPlacesEvent>(_getCurrentNearbyPlacesHandler);
    on<ClearMarkersEvent>(_handleClearMarkers);
    on<ClearResultMapStateEvent>(_clearResultMapStateEvent);
    on<GetPredictionsFromAutocompleteEvent>(_getAutocompletePredictionsHandler);
    on<GetDistanceForNearbyPlacesEvent>(_handleGetDistanceForNearbyPlaces);
    on<GetChosenLocationNearbyPlacesEvent>(
        _getNearbyPlacesFromChosenLocationHandler);
    on<GetPlaceFromPlaceIdEvent>(_getPlaceDetailsHandler);
    on<ResetStateToInitialEvent>(_handleResetStateToInitial);
  }

  Future<void> _handleClearMarkers(
      ClearMarkersEvent event, Emitter<MapState> emitter) async {
    emit(const LoadingMapState());

    emit(InitialMapState(cameraPosition: event.keepSameCameraPosition));
  }

  Future<void> _handleResetStateToInitial(
      ResetStateToInitialEvent event, Emitter<MapState> emitter) async {
    emit(InitialMapState(
      markers: state.markers,
      cameraPosition: state.cameraPosition,
      places: state.places,
    ));
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
        markerId: const MarkerId(CURRENT_MARKER_ID),
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
            markerId: const MarkerId(CURRENT_MARKER_ID),
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

  Future<void> _getNearbyPlacesFromChosenLocationHandler(
      GetChosenLocationNearbyPlacesEvent event,
      Emitter<MapState> emitter) async {
    emit(const LoadingMapState(loadingMessage: 'Loading nearby places..'));
    CameraPosition? cameraPosition;
    Set<Marker> markers = {};
    List<PlaceModel> places = [];

    final resultCurrentLocation = await _getUserCurrentLocationUsecase();

    final result = await _getNearbyPlacesUsecase(GetNearbyPlacesParams(
        fromPosition: event.position,
        radius: event.radius,
        types: event.types));

    result.fold(
      (failure) {
        emit(ErrorMapState(failure.errorMessage, failure.errorCode));
        return;
      },
      (nearbyPlace) {
        cameraPosition = CameraPosition(
            target: LatLng(
              event.position.latitude,
              event.position.longitude,
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
          markerId: const MarkerId(CURRENT_MARKER_ID),
          position: LatLng(event.position.latitude, event.position.longitude),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        );

        markers.add(currentLocationMarker);

        emit(ResultMapState(
            markers: markers, cameraPosition: cameraPosition, places: places));
      },
    );
  }

  Future<void> _clearResultMapStateEvent(
      ClearResultMapStateEvent event, Emitter<MapState> emitter) async {
    emit(InitialMapState(
      markers: state.markers,
      cameraPosition: state.cameraPosition,
      places: state.places,
    ));
  }

  Future<void> _getAutocompletePredictionsHandler(
      GetPredictionsFromAutocompleteEvent event,
      Emitter<MapState> emitter) async {
    final result =
        await _getPredictionsFromAutocompleteUseCase(event.inputSearchText);

    result.fold(
      (failure) {
        emit(ErrorMapState(failure.errorMessage, failure.errorCode));
      },
      (predictions) {
        final updatedState = InitialMapState(
          markers: state.markers,
          cameraPosition: state.cameraPosition,
          places: state.places,
          predictions: predictions,
        );

        emit(updatedState);
      },
    );
  }

  Future<void> _getPlaceDetailsHandler(
      GetPlaceFromPlaceIdEvent event, Emitter<MapState> emitter) async {
    final result = await _getPlaceDetailsUsecase(event.placeId);

    result.fold(
      (failure) {
        emit(ErrorMapState(failure.errorMessage, failure.errorCode));
      },
      (placeDetails) {
        emit(InitialMapState(placeDetails: placeDetails));
      },
    );
  }

  Future<void> _handleGetDistanceForNearbyPlaces(
      GetDistanceForNearbyPlacesEvent event, Emitter<MapState> emitter) async {
    final Set<Marker> markersShownOnMap = state.markers;
    final List<PlaceModel> nearbyPlaces = state.places;
    final CameraPosition cameraPosition = state.cameraPosition;

    emit(LoadingMapState(
        loadingMessage: 'Getting distance for nearby places..',
        markers: markersShownOnMap,
        places: nearbyPlaces,
        cameraPosition: cameraPosition));

    final LatLng currentLocation = markersShownOnMap
        .firstWhere(
            (marker) => marker.markerId == const MarkerId(CURRENT_MARKER_ID))
        .position;

    final result = await _getDistanceForNearbyPlaces(
        GetDistanceNearbyPlacesParams(
            destinationAddresses: nearbyPlaces,
            originAddress: currentLocation,
            travelMode: event.travelMode));

    result.fold(
        (failure) =>
            emit(ErrorMapState(failure.errorMessage, failure.errorCode)),
        (result) {
      emit(ResultDistanceMatrixState(
          markers: markersShownOnMap,
          cameraPosition: cameraPosition,
          distanceMatrixResponse: result,
          places: nearbyPlaces));
    });
  }
}
