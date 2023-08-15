import 'package:firebase_auth/firebase_auth.dart';
import 'package:travel_point/model/AuthResponseFirebase.dart';

class SignUpUser {
  static Future<AuthResponseFirebase> signUpUser(
      String email, String password) async {
    AuthResponseFirebase authResponseFirebase = AuthResponseFirebase();

    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      authResponseFirebase.userCredential = userCredential;
    } on FirebaseAuthException catch (error) {
      authResponseFirebase.error = error;
    }

    return authResponseFirebase;
  }
}
