import 'package:firebase_auth/firebase_auth.dart';

class LogOutUser {
  static Future<void> logOutUser() async {
    await FirebaseAuth.instance.signOut();
  }
}
