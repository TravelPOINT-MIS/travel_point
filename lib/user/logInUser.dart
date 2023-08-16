import 'package:firebase_auth/firebase_auth.dart';
import 'package:travel_point/model/authResponseFirebase.dart';

class LogInUser {
  static Future<AuthResponseFirebase> logInUser(
      String email, String password) async {
    AuthResponseFirebase authResponseFirebase = AuthResponseFirebase();

    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      authResponseFirebase.userCredential = userCredential;
    } on FirebaseAuthException catch (error) {
      authResponseFirebase.error = error;
    }

    return authResponseFirebase;
  }
}
