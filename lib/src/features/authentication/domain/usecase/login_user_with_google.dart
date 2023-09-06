import 'package:travel_point/core/type/type_def.dart';
import 'package:travel_point/core/usecase/usecase.dart';
import 'package:travel_point/src/features/authentication/domain/repository/auth_repository.dart';

class LoginUserWithGoogleUsecase extends UsecaseWithoutParams<void> {
  const LoginUserWithGoogleUsecase(this._repository);

  final AuthRepository _repository;

  @override
  ResultFutureVoid call() async {
    return await _repository.loginWithGoogle();
  }
}
