import 'package:flutter/material.dart';

class TopBarApp extends StatelessWidget implements PreferredSizeWidget {
  const TopBarApp({super.key});

  @override
  Widget build(BuildContext context) {
    Widget defaultScreen() {
      return AppBar(
        title: const Text('TravelPoint'),
      );
    }

    return defaultScreen();
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
