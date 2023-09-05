import 'package:dartz/dartz.dart';
import 'package:travel_point/core/errors/exception.dart';
import 'package:travel_point/core/errors/failure.dart';
import 'package:travel_point/core/type/type_def.dart';
import 'package:travel_point/src/features/authentication/data/datasource/auth_remote_data_source.dart';
import 'package:travel_point/src/features/authentication/domain/repository/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl(this._remoteDataSource);

  final AuthRemoteDataSource _remoteDataSource;

  @override
  ResultFutureVoid loginUser(
      {required String email, required String password}) async {
    try {
      await _remoteDataSource.loginUser(email: email, password: password);
      return const Right(null);
    } on ApiException catch (error) {
      final ApiFailure apiFailure = ApiFailure.fromApiException(error);
      return Left(apiFailure);
    }
  }

// @override
// ResultFuture<UserModel> getCurrentUser() async {
//   try {
//     UserModel userModel = await _remoteDataSource.getCurrentUser();
//
//     return Right(userModel);
//   } on ApiException catch (error) {
//     final ApiFailure apiFailure = ApiFailure.fromApiException(error);
//     return Left(apiFailure);
//   }
// }
}
