import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travel_point/core/widgets/error_snackbar.dart';
import 'package:travel_point/core/widgets/loading_dialog.dart';
import 'package:travel_point/src/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:travel_point/src/features/authentication/presentation/bloc/auth_event.dart';
import 'package:travel_point/src/features/authentication/presentation/bloc/auth_state.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

import '../../../../../core/utils/form_validators.dart';

class LoginPage extends StatefulWidget {
  final VoidCallback navigateToSignUpPage;

  const LoginPage({super.key, required this.navigateToSignUpPage});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void handleNavigateSignupPage() {
    final authBloc = BlocProvider.of<AuthBloc>(context);
    authBloc.emit(const InitialAuthState());
    ScaffoldMessenger.of(context).clearSnackBars();
    widget.navigateToSignUpPage();
  }

  void handleLogIn(BuildContext context) async {
    ScaffoldMessenger.of(context).clearSnackBars();

    final authBloc = BlocProvider.of<AuthBloc>(context);

    final loginEvent = LoginAuthEvent(
      email: emailController.text,
      password: passwordController.text,
    );

    authBloc.add(loginEvent);
  }

  void loginWithGoogle() async {
    final authBloc = BlocProvider.of<AuthBloc>(context);

    const loginEvent = LoginWithGoogleAuthEvent();

    authBloc.add(loginEvent);
  }

  Widget defaultScreen() {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.only(top: 40.0, bottom: 20.0),
            child: Center(
                child: SizedBox(
              width: 100,
              height: 100,
              child: Image(
                image: AssetImage('assets/logo.png'),
                fit: BoxFit.fill, // You can adjust the fit as needed
              ),
            ) // Image(image: ResizeImage(AssetImage('assets/logo.png'), width: 100, height: 100))
                ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: TextFormField(
              controller: emailController,
              validator: Validators.requiredField,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                labelText: 'Email',
                hintText: 'Enter valid email id as abc@example.com',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
                left: 30.0, right: 30.0, top: 15, bottom: 15),
            child: TextFormField(
              controller: passwordController,
              validator: Validators.requiredField,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              obscureText: true,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0)),
                  labelText: 'Password',
                  hintText: 'Enter secure password'),
            ),
          ),
          FilledButton(
            style: ElevatedButton.styleFrom(
              shadowColor: Colors.grey,
              elevation: 2,
              fixedSize: const Size(220, 20),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
            ),
            onPressed: () => handleLogIn(context),
            child: const Text(
              'LOGIN',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
            ),
          ),
          const Text('or'),
          SignInButton(
            Buttons.Google,
            elevation: 1,
            onPressed: loginWithGoogle,
            text: "LOGIN with Google",
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const Text('New User?'),
              TextButton(
                onPressed: handleNavigateSignupPage,
                child: const Text(
                  'Create Account',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
        centerTitle: true,
      ),
      body: BlocBuilder<AuthBloc, AuthState>(builder: (_, state) {
        return Stack(
          children: [
            AbsorbPointer(
              absorbing: state is LoadingAuthState,
              child: defaultScreen(),
            ),
            if (state is LoadingAuthState)
              LoadingDialog(message: state.loadingMessage),
            if (state is ErrorAuthState)
              ErrorSnackbarWidget(
                errorCode: state.errorCode,
                errorMessage: state.errorMessage,
                context: context,
              )
          ],
        );
      }),
    );
  }
}
