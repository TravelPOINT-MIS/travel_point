import 'package:flutter/material.dart';
import 'package:travel_point/ui/page/logIn.dart';

class TopBarApp extends StatelessWidget implements PreferredSizeWidget {
  const TopBarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      actions: <Widget>[
        IconButton(
          icon: const Icon(Icons.person),
          tooltip: 'User Icon',
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const LoginPage()),
            );
          },
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
