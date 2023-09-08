import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:travel_point/src/features/map/presentation/bloc/map_bloc.dart';
import 'package:travel_point/src/features/map/presentation/bloc/map_event.dart';
import 'package:travel_point/src/features/map/presentation/bloc/map_state.dart';
import 'package:travel_point/src/model/nearby_places_response.dart';
import 'package:travel_point/core/constants/constants.dart';

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  static const _initialCameraPosition = CameraPosition(
    target: LatLng(37.773972, -122.431297),
    zoom: 11.5,
  );

  Set<Marker> markers = {};

  late GoogleMapController _googleMapController;

  String radius = "10000";
  NearbyPlacesResponse nearbyPlacesResponse = NearbyPlacesResponse();

  @override
  void dispose() {
    _googleMapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MapBloc, MapState>(builder: (_, state) {
      return Scaffold(
        body: GoogleMap(
          myLocationButtonEnabled: false,
          zoomControlsEnabled: true,
          initialCameraPosition: _initialCameraPosition,
          mapType: MapType.normal,
          markers: markers,
          onMapCreated: (controller) => _googleMapController = controller,
        ),
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton.extended(
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.white,
              onPressed: () async {
                final mapBloc = BlocProvider.of<MapBloc>(context);

                const mapEvent = GetCurrentLocationEvent();
                mapBloc.add(mapEvent);
                if (state is ResultMapState) {
                  final position = state.position;
                  // _positionCamera(position);

                  _googleMapController.animateCamera(
                    CameraUpdate.newCameraPosition(
                      CameraPosition(
                        target: LatLng(position.latitude, position.longitude),
                        zoom: 18,
                      ),
                    ),
                  );

                  markers.clear();
                  markers.add(Marker(
                    markerId: const MarkerId('currentLocation'),
                    position: LatLng(position.latitude, position.longitude),
                    infoWindow:
                        const InfoWindow(title: "This is your location!"),
                  ));

                  setState(() {});
                  // Use the position here for your UI logic
                }
              },
              label: const Text("Current location"),
              icon: const Icon(Icons.location_history),
            ),
            const SizedBox(height: 16),
            // FloatingActionButton.extended(
            //   backgroundColor: Theme
            //       .of(context)
            //       .primaryColor,
            //   foregroundColor: Colors.white,
            //   onPressed: () {
            //     getNearbyPlaces();
            //   },
            //   label: const Text("Get Nearby Places"),
            //   icon: const Icon(Icons.place),
            // ),
          ],
        ),
      );
    });

    //
    // void getNearbyPlaces() async {
    //   Position position = await _determinePosition();
    //   var url = Uri.parse(
    //       'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=${position
    //           .latitude},${position.longitude}&radius=$radius&key=$API_KEY');
    //
    //   var response = await http.post(url);
    //   nearbyPlacesResponse =
    //       NearbyPlacesResponse.fromJson(jsonDecode(response.body));
    //
    //   _drawMarkers();
    //   _positionCamera(position);
    //   setState(() {});
    // }
    //
    // void _drawMarkers() {
    //   markers.clear();
    //
    //   if (nearbyPlacesResponse.results != null) {
    //     for (Results result in nearbyPlacesResponse.results!) {
    //       if (result.geometry != null &&
    //           result.geometry!.location != null &&
    //           result.name != null) {
    //         markers.add(
    //           Marker(
    //             markerId: MarkerId(result.placeId ?? ""),
    //             position: LatLng(
    //               result.geometry!.location!.lat ?? 0.0,
    //               result.geometry!.location!.lng ?? 0.0,
    //             ),
    //             infoWindow: InfoWindow(title: result.name ?? ""),
    //           ),
    //         );
    //       }
    //     }
    //   }
    // }
    //
    // void _positionCamera(Position position) {
    //   _googleMapController.animateCamera(
    //     CameraUpdate.newCameraPosition(
    //       CameraPosition(
    //         target: LatLng(position.latitude, position.longitude),
    //         zoom: 18,
    //       ),
    //     ),
    //   );
    // }
  }
}
