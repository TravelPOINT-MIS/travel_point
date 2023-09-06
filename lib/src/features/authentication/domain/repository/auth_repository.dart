import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:travel_point/core/type/type_def.dart';

abstract class AuthRepository {
  const AuthRepository();

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
}
