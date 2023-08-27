import 'package:flutter/material.dart';
import 'package:travel_point/ui/page/login_page.dart';
import 'package:travel_point/ui/page/signup_page.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool isLoginActive = true;

  void toggleActiveAuthPage() {
    setState(() {
      isLoginActive = !isLoginActive;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoginActive) {
      return LoginPage(
        navigateToSignUpPage: toggleActiveAuthPage,
      );
    } else {
      return SignUpPage(
        navigateToLogInPage: toggleActiveAuthPage,
      );
    }
  }
}
