import 'package:flutter/material.dart';import 'package:flutter_bloc/flutter_bloc.dart';import 'package:google_maps_flutter/google_maps_flutter.dart';import 'package:travel_point/core/type/type_def.dart';import 'package:travel_point/core/widgets/error_snackbar.dart';import 'package:travel_point/core/widgets/get_nearby_places_form.dart';import 'package:travel_point/core/widgets/loading_dialog.dart';import 'package:travel_point/src/features/map/presentation/bloc/map_bloc.dart';import 'package:travel_point/src/features/map/presentation/bloc/map_event.dart';import 'package:travel_point/src/features/map/presentation/bloc/map_state.dart';class MapPage extends StatefulWidget {  final MapPageType activeMapPageTab;  const MapPage({Key? key, required this.activeMapPageTab}) : super(key: key);  @override  _MapPageState createState() => _MapPageState();}class _MapPageState extends State<MapPage> {  GoogleMapController? _googleMapController;  String radius = "10000";  bool isMarkersListExpanded = false;  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();  @override  void dispose() {    _googleMapController?.dispose();    super.dispose();  }  void handleCurrentLocationClick() {    final mapBloc = BlocProvider.of<MapBloc>(context);    const mapEvent = GetCurrentLocationEvent();    mapBloc.add(mapEvent);  }  void handleCurrentLocationNearbyPlacesClick(mapContext) {    showDialog(      context: context,      builder: (context) {        return NearbyPlacesFormDialog(          onTypesSelected: (selectedTypes, number) {            final mapBloc = BlocProvider.of<MapBloc>(mapContext);            final mapEvent = GetCurrentLocationNearbyPlacesEvent(              radius: 10000,              types: selectedTypes,            );            mapBloc.add(mapEvent);            Navigator.of(context).pop();          },        );      },    );  }  void updateCameraPosition(CameraPosition cameraPosition) {    if (_googleMapController != null) {      _googleMapController!          .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));    }  }  Widget defaultScreen(MapState state, mapContext) {    return Stack(      children: [        Scaffold(          key: _scaffoldKey,          onDrawerChanged: (drawer) {            setState(() {});          },          drawer: Drawer(            child: ListView.separated(              itemCount: state.places.length,              separatorBuilder: (context, index) => const Divider(                color: Colors.grey,                height: 1.0,              ),              itemBuilder: (context, index) {                final place = state.places[index];                return ListTile(                  title: Text(place.name),                );              },            ),          ),          body: Row(            children: [              Expanded(                child: GoogleMap(                  myLocationButtonEnabled: false,                  zoomControlsEnabled: false,                  initialCameraPosition: state.cameraPosition,                  mapType: MapType.normal,                  markers: state.markers,                  onMapCreated: (controller) {                    _googleMapController = controller;                  },                ),              ),            ],          ),          floatingActionButton: widget.activeMapPageTab == MapPageType.NearByMap              ? Padding(                  padding: const EdgeInsets.only(left: 30.0),                  child: Align(                    alignment: Alignment.bottomRight,                    child: Row(                      mainAxisAlignment: MainAxisAlignment.end,                      children: [                        FloatingActionButton(                          backgroundColor: Theme.of(context).primaryColor,                          foregroundColor: Colors.white,                          onPressed: () =>                              handleCurrentLocationNearbyPlacesClick(                                  mapContext),                          child: const Icon(Icons.search),                        ),                        const SizedBox(width: 16),                        FloatingActionButton(                          backgroundColor: Theme.of(context).primaryColor,                          foregroundColor: Colors.white,                          onPressed: handleCurrentLocationClick,                          child: const Icon(Icons.location_on),                        ),                      ],                    ),                  ),                )              : const Center(),        ),        if (state is ResultMapState &&            _scaffoldKey.currentState?.isDrawerOpen == false)          Positioned(              top: 5,              left: 5,              child: ElevatedButton(                onPressed: () => _scaffoldKey.currentState?.openDrawer(),                style: ElevatedButton.styleFrom(                  primary: Theme.of(context).primaryColor,                  shape: RoundedRectangleBorder(                    borderRadius: BorderRadius.circular(10),                  ),                ),                child: const Padding(                  padding: EdgeInsets.all(5.0), // Adjust padding as needed                  child: Icon(                    Icons.read_more,                    color: Colors.white,                  ),                ),              )),      ],    );  }  @override  Widget build(BuildContext context) {    return BlocBuilder<MapBloc, MapState>(builder: (mapContext, state) {      if (state is ResultMapState) {        updateCameraPosition(state.cameraPosition);      }      return Stack(        children: [          AbsorbPointer(              absorbing: state is LoadingMapState,              child: Column(                children: [                  Expanded(                    child: defaultScreen(state, mapContext),                  ),                ],              )),          if (state is LoadingMapState)            LoadingDialog(message: state.loadingMessage),          if (state is ErrorMapState)            ErrorSnackbarWidget(              errorCode: state.errorCode,              errorMessage: state.errorMessage,              context: context,            )        ],      );    });  }}