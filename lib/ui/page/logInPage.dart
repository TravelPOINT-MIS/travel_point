import 'package:flutter/material.dart';
import 'package:travel_point/model/AuthResponseFirebase.dart';
import 'package:travel_point/ui/page/signUpPage.dart';
import 'package:travel_point/user/logInUser.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  AuthResponseFirebase _authResponseFirebase = AuthResponseFirebase();

  void handleLogIn() async {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        });

    await LogInUser.logInUser(emailController.text, passwordController.text)
        .then((authResponseFirebase) {
      setState(() {
        _authResponseFirebase = authResponseFirebase;
      });

      Navigator.of(context).pop();
    });
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
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => SignUpPage()),
                    );
                  },
                  child: const Text(
                    'Create Account',
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
}
