import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travel_point/core/utils/form_validators.dart';
import 'package:travel_point/core/widgets/error_snackbar.dart';
import 'package:travel_point/src/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:travel_point/src/features/authentication/presentation/bloc/auth_event.dart';
import 'package:travel_point/src/features/authentication/presentation/bloc/auth_state.dart';

class SignUpPage extends StatefulWidget {
  final VoidCallback navigateToLogInPage;

  const SignUpPage({super.key, required this.navigateToLogInPage});

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  void handleSignUpUser(BuildContext context) async {
    ScaffoldMessenger.of(context).clearSnackBars();

    final authBloc = BlocProvider.of<AuthBloc>(context);

    final signupEvent = SignupAuthEvent(
        displayName: usernameController.text,
        email: emailController.text,
        password: passwordController.text,
        confirmationPassword: confirmPasswordController.text);

    authBloc.add(signupEvent);
  }

  void handleNavigateLoginPage() {
    final authBloc = BlocProvider.of<AuthBloc>(context);
    authBloc.emit(const InitialAuthState());
    ScaffoldMessenger.of(context).clearSnackBars();
    widget.navigateToLogInPage();
  }

  Widget defaultScreen() {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.only(top: 40.0,bottom: 20.0),
              child: Center(
                child: Image(image: ResizeImage(AssetImage('assets/logo.png'), width: 100, height: 100)),
              ),
            ),

            Padding(
              //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
              padding: const EdgeInsets.only(
                  left: 30.0, right: 30.0, top: 15, bottom: 0),
              child: TextFormField(
                controller: usernameController,
                validator: Validators.requiredField,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0)),
                    labelText: 'Username',
                    hintText: 'Ex. User123'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30.0, right: 30.0, top: 15, bottom: 0),
              child: TextFormField(
                controller: emailController,
                validator: Validators.requiredField,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0)),
                    labelText: 'Email',
                    hintText: 'Enter valid email id as abc@gmail.com'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 30.0, right: 30.0, top: 15, bottom: 0),
              //padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextFormField(
                obscureText: true,
                validator: Validators.requiredField,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                controller: passwordController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0)),
                    labelText: 'Password',
                    hintText: 'Enter secure password'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 30.0, right: 30.0, top: 15, bottom: 15),
              //padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextFormField(
                obscureText: true,
                validator: Validators.requiredField,
                controller: confirmPasswordController,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0)),
                    labelText: 'Confirm Password',
                    hintText: 'Confirm Password'),
              ),
            ),
            Container(
              height: 40,
              width: 220,
              decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 5,
                    )
                  ],
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(10),),
              child: TextButton(
                onPressed: () => handleSignUpUser(context),
                child: const Text(
                  'Sign Up',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const Text('Already have an account? '),
                TextButton(
                  onPressed: handleNavigateLoginPage,
                  child: const Text(
                    'Log In',
                    style: TextStyle(color: Colors.redAccent),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Sign Up"),
          centerTitle: true,
        ),
        body: BlocBuilder<AuthBloc, AuthState>(
          builder: (_, state) {
            return Stack(
              children: [
                AbsorbPointer(
                  absorbing: state is LoadingAuthState,
                  child: defaultScreen(),
                ),
                if (state is LoadingAuthState)
                  const AlertDialog(
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 16),
                        Text("Signing up..."),
                      ],
                    ),
                  ),
                if (state is ErrorAuthState)
                  ErrorSnackbarWidget(
                    errorCode: state.errorCode,
                    errorMessage: state.errorMessage,
                    context: context,
                  )
              ],
            );
          },
        ));
  }
}
