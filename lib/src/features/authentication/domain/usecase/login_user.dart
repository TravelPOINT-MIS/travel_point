import 'package:equatable/equatable.dart';
import 'package:travel_point/core/type/type_def.dart';
import 'package:travel_point/core/usecase/usecase.dart';
import 'package:travel_point/src/features/authentication/domain/repository/auth_repository.dart';

class LoginUserUsecase extends UsecaseWithParams<void, LoginParams> {
  const LoginUserUsecase(this._repository);

  final AuthRepository _repository;

  @override
  ResultFutureVoid call(LoginParams params) async {
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
