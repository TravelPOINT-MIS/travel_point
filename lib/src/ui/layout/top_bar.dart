import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:travel_point/src/user/auth_service.dart';

class TopBarApp extends StatelessWidget implements PreferredSizeWidget {
  const TopBarApp({super.key});

  @override
  Widget build(BuildContext context) {
    void handleLogOutUser() async {
      await FirebaseAuth.instance.signOut();
    }

    return AppBar(
      actions: <Widget>[
        IconButton(
          icon: const Icon(Icons.logout_rounded),
          onPressed: handleLogOutUser,
        ), //IconButton
      ],
      leading: IconButton(
        icon: const Icon(Icons.public),
        tooltip: 'Menu Icon',
        onPressed: () {},
      ),
      title: const Text('TravelPoint'),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
