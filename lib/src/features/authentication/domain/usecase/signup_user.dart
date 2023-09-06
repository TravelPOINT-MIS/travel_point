import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:travel_point/core/errors/failure.dart';
import 'package:travel_point/core/type/type_def.dart';
import 'package:travel_point/core/usecase/usecase.dart';
import 'package:travel_point/src/features/authentication/domain/repository/auth_repository.dart';

class SignupUserUsecase extends UsecaseWithParams<void, CreateUserParams> {
  const SignupUserUsecase(this._repository);

  final AuthRepository _repository;

  @override
  ResultFutureVoid call(CreateUserParams params) async {
    if (params.displayName.isEmpty ||
        params.password.isEmpty ||
        params.email.isEmpty ||
        params.confirmationPassword.isEmpty) {
      return const Left(UserInputFailure(
          errorMessage: 'Please enter value for all fields!',
          errorCode: 'empty-fields'));
    }

    Result<List<String>> result = await _repository.getUsernames();
    List<String> resultUsernames = [];

    if (result.isLeft()) {
      return result;
    } else if (result.isRight()) {
      result.fold(
          (failure) => null, (usernames) => resultUsernames = usernames);
    }

    if (resultUsernames.contains(params.displayName)) {
      return const Left(UserInputFailure(
          errorMessage: 'User with this username already exits!',
          errorCode: 'username-taken'));
    }

    if (params.password != params.confirmationPassword) {
      return const Left(UserInputFailure(
          errorMessage: 'Entered passwords do not match!',
          errorCode: 'password-not-match'));
    }

    return await _repository.signupUser(
        displayName: params.displayName,
        email: params.email,
        emailVerified: false,
        password: params.password,
        dateCreated: Timestamp.now(),
        dateModified: null,
        googleUser: false);
  }
}

class CreateUserParams extends Equatable {
  final String displayName;
  final String email;
  final String password;
  final String confirmationPassword;

  const CreateUserParams(
      {required this.displayName,
      required this.email,
      required this.password,
      required this.confirmationPassword});

  @override
  List<Object?> get props =>
      [displayName, email, password, confirmationPassword];
}
