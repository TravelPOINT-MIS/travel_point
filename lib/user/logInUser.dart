import 'package:firebase_auth/firebase_auth.dart';

class LogInUser {
  static Future<void> logInUser(String email, String password) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (error) {
      final String errorCode = error.code;

      if (errorCode == 'user-not-found') {
        print('User not found');
      } else if (errorCode == 'wrong-password') {
        print('Wrong password');
      }
    }
  }
}
