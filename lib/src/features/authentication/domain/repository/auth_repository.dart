import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:travel_point/core/type/type_def.dart';
import 'package:travel_point/src/features/authentication/domain/entity/user.dart';

abstract class AuthRepository {
  const AuthRepository();

  ResultFuture<UserEntity> getCurrentUser();

  ResultFutureVoid loginUser({required String email, required String password});

  ResultFutureVoid signupUser({
    required String displayName,
    required String email,
    required bool emailVerified,
    required String password,
    required Timestamp dateCreated,
    Timestamp? dateModified,
    required bool googleUser,
  });

  ResultFuture<List<String>> getUsernames();

  ResultFutureVoid loginWithGoogle();

  ResultFutureVoid logoutUser();

  ResultFutureVoid sendEmailVerification();

  ResultFuture<bool> getEmailVerifiedFlag();

  ResultFutureVoid updateUser({
    String? displayName,
    bool? emailVerified,
    Timestamp? dateCreated,
    Timestamp? dateModified,
    bool? googleUser,
  });
}
