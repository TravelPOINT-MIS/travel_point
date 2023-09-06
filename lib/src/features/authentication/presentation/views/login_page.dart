import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travel_point/core/widgets/ErrorSnackbar.dart';
import 'package:travel_point/src/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:travel_point/src/features/authentication/presentation/bloc/auth_event.dart';
import 'package:travel_point/src/features/authentication/presentation/bloc/auth_state.dart';

class LoginPage extends StatefulWidget {
  final VoidCallback navigateToSignUpPage;

  const LoginPage({super.key, required this.navigateToSignUpPage});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void handleLogIn(BuildContext context) async {
    final authBloc = BlocProvider.of<AuthBloc>(context);

    final loginEvent = LoginAuthEvent(
      email: emailController.text,
      password: passwordController.text,
    );

    authBloc.add(loginEvent);
  }

  void loginWithGoogle() async {
    // await AuthService.signInWithGoogle();
  }

  Widget defaultScreen() {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.only(top: 60.0),
            child: Center(
              child:
                  SizedBox(width: 200, height: 150, child: Icon(Icons.public)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: TextField(
              controller: emailController,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0)),
                  labelText: 'Email',
                  hintText: 'Enter valid email id as abc@example.com'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
                left: 15.0, right: 15.0, top: 15, bottom: 15),
            child: TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0)),
                  labelText: 'Password',
                  hintText: 'Enter secure password'),
            ),
          ),
          FilledButton(
            style: ButtonStyle(
              fixedSize: MaterialStateProperty.all(const Size(250, 50)),
            ),
            onPressed: () => handleLogIn(context),
            child: const Text(
              'Log in',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const Text('New User?'),
              TextButton(
                onPressed: widget.navigateToSignUpPage,
                child: const Text(
                  'Create Account',
                ),
              ),
            ],
          ),
          TextButton(
            onPressed: loginWithGoogle,
            child: const Text(
              'Login with Google',
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Log In"),
      ),
      body: BlocBuilder<AuthBloc, AuthState>(builder: (_, state) {
        if (state is InitialAuthState) {
          return defaultScreen();
        } else if (state is LoadingAuthState) {
          return Stack(
            children: [
              AbsorbPointer(
                absorbing: true,
                child: defaultScreen(),
              ),
              const AlertDialog(
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text("Logging in..."),
                  ],
                ),
              )
            ],
          );
        } else if (state is ErrorAuthState) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ScaffoldMessenger.of(context).showSnackBar(
              ErrorSnackbar(
                errorCode: state.errorCode,
                errorMessage: state.errorMessage,
                context: context,
              ),
            );
          });
          return defaultScreen();
        } else {
          return defaultScreen();
        }
      }),
    );
  }
}
