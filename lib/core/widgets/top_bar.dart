import 'package:flutter/material.dart';

class TopBarApp extends StatelessWidget implements PreferredSizeWidget {
  const TopBarApp({super.key});


  @override
  Widget build(BuildContext context) {
    Widget defaultScreen() {
      return AppBar(
        leading: IconButton(
          icon: const SizedBox(
                width: 60,
                height: 60,
                child: Image(
                  image: AssetImage('assets/logo.png'),
                  fit: BoxFit.fill, 
                ),
              ),
              
          tooltip: 'Menu Icon',
          onPressed: () {},
        ),
        title: const Text('TravelPoint'), 
        //centerTitle: true,
      );
    }
    return defaultScreen();
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
