import 'package:geolocator/geolocator.dart';
import 'package:travel_point/core/errors/exception.dart';

abstract class MapRemoteDataSource {
  Future<Position> getCurrentLocation();
}

class MapRemoteDataSourceImpl implements MapRemoteDataSource {
  @override
  Future<Position> getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw const ApiException(
            errorMessage: 'Location services are disabled!',
            errorCode: 'location-services-disabled');
      }

      LocationPermission locationPermission =
          await Geolocator.checkPermission();
      if (locationPermission == LocationPermission.denied) {
        locationPermission = await Geolocator.requestPermission();
        if (locationPermission == LocationPermission.denied) {
          throw const ApiException(
              errorMessage: 'Location permission are disabled!',
              errorCode: 'location-permission-disabled');
        }
      }
      if (locationPermission == LocationPermission.deniedForever) {
        throw const ApiException(
            errorMessage: 'Location permissions are permanently denied!',
            errorCode: 'location-permission-denied');
      }
      Position position = await Geolocator.getCurrentPosition();
      return position;
    } on LocationServiceDisabledException catch (e) {
      throw ApiException(
          errorMessage: e.toString(), errorCode: 'location-permission-denied');
    }
  }
}
