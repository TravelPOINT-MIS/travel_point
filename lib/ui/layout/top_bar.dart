import 'package:flutter/material.dart';
import 'package:travel_point/user/user_service.dart';

class TopBarApp extends StatelessWidget implements PreferredSizeWidget {
  const TopBarApp({super.key});

  void handleLogOutUser() async {
    await UserService.logOutUser();
  }

  @override
  Widget build(BuildContext context) {
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
