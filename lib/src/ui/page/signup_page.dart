import 'package:flutter/material.dart';
import 'package:travel_point/src/features/authentication/domain/entity/user.dart';
import 'package:travel_point/core/utils/form_validators.dart';
import 'package:travel_point/src/user/auth_service.dart';

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

  void handleSignUpUser() async {
    // if (_formKey.currentState!.validate()) {
    //   final UserEntity userData = UserEntity.defaultValuesNonGoogleUser(
    //       displayName: usernameController.text);
    //
    //   await AuthService.signUpUser(
    //           emailController.text, passwordController.text, userData);
    //
    //   // TODO check causes error to be thrown in console...
    //   //     .then((authResponseFirebase) {
    //   //   setState(() {
    //   //     _authResponseFirebase = authResponseFirebase;
    //   //   });
    //   // });
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: const Text("Sign Up"),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.only(top: 60.0),
                  child: Center(
                    child: Icon(Icons.public),
                  ),
                ),

                Padding(
                  //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
                  padding: const EdgeInsets.only(
                      left: 15.0, right: 15.0, top: 15, bottom: 0),
                  child: TextFormField(
                    controller: usernameController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: Validators.requiredField,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0)),
                        labelText: 'Username',
                        hintText: 'Ex. User123'),
                  ),
                ),
                Padding(
                  //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
                  padding: const EdgeInsets.only(
                      left: 15.0, right: 15.0, top: 15, bottom: 0),
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
                      left: 15.0, right: 15.0, top: 15, bottom: 0),
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
                      left: 15.0, right: 15.0, top: 15, bottom: 15),
                  //padding: EdgeInsets.symmetric(horizontal: 15),
                  child: TextFormField(
                    obscureText: true,
                    validator: Validators.requiredField,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0)),
                        labelText: 'Confirm Password',
                        hintText: 'Confirm Password'),
                  ),
                ),
                // SizedBox(
                //   height: 100,
                // ),
                Container(
                  height: 50,
                  width: 250,
                  decoration: BoxDecoration(
                      color: Colors.redAccent,
                      borderRadius: BorderRadius.circular(20)),
                  child: TextButton(
                    onPressed: handleSignUpUser,
                    child: const Text(
                      'Sign Up',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    const Text('Already have an account? '),
                    TextButton(
                      onPressed: widget.navigateToLogInPage,
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
        ));
  }
}
