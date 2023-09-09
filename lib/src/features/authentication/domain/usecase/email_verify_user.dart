import 'package:dartz/dartz.dart';
import 'package:travel_point/core/errors/failure.dart';
import 'package:travel_point/core/type/type_def.dart';
import 'package:travel_point/core/usecase/usecase.dart';
import 'package:travel_point/src/features/authentication/domain/repository/auth_repository.dart';

class EmailVerifyUserUsecase extends UsecaseWithoutParams<void> {
  final AuthRepository _repository;

  const EmailVerifyUserUsecase(this._repository);

  @override
  ResultFuture<void> call() async {
    Result<bool> isEmailVerifiedResult =
        await _repository.getEmailVerifiedFlag();

    if (isEmailVerifiedResult.isLeft()) {
      return isEmailVerifiedResult;
    } else {
      final bool isEmailVerified =
          isEmailVerifiedResult.getOrElse(() => throw Error());

      if (isEmailVerified) {
        return const Left(UserInputFailure(
            errorMessage: 'Email is already verified!',
            errorCode: 'already-verified'));
      } else {
        return await _repository.sendEmailVerification();
      }
    }
  }
}
