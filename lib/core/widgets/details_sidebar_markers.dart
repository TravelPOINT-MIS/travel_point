import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:travel_point/core/constants/constants.dart';
import 'package:travel_point/src/features/map/data/models/place_model.dart';

class DetailsSidebarMarkers extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  final Function(CameraPosition) updateCameraPosition;
  final List<PlaceModel> places;

  const DetailsSidebarMarkers({
    super.key,
    required this.scaffoldKey,
    required this.updateCameraPosition,
    required this.places,
  });

  String formatLocationTypeName(String name) {
    final parts = name.split('_');
    final formattedName = parts
        .map((part) => part.substring(0, 1).toUpperCase() + part.substring(1))
        .join(' ');
    return formattedName;
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: places.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.warning),
                  SizedBox(height: 8),
                  Text(
                    'No places available.',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            )
          : ListView.separated(
              itemCount: places.length,
              separatorBuilder: (context, index) => const Divider(
                thickness: 1,
              ),
              itemBuilder: (context, index) {
                final place = places[index];
                String? photoReference = place.photos?[0].photoReference;
                String? photoUrl;
                if (photoReference != null) {
                  photoUrl =
                      'https://maps.googleapis.com/maps/api/place/photo?';
                  photoUrl += 'maxwidth=400'; // Adjust the width as needed.
                  photoUrl += '&photoreference=$photoReference';
                  photoUrl += '&key=$API_KEY';
                }

                return ListTile(
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("${place.rating ?? ''}"),
                      place.rating != null
                          ? const Icon(Icons.star_rate_rounded)
                          : const Center(), // Icon// Text
                    ],
                  ),
                  title: Text(place.name),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("User Ratings: ${place.userRatingsTotal ?? 'N/A'}"),
                      Text(
                          "Types: ${place.types?.map(formatLocationTypeName).join(', ') ?? 'N/A'}"),
                      if (place.openingHours != null)
                        Text(
                            "Open Now: ${place.openingHours!.openNow ?? false ? 'Yes' : 'No'}"),
                    ],
                  ),
                  leading: photoUrl != null
                      ? SizedBox(
                          width: 80,
                          height: 80,
                          child: Image.network(photoUrl),
                        )
                      : null,
                  onTap: () {
                    final CameraPosition cameraPositionItem = CameraPosition(
                      target: LatLng(
                        place.lat,
                        place.lng,
                      ),
                      zoom: 18,
                    );
                    updateCameraPosition(cameraPositionItem);
                    scaffoldKey.currentState?.openEndDrawer();
                  },
                );
              },
            ),
    );
  }
}
