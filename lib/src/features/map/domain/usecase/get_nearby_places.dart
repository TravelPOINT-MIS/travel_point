import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:travel_point/core/type/type_def.dart';
import 'package:travel_point/core/usecase/usecase.dart';
import 'package:travel_point/src/features/map/domain/repository/map_repository.dart';
import 'package:travel_point/src/features/map/data/models/nearby_places_response.dart';

class GetNearbyPlacesUsecase
    extends UsecaseWithParams<NearbyPlacesResponse, GetNearbyPlacesParams> {
  GetNearbyPlacesUsecase(this._mapRepository);

  final MapRepository _mapRepository;

  @override
  ResultFuture<NearbyPlacesResponse> call(GetNearbyPlacesParams params) async {
    return await _mapRepository.getNearbyPlaces(
        fromPosition: params.fromPosition,
        radius: params.radius,
        types: params.types);
  }
}

class GetNearbyPlacesParams extends Equatable {
  final Position fromPosition;
  final int radius;
  final List<PlaceType> types;

  const GetNearbyPlacesParams(
      {required this.fromPosition, required this.radius, required this.types});

  @override
  List<Object?> get props => [fromPosition, radius, types];
}
