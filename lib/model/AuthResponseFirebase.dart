import 'package:firebase_auth/firebase_auth.dart';

class AuthResponseFirebase {
  UserCredential? userCredential;
  FirebaseAuthException? error;

  AuthResponseFirebase({
    this.userCredential,
    this.error,
  });
}
