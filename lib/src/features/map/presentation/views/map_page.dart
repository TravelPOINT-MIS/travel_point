import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:travel_point/core/type/type_def.dart';
import 'package:travel_point/core/widgets/error_snackbar.dart';
import 'package:travel_point/src/features/map/presentation/bloc/map_bloc.dart';
import 'package:travel_point/src/features/map/presentation/bloc/map_event.dart';
import 'package:travel_point/src/features/map/presentation/bloc/map_state.dart';

class MapPage extends StatefulWidget {
  final MapPageType activeMapPageTab;

  const MapPage({Key? key, required this.activeMapPageTab}) : super(key: key);

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  GoogleMapController? _googleMapController;
  String radius = "10000";

  @override
  void dispose() {
    _googleMapController?.dispose();
    super.dispose();
  }

  void handleCurrentLocationClick() {
    final mapBloc = BlocProvider.of<MapBloc>(context);
    const mapEvent = GetCurrentLocationEvent();
    mapBloc.add(mapEvent);
  }

  void handleCurrentLocationNearbyPlacesClick(context) {
    final mapBloc = BlocProvider.of<MapBloc>(context);
    const mapEvent = GetCurrentLocationNearbyPlacesEvent(
        radius: 10000, types: [PlaceType.bar]);
    mapBloc.add(mapEvent);
    // ERROR - TO BE FIXED
    // showDialog(
    //     context: context,
    //     builder: (context) {
    //       return LocationTypeSelectionDialog(
    //         onTypesSelected: (selectedTypes) {
    //
    //         },
    //       );
    //     });
  }

  void updateCameraPosition(CameraPosition cameraPosition) {
    if (_googleMapController != null) {
      _googleMapController!
          .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
    }
  }

  Widget defaultScreen(MapState state) {
    return AbsorbPointer(
      absorbing: state is LoadingMapState,
      child: Scaffold(
        body: GoogleMap(
          myLocationButtonEnabled: false,
          zoomControlsEnabled: false,
          initialCameraPosition: state.cameraPosition,
          mapType: MapType.normal,
          markers: state.markers,
          onMapCreated: (controller) {
            _googleMapController = controller;
          },
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(left: 30.0),
          child: Align(
            alignment: Alignment.bottomLeft,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                widget.activeMapPageTab == MapPageType.ExploreMap
                    ? FloatingActionButton.extended(
                        backgroundColor: Theme.of(context).primaryColor,
                        foregroundColor: Colors.white,
                        onPressed: handleCurrentLocationClick,
                        label: const Text("Current location"),
                        icon: const Icon(Icons.location_history),
                      )
                    : const Center(),
                const SizedBox(height: 16),
                widget.activeMapPageTab == MapPageType.FindHomeMap
                    ? FloatingActionButton.extended(
                        backgroundColor: Theme.of(context).primaryColor,
                        foregroundColor: Colors.white,
                        onPressed: () =>
                            handleCurrentLocationNearbyPlacesClick(context),
                        label: const Text("Get Nearby Places"),
                        icon: const Icon(Icons.place),
                      )
                    : const Center(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MapBloc, MapState>(builder: (_, state) {
      if (state is ResultMapState) {
        updateCameraPosition(state.cameraPosition);
      }

      return Stack(
        children: [
          AbsorbPointer(
            absorbing: state is LoadingMapState,
            child: defaultScreen(state),
          ),
          if (state is LoadingMapState)
            const AlertDialog(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text("Loading map locations..."),
                ],
              ),
            ),
          if (state is ErrorMapState)
            ErrorSnackbarWidget(
              errorCode: state.errorCode,
              errorMessage: state.errorMessage,
              context: context,
            )
        ],
      );
    });
  }
}
