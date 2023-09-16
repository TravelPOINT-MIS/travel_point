import 'package:google_maps_webservice/places.dart';
import 'package:travel_point/core/type/type_def.dart';
import 'package:travel_point/core/usecase/usecase.dart';
import 'package:travel_point/src/features/map/domain/repository/map_repository.dart';

class GetPlaceDetailsUsecase
    extends UsecaseWithParams<PlaceDetails, String> {
  GetPlaceDetailsUsecase(this._mapRepository);

  final MapRepository _mapRepository;

  @override
  ResultFuture<PlaceDetails> call(String placeId) async {
    return await _mapRepository.getPlaceFromPlaceId(
        placeId: placeId);
  }
}
