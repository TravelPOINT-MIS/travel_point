import 'package:flutter/material.dart';

class TopBarApp extends StatelessWidget implements PreferredSizeWidget {
  const TopBarApp({super.key});


  @override
  Widget build(BuildContext context) {
    Widget defaultScreen() {
      return AppBar(
        // actions: <Widget>[
        //   IconButton(
        //     icon: const Icon(Icons.logout_rounded),
        //     onPressed: () => handleLogout(context),
        //   ),
        //   //IconButton
        // ],
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
