import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travel_point/src/features/authentication/domain/entity/user.dart';
import 'package:travel_point/src/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:travel_point/src/features/authentication/presentation/bloc/auth_event.dart';
import 'package:travel_point/src/features/authentication/presentation/bloc/auth_state.dart';
import 'package:travel_point/src/features/authentication/presentation/views/userInfo_page.dart';

class DrawerMenu extends StatefulWidget {
  const DrawerMenu({Key? key}) : super(key: key);

  @override
  _DrawerMenuState createState() => _DrawerMenuState();
}

class _DrawerMenuState extends State<DrawerMenu> {
  UserEntity? userData;
  String? error;
  bool hideVerifyEmail = false;
  Timer? timer;

  void handleLogout(BuildContext context) async {
    ScaffoldMessenger.of(context).clearSnackBars();

    final authBloc = BlocProvider.of<AuthBloc>(context);
    const logoutEvent = LogoutUserAuthEvent();

    authBloc.add(logoutEvent);
  }

  void checkEmailVerification(BuildContext context) {
    timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      final authBloc = BlocProvider.of<AuthBloc>(context);

      const checkEmailVerifyEvent = CheckEmailVerifyUserAuthEvent();

      authBloc.add(checkEmailVerifyEvent);
    });
  }

  void handleEmailVerify(context) {
    ScaffoldMessenger.of(context).clearSnackBars();

    final authBloc = BlocProvider.of<AuthBloc>(context);

    const emailVerifyEvent = EmailVerifyUserAuthEvent();

    authBloc.add(emailVerifyEvent);

    checkEmailVerification(context);
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget defaultScreen(AuthState state) {
      return Drawer(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), bottomLeft: Radius.circular(20)),
        ),
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            // UserAccountsDrawerHeader(
            //   accountEmail: const Text('jane.doe@example.com'),
            //   accountName: const Text(
            //     'Jane Doe',
            //     style: TextStyle(fontSize: 24.0),
            //   ),
            //   decoration: BoxDecoration(
            //     color: Theme.of(context).primaryColor,
            //   ),
            // ),
            // UserAccountsDrawerHeader(
            //   accountEmail: Text(FirebaseAuth.instance.currentUser?.email ?? 'Display Email: N/A',),
            //   accountName: Text('User'),
            // ),
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
              ),
              padding: const EdgeInsets.only(top: 60, left: 10,bottom: 0),
                child: Column(

                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: 
                  [
                    const Row(
                      children:[
                      Icon(Icons.person,color: Colors.black54, size: 20,),
                    const Text('User:',
                    textAlign: TextAlign.left,
                    style: TextStyle(color: Colors.black54)),
                    
                    ]),

                    Text(FirebaseAuth.instance.currentUser?.email ?? 'Display Email: N/A',
              style: const TextStyle(fontSize: 16,color: Colors.black54),
              ),
              FirebaseAuth.instance.currentUser?.emailVerified == false
                            ? TextButton(
                                onPressed: () => handleEmailVerify(context),
                                child: const Text('Verify email!',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(color: Colors.white)),
                              )
                            : const Text('')]),
                            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Profile'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const UserInfoPage()),
                );
              },
            ),
            const Divider(
              thickness: 0.7,
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Log out'),
              onTap: () => handleLogout(context),
            ),
            const Divider(
              thickness: 1,
            ),
          ],
        ),
      );
    }

    return BlocBuilder<AuthBloc, AuthState>(builder: (_, state) {
      if (state is CheckEmailVerifyState) {
        if (state.isEmailVerified) {
          timer?.cancel();
        }
      }

      return defaultScreen(state);
    });
  }
}
