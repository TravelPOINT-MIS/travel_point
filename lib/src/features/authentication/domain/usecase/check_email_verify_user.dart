import 'package:travel_point/core/type/type_def.dart';
import 'package:travel_point/core/usecase/usecase.dart';
import 'package:travel_point/src/features/authentication/domain/repository/auth_repository.dart';

class CheckEmailVerifyUserUsecase extends UsecaseWithoutParams<bool> {
  const CheckEmailVerifyUserUsecase(this._repository);

  final AuthRepository _repository;

  @override
  ResultFuture<bool> call() async {
    Result<bool> isEmailVerifiedResult =
        await _repository.getEmailVerifiedFlag();

    if (isEmailVerifiedResult.isLeft()) {
      return isEmailVerifiedResult;
    } else {
      final bool isEmailVerified =
          isEmailVerifiedResult.getOrElse(() => throw Error());

      if (isEmailVerified) {
        await _repository.updateUser(emailVerified: true);
      }

      return isEmailVerifiedResult;
    }
  }
}
