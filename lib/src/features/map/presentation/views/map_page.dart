import 'package:flutter/material.dart';import 'package:flutter_bloc/flutter_bloc.dart';import 'package:geolocator/geolocator.dart';import 'package:google_maps_flutter/google_maps_flutter.dart';import 'package:google_maps_webservice/places.dart';import 'package:travel_point/core/type/type_def.dart';import 'package:travel_point/core/widgets/details_sidebar_markers.dart';import 'package:travel_point/core/widgets/error_snackbar.dart';import 'package:travel_point/core/widgets/get_nearby_places_form.dart';import 'package:travel_point/core/widgets/loading_dialog.dart';import 'package:travel_point/src/features/map/data/models/distance_matrix_response.dart';import 'package:travel_point/src/features/map/presentation/bloc/map_bloc.dart';import 'package:travel_point/src/features/map/presentation/bloc/map_event.dart';import 'package:travel_point/src/features/map/presentation/bloc/map_state.dart';class MapPage extends StatefulWidget {  final MapPageType activeMapPageTab;  const MapPage({Key? key, required this.activeMapPageTab}) : super(key: key);  @override  _MapPageState createState() => _MapPageState();}class _MapPageState extends State<MapPage> {  GoogleMapController? _googleMapController;  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();  bool isDrawerOpen = false;  final _searchController = TextEditingController();  bool isModalOpen = false;  @override  void dispose() {    _googleMapController?.dispose();    super.dispose();  }  void handleCurrentLocationClick() {    final mapBloc = BlocProvider.of<MapBloc>(context);    const mapEvent = GetCurrentLocationEvent();    mapBloc.add(mapEvent);  }  void handleCurrentLocationNearbyPlacesClick(      BuildContext context, BuildContext mapContext) {    showDialog(      context: context,      builder: (context) {        return NearbyPlacesFormDialog(          onTypesSelected: (selectedTypes, number) {            final mapBloc = BlocProvider.of<MapBloc>(mapContext);            mapBloc.add(GetCurrentLocationNearbyPlacesEvent(              radius: number!.toInt(),              types: selectedTypes,            ));            Navigator.of(context).pop();          },        );      },    );  }  void showDistanceMatrixResponse(      BuildContext context, DistanceMatrixResponse distanceMatrixResponse) {    if (isModalOpen) {      // Do not open another modal if one is already open      return;    }    isModalOpen = true;    showModalBottomSheet<void>(      context: context,      builder: (context) {        return SizedBox(          child: Padding(            padding: const EdgeInsets.only(top: 10.0),            child: ListView.builder(              itemCount: distanceMatrixResponse.destinationAddresses.length,              itemBuilder: (BuildContext context, int index) {                final String destinationAddress =                    distanceMatrixResponse.destinationAddresses[index];                final String originAddress =                    distanceMatrixResponse.originAddresses[0];                final DistanceMatrixRow row = distanceMatrixResponse.rows[0];                return Column(                  crossAxisAlignment: CrossAxisAlignment.start,                  children: <Widget>[                    ListTile(                      title: Text('$destinationAddress'),                      subtitle: Text('Origin Address: $originAddress'),                    ),                    ListTile(                      title: Text('Status: ${row.elements[index].status}'),                    ),                    ListTile(                      title: Text(                          'Duration: ${row.elements[index].duration.text}'),                      subtitle: Text(                          'Distance: ${row.elements[index].distance.text}'),                    ),                    const Divider(                      thickness: 2,                    ),                    // Add a divider to separate entries                  ],                );              },            ),          ),        );      },    ).then((_) {      // Reset the flag when the modal is closed      isModalOpen = false;      final mapBloc = BlocProvider.of<MapBloc>(context);      const mapEvent = ResetStateToInitialEvent();      mapBloc.add(mapEvent);    });  }  void handleGetDistanceForNearbyPlaces(BuildContext context) {    showModalBottomSheet<void>(      context: context,      builder: (context) {        return Column(          mainAxisSize: MainAxisSize.min,          children: <Widget>[            ListTile(              title: const Text('Driving'),              onTap: () {                Navigator.pop(context);                sendEvent(TravelModeEnum.driving);              },            ),            ListTile(              title: const Text('Walking'),              onTap: () {                Navigator.pop(context);                sendEvent(TravelModeEnum.walking);              },            ),            ListTile(              title: const Text('Bicycling'),              onTap: () {                Navigator.pop(context);                sendEvent(TravelModeEnum.bicycling);              },            ),          ],        );      },    );  }  void sendEvent(TravelModeEnum selectedMode) {    final mapBloc = BlocProvider.of<MapBloc>(context);    final mapEvent = GetDistanceForNearbyPlacesEvent(travelMode: selectedMode);    mapBloc.add(mapEvent);  }  void updateCameraPosition(CameraPosition cameraPosition) {    if (_googleMapController != null) {      _googleMapController!          .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));    }  }  void handleClearResultMapState() {    final mapBloc = BlocProvider.of<MapBloc>(context);    final mapEvent = ClearResultMapStateEvent();    mapBloc.add(mapEvent);  }  void showNearbyPlacesDialog(      BuildContext context, BuildContext mapContext, Position position) {    if (!isDrawerOpen) {      showDialog(        context: context,        builder: (context) => NearbyPlacesFormDialog(          onTypesSelected: (selectedTypes, number) {            final mapBloc = BlocProvider.of<MapBloc>(mapContext);            mapBloc.add(GetChosenLocationNearbyPlacesEvent(              radius: number!.toInt(),              types: selectedTypes,              position: position,            ));            Navigator.of(context).pop();          },        ),      );    }  }  void handleOnLocationItemTap(BuildContext context, BuildContext mapContext,      PlaceDetails placeDetails) {    if (placeDetails.geometry != null) {      final location = LatLng(placeDetails.geometry!.location.lat,          placeDetails.geometry!.location.lng);      final position = Position(        latitude: location.latitude,        longitude: location.longitude,        accuracy: 5.0,        altitude: 5.0,        heading: 0.0,        speed: 0.012158378027379513,        speedAccuracy: 0.5,        timestamp: DateTime.now(),      );      Future.delayed(Duration.zero, () {        showNearbyPlacesDialog(context, mapContext, position);      });    }  }  Future<void> callGetPlaceFromPlaceIdEvent(MapState state, String placeId,      BuildContext context, BuildContext mapContext) async {    // final places = GoogleMapsPlaces(apiKey: API_KEY);    // final placeDetails = await places.getDetailsByPlaceId(placeId);    final mapBloc = BlocProvider.of<MapBloc>(mapContext);    mapBloc.add(GetPlaceFromPlaceIdEvent(placeId: placeId));  }  Widget defaultScreen(MapState state, mapContext) {    return Stack(      children: [        Scaffold(          key: _scaffoldKey,          onDrawerChanged: (drawer) {            setState(() {              isDrawerOpen = drawer;            });          },          drawer: DetailsSidebarMarkers(              scaffoldKey: _scaffoldKey,              updateCameraPosition: updateCameraPosition,              places: state.places),          body: Stack(            children: [              GoogleMap(                myLocationButtonEnabled: false,                zoomControlsEnabled: false,                initialCameraPosition: state.cameraPosition,                mapType: MapType.normal,                markers: state.markers,                onMapCreated: (controller) {                  _googleMapController = controller;                },              ),              if (widget.activeMapPageTab == MapPageType.ExploreMap)                Column(                  children: [                    TextField(                      controller: _searchController,                      decoration: const InputDecoration(                        hintText: 'Search for places',                        filled: true,                        fillColor: Colors.white,                        border: OutlineInputBorder(                          borderSide: BorderSide.none,                        ),                        focusedBorder: OutlineInputBorder(                          borderSide: BorderSide.none,                        ),                      ),                      onChanged: (text) {                        if (text == '') {                          FocusScope.of(context).unfocus();                        }                        final mapBloc = BlocProvider.of<MapBloc>(mapContext);                        mapBloc.add(GetPredictionsFromAutocompleteEvent(                          inputSearchText: _searchController.text,                        ));                      },                    ),                    if (state is InitialMapState &&                        state.predictions.isNotEmpty &&                        _searchController.text != '')                      Container(                        height: 300,                        color: Colors.white,                        child: ListView.builder(                          key: const Key('prediction_list'),                          itemCount: state.predictions.length,                          itemBuilder: (context, index) {                            final prediction = state.predictions[index];                            return ListTile(                              title: Text(prediction.description!),                              onTap: () {                                callGetPlaceFromPlaceIdEvent(state,                                    prediction.placeId!, context, mapContext);                                _searchController.clear();                                FocusScope.of(context).unfocus();                              },                            );                          },                        ),                      )                  ],                )            ],          ),          floatingActionButton: widget.activeMapPageTab ==                      MapPageType.NearByMap ||                  widget.activeMapPageTab == MapPageType.ExploreMap              ? Padding(                  padding: const EdgeInsets.only(left: 30.0),                  child: Align(                    alignment: Alignment.bottomRight,                    child: Row(                      mainAxisAlignment: MainAxisAlignment.end,                      children: [                        if (state.markers.isNotEmpty)                          FloatingActionButton(                            onPressed: () =>                                handleGetDistanceForNearbyPlaces(context),                            backgroundColor: Theme.of(context).primaryColor,                            foregroundColor: Colors.white,                            child: const Icon(Icons.directions_walk),                          ),                        if (state.markers.isNotEmpty &&                            widget.activeMapPageTab == MapPageType.NearByMap)                          const SizedBox(width: 16),                        if (widget.activeMapPageTab == MapPageType.NearByMap)                          FloatingActionButton(                            backgroundColor: Theme.of(context).primaryColor,                            foregroundColor: Colors.white,                            onPressed: () =>                                handleCurrentLocationNearbyPlacesClick(                                    context, mapContext),                            child: const Icon(Icons.search),                          ),                        if (widget.activeMapPageTab == MapPageType.NearByMap)                          const SizedBox(width: 16),                        if (widget.activeMapPageTab == MapPageType.NearByMap)                          FloatingActionButton(                            backgroundColor: Theme.of(context).primaryColor,                            foregroundColor: Colors.white,                            onPressed: handleCurrentLocationClick,                            child: const Icon(Icons.location_on),                          ),                      ],                    ),                  ),                )              : const Center(),        ),        if ((state.markers.isNotEmpty &&                widget.activeMapPageTab == MapPageType.NearByMap) ||            (state.markers.isNotEmpty &&                    widget.activeMapPageTab == MapPageType.ExploreMap) &&                _searchController.text == '')          Positioned(              top: widget.activeMapPageTab == MapPageType.ExploreMap                  ? isDrawerOpen                      ? 5                      : 65                  : 5,              left: isDrawerOpen ? null : 5,              right: isDrawerOpen ? 5 : null,              child: ElevatedButton(                onPressed: () {                  if (_scaffoldKey.currentState?.isDrawerOpen ?? false) {                    _scaffoldKey.currentState?.closeDrawer();                    setState(() {                      isDrawerOpen = false;                    });                  } else {                    _scaffoldKey.currentState?.openDrawer();                    setState(() {                      isDrawerOpen = true;                      _searchController.clear();                      FocusScope.of(context).unfocus();                    });                  }                },                style: ElevatedButton.styleFrom(                  backgroundColor: Theme.of(context).primaryColor,                  shape: RoundedRectangleBorder(                    borderRadius: BorderRadius.circular(10),                  ),                ),                child: Padding(                  padding: const EdgeInsets.all(3.0),                  child: isDrawerOpen                      ? const Icon(                          Icons.close_rounded,                          color: Colors.white,                        )                      : const Icon(                          Icons.read_more,                          color: Colors.white,                        ),                ),              )),      ],    );  }  @override  Widget build(BuildContext context) {    return BlocBuilder<MapBloc, MapState>(builder: (mapContext, state) {      if (state is ResultMapState && isDrawerOpen == false) {        updateCameraPosition(state.cameraPosition);        handleClearResultMapState();      }      if (state is ResultDistanceMatrixState &&          state.distanceMatrixResponse != null &&          isDrawerOpen == false) {        Future.delayed(Duration.zero, () {          showDistanceMatrixResponse(context, state.distanceMatrixResponse!);        });      }      if (state is InitialMapState && state.placeDetails.placeId != '') {        final placeDetails = state.placeDetails;        if (placeDetails.geometry != null) {          handleOnLocationItemTap(context, mapContext, placeDetails);        }      }      return Stack(        children: [          AbsorbPointer(              absorbing: state is LoadingMapState,              child: Column(                children: [                  Expanded(                    child: defaultScreen(state, mapContext),                  ),                ],              )),          if (state is LoadingMapState)            LoadingDialog(message: state.loadingMessage),          if (state is ErrorMapState)            ErrorSnackbarWidget(              errorCode: state.errorCode,              errorMessage: state.errorMessage,              context: context,            )        ],      );    });  }}