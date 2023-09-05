import 'package:travel_point/core/type/type_def.dart';

abstract class AuthRepository {
  const AuthRepository();

  ResultFutureVoid loginUser({required String email, required String password});

// ResultFuture<UserEntity> getCurrentUser();
}
