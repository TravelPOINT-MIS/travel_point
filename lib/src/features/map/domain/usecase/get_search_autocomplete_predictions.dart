import 'package:google_maps_webservice/places.dart';
import 'package:travel_point/core/type/type_def.dart';
import 'package:travel_point/core/usecase/usecase.dart';
import 'package:travel_point/src/features/map/domain/repository/map_repository.dart';

class GetSearchAutocompleteUsecase
    extends UsecaseWithParams<List<Prediction>, String> {
  GetSearchAutocompleteUsecase(this._mapRepository);

  final MapRepository _mapRepository;

  @override
  ResultFuture<List<Prediction>> call(String searchInputText) async {
    return await _mapRepository.getPredictionsFromAutocomplete(
        searchInputText: searchInputText);
  }
}
