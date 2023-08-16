import 'package:firebase_auth/firebase_auth.dart';
import 'package:travel_point/model/authResponseFirebase.dart';
import 'package:travel_point/user/firestoreUser.dart';

class SignUpUser {
  static Future<AuthResponseFirebase> signUpUser(
      String displayName, String email, String password) async {
    AuthResponseFirebase authResponseFirebase = AuthResponseFirebase();

    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      await Future.delayed(const Duration(seconds: 2));

      await FirestoreUser.updateUserDocument(userCredential.user!.uid, {
        "displayName": displayName,
        "dateCreated": DateTime.now(),
        "dateModified": null,
        "emailVerified": false
      });

      authResponseFirebase.userCredential = userCredential;
    } on FirebaseAuthException catch (error) {
      authResponseFirebase.error = error;
    }

    return authResponseFirebase;
  }
}
