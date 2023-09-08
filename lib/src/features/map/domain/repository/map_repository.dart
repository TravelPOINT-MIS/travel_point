import 'package:geolocator/geolocator.dart';
import 'package:travel_point/core/type/type_def.dart';

abstract class MapRepository {
  const MapRepository();

  ResultFuture<Position> determinePosition();
}
