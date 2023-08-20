import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:travel_point/main.dart';
import 'package:travel_point/ui/page/login_page.dart';

class AuthUser extends StatefulWidget {
  const AuthUser({Key? key}) : super(key: key);

  @override
  _AuthUserState createState() => _AuthUserState();
}

class _AuthUserState extends State<AuthUser> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return const MainNavigationPage();
        } else {
          return const LoginPage();
        }
      },
    );
  }
}
