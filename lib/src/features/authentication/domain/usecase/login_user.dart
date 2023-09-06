import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:travel_point/core/errors/failure.dart';
import 'package:travel_point/core/type/type_def.dart';
import 'package:travel_point/core/usecase/usecase.dart';
import 'package:travel_point/src/features/authentication/domain/repository/auth_repository.dart';

class LoginUserUsecase extends UsecaseWithParams<void, LoginParams> {
  const LoginUserUsecase(this._repository);

  final AuthRepository _repository;

  @override
  ResultFutureVoid call(LoginParams params) async {
    if (params.password.isEmpty || params.email.isEmpty) {
      return const Left(UserInputFailure(
          errorMessage: 'Please enter value for all fields!',
          errorCode: 'empty-fields'));
    }

    return await _repository.loginUser(
        email: params.email, password: params.password);
  }
}

class LoginParams extends Equatable {
  final String email;
  final String password;

  const LoginParams({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}
