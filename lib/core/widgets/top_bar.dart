import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travel_point/src/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:travel_point/src/features/authentication/presentation/bloc/auth_event.dart';

class TopBarApp extends StatelessWidget implements PreferredSizeWidget {
  const TopBarApp({super.key});

  void handleLogout(BuildContext context) async {
    ScaffoldMessenger.of(context).clearSnackBars();

    final authBloc = BlocProvider.of<AuthBloc>(context);
    const logoutEvent = LogoutUserAuthEvent();

    authBloc.add(logoutEvent);
  }

  @override
  Widget build(BuildContext context) {
    Widget defaultScreen() {
      return AppBar(
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            onPressed: () => handleLogout(context),
          ),
          //IconButton
        ],
        leading: IconButton(
          icon: const Icon(Icons.public),
          tooltip: 'Menu Icon',
          onPressed: () {},
        ),
        title: const Text('TravelPoint'),
      );
    }

    return defaultScreen();
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
