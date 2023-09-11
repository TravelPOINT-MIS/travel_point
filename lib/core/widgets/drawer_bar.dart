import 'dart:async';
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
            DrawerHeader(
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                ),
                child: const Image(
                    image: ResizeImage(AssetImage('assets/logo.png'),
                        width: 120, height: 120))),
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
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Log out'),
              onTap: () => handleLogout(context),
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
