import 'package:geolocator/geolocator.dart';
import 'package:travel_point/core/type/type_def.dart';
import 'package:travel_point/core/usecase/usecase.dart';
import 'package:travel_point/src/features/map/domain/repository/map_repository.dart';

class GetUserCurrentLocationUsecase extends UsecaseWithoutParams<void> {
  const GetUserCurrentLocationUsecase(this._repository);

  final MapRepository _repository;

  @override
  ResultFuture<Position> call() async {
    return await _repository.determinePosition();
  }
}
