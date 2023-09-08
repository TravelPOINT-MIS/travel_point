import 'package:dartz/dartz.dart';
import 'package:geolocator_platform_interface/src/models/position.dart';
import 'package:travel_point/core/errors/exception.dart';
import 'package:travel_point/core/errors/failure.dart';
import 'package:travel_point/core/type/type_def.dart';
import 'package:travel_point/src/features/map/data/datasource/map_remote_data_source.dart';
import 'package:travel_point/src/features/map/domain/repository/map_repository.dart';

class MapRepositoryImpl implements MapRepository {
  const MapRepositoryImpl(this._remoteDataSource);

  final MapRemoteDataSource _remoteDataSource;

  @override
  ResultFuture<Position> determinePosition() async{
    try {
      Position position = await _remoteDataSource.getCurrentLocation();
      return Right(position);
    } on ApiException catch (error) {
      final ApiFailure apiFailure = ApiFailure.fromApiException(error);
      return Left(apiFailure);
    }
  }
}