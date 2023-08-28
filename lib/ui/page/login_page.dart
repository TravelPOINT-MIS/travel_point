import 'package:flutter/material.dart';
import 'package:travel_point/model/auth_resp_firebase_model.dart';
import 'package:travel_point/user/auth_service.dart';

class LoginPage extends StatefulWidget {
  final VoidCallback navigateToSignUpPage;

  const LoginPage({super.key, required this.navigateToSignUpPage});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  AuthResponseFirebase _authResponseFirebase = AuthResponseFirebase();

  void handleLogIn() async {
    await AuthService.logInUser(emailController.text, passwordController.text)
        .then((authResponseFirebase) {
      setState(() {
        _authResponseFirebase = authResponseFirebase;
      });
    });
  }

  void loginWithGoogle() async {
    await AuthService.signInWithGoogle();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Log In"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.only(top: 60.0),
              child: Center(
                child: SizedBox(
                    width: 200, height: 150, child: Icon(Icons.public)),
              ),
            ),
            // TODO change to better error display message - styling
            if (_authResponseFirebase.error?.message != null)
              Text(
                _authResponseFirebase.error!.message!,
                style: const TextStyle(color: Colors.red),
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
            Container(
              height: 50,
              width: 250,
              decoration: BoxDecoration(
                  color: Colors.redAccent,
                  borderRadius: BorderRadius.circular(20)),
              child: TextButton(
                onPressed: handleLogIn,
                child: const Text(
                  'Log in',
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
                const Text('New User?'),
                TextButton(
                  onPressed: widget.navigateToSignUpPage,
                  child: const Text(
                    'Create Account',
                    style: TextStyle(color: Colors.redAccent),
                  ),
                ),
              ],
            ),
            TextButton(
              onPressed: loginWithGoogle,
              child: const Text(
                'Login with Google',
                style: TextStyle(color: Colors.redAccent),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
