import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travel_point/injection_container.dart';
import 'package:travel_point/src/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:travel_point/src/features/authentication/presentation/views/login_page.dart';
import 'package:travel_point/src/features/authentication/presentation/views/signup_page.dart';

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
      return BlocProvider<AuthBloc>(
          create: (context) => sl(),
          child: LoginPage(
            navigateToSignUpPage: toggleActiveAuthPage,
          ));
    } else {
      return BlocProvider<AuthBloc>(
          create: (context) => sl(),
          child: SignUpPage(
            navigateToLogInPage: toggleActiveAuthPage,
          ));
    }
  }
}
