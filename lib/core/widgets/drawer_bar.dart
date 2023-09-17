import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travel_point/src/features/authentication/domain/entity/user.dart';
import 'package:travel_point/src/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:travel_point/src/features/authentication/presentation/bloc/auth_event.dart';
import 'package:travel_point/src/features/authentication/presentation/bloc/auth_state.dart';
import 'package:travel_point/src/features/authentication/presentation/views/userInfo_page.dart';

class DrawerMenu extends StatefulWidget {
  final UserEntity? userData;

  const DrawerMenu({Key? key, required this.userData}) : super(key: key);

  @override
  _DrawerMenuState createState() => _DrawerMenuState();
}

class _DrawerMenuState extends State<DrawerMenu> {
  UserEntity? userData;
  String? error;

  void handleLogout(BuildContext context) async {
    ScaffoldMessenger.of(context).clearSnackBars();

    final authBloc = BlocProvider.of<AuthBloc>(context);
    const logoutEvent = LogoutUserAuthEvent();

    authBloc.add(logoutEvent);
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
            UserAccountsDrawerHeader(
              accountEmail: Text(widget.userData?.email ?? ''),
              accountName: Text(widget.userData?.displayName ?? '',
                  style: const TextStyle(fontSize: 24.0)),
              onDetailsPressed: () {},
              currentAccountPicture: const SizedBox(
                width: 50,
                height: 50,
                child: Image(
                  image: AssetImage('assets/logo.png'),
                  fit: BoxFit.fill, // You can adjust the fit as needed
                ),
              ),
              otherAccountsPictures: [
                widget.userData?.googleUser == true
                    ? const Text(
                        'Google user',
                        style: TextStyle(color: Colors.white, fontSize: 10),
                      )
                    : const Text(
                        'App user',
                        style: TextStyle(color: Colors.white, fontSize: 10),
                      ),
              ],
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
              ),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Profile'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          UserInfoPage(userEntity: widget.userData)),
                );
              },
            ),
            const Divider(
              thickness: 1,
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
      return defaultScreen(state);
    });
  }
}
