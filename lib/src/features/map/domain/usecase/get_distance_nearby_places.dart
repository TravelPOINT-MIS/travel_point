import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:travel_point/core/type/type_def.dart';
import 'package:travel_point/core/usecase/usecase.dart';
import 'package:travel_point/src/features/map/data/models/distance_matrix_response.dart';
import 'package:travel_point/src/features/map/data/models/place_model.dart';
import 'package:travel_point/src/features/map/domain/repository/map_repository.dart';

class GetDistanceForNearbyPlacesUsecase extends UsecaseWithParams<
    DistanceMatrixResponse, GetDistanceNearbyPlacesParams> {
  GetDistanceForNearbyPlacesUsecase(this._mapRepository);

  final MapRepository _mapRepository;

  @override
  ResultFuture<DistanceMatrixResponse> call(
      GetDistanceNearbyPlacesParams params) async {
    return await _mapRepository.getDistanceForNearbyPlaces(
        destinationAddresses: params.destinationAddresses,
        originAddress: params.originAddress,
        travelMode: params.travelMode);
  }
}

class GetDistanceNearbyPlacesParams extends Equatable {
  final List<PlaceModel> destinationAddresses;
  final LatLng originAddress;
  final TravelModeEnum travelMode;

  const GetDistanceNearbyPlacesParams(
      {required this.destinationAddresses,
      required this.originAddress,
      required this.travelMode});

  @override
  List<Object?> get props => [destinationAddresses, originAddress, travelMode];
}
