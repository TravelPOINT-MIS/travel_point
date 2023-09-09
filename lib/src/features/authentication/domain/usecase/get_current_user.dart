import 'package:travel_point/core/type/type_def.dart';
import 'package:travel_point/core/usecase/usecase.dart';
import 'package:travel_point/src/features/authentication/domain/entity/user.dart';
import 'package:travel_point/src/features/authentication/domain/repository/auth_repository.dart';

class GetUserUsecase extends UsecaseWithoutParams<UserEntity> {
  final AuthRepository _repository;

  const GetUserUsecase(this._repository);

  @override
  ResultFuture<UserEntity> call() {
    return _repository.getCurrentUser();
  }
}