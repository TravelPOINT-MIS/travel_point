import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:travel_point/core/errors/exception.dart';
import 'package:travel_point/core/errors/failure.dart';
import 'package:travel_point/core/type/type_def.dart';
import 'package:travel_point/src/features/authentication/data/datasource/auth_remote_data_source.dart';
import 'package:travel_point/src/features/authentication/data/models/user_model.dart';
import 'package:travel_point/src/features/authentication/domain/entity/user.dart';
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

  @override
  ResultFutureVoid signupUser({
    required String displayName,
    required String email,
    required bool emailVerified,
    required String password,
    required Timestamp dateCreated,
    Timestamp? dateModified,
    required bool googleUser,
  }) async {
    try {
      await _remoteDataSource.signupUser(
          displayName: displayName,
          email: email,
          emailVerified: emailVerified,
          password: password,
          dateCreated: dateCreated,
          googleUser: googleUser);
      return const Right(null);
    } on ApiException catch (error) {
      final ApiFailure apiFailure = ApiFailure.fromApiException(error);
      return Left(apiFailure);
    }
  }

  @override
  ResultFuture<List<String>> getUsernames() async {
    try {
      List<String> usernames = await _remoteDataSource.getUsernames();
      return Right(usernames);
    } on ApiException catch (error) {
      final ApiFailure apiFailure = ApiFailure.fromApiException(error);
      return Left(apiFailure);
    }
  }

  @override
  ResultFutureVoid loginWithGoogle() async {
    try {
      await _remoteDataSource.loginWithGoogle();
      return const Right(null);
    } on ApiException catch (error) {
      final ApiFailure apiFailure = ApiFailure.fromApiException(error);
      return Left(apiFailure);
    }
  }

  @override
  ResultFutureVoid logoutUser() async {
    try {
      await _remoteDataSource.logoutUser();
      return const Right(null);
    } on ApiException catch (error) {
      final ApiFailure apiFailure = ApiFailure.fromApiException(error);
      return Left(apiFailure);
    }
  }

  @override
  ResultFutureVoid sendEmailVerification() async {
    try {
      await _remoteDataSource.sendEmailVerification();
      return const Right(null);
    } on ApiException catch (error) {
      final ApiFailure apiFailure = ApiFailure.fromApiException(error);
      return Left(apiFailure);
    }
  }

  @override
  ResultFuture<UserEntity> getCurrentUser() async {
    try {
      final result = await _remoteDataSource.getCurrentUser();
      return Right(result);
    } on ApiException catch (error) {
      final ApiFailure apiFailure = ApiFailure.fromApiException(error);
      return Left(apiFailure);
    }
  }

  @override
  ResultFuture<bool> getEmailVerifiedFlag() async {
    try {
      final result = await _remoteDataSource.getEmailVerifiedFlag();
      return Right(result);
    } on ApiException catch (error) {
      final ApiFailure apiFailure = ApiFailure.fromApiException(error);
      return Left(apiFailure);
    }
  }

  @override
  ResultFutureVoid updateUser(
      {String? displayName,
      bool? emailVerified,
      Timestamp? dateCreated,
      Timestamp? dateModified,
      bool? googleUser}) async {
    try {
      UserEntity currentUserEntity = await _remoteDataSource.getCurrentUser();
      UserModel currentUser = UserModel.fromUserEntity(currentUserEntity);
      UserModel newUser = currentUser.copyWith(
          displayName: displayName,
          emailVerified: emailVerified,
          dateCreated: dateCreated,
          dateModified: dateModified);

      await _remoteDataSource.updateUser(newUser);

      return const Right(null);
    } on ApiException catch (error) {
      final ApiFailure apiFailure = ApiFailure.fromApiException(error);
      return Left(apiFailure);
    }
  }
}
