import 'package:flutter/material.dart';

class BottomNavigationBarApp extends StatefulWidget {
  final void Function(int) onItemTapped;
  final int selectedIndex;

  const BottomNavigationBarApp(
      {super.key, required this.onItemTapped, required this.selectedIndex});

  @override
  State<BottomNavigationBarApp> createState() => _BottomNavigationBarAppState();
}

class _BottomNavigationBarAppState extends State<BottomNavigationBarApp> {
  final List<BottomNavigationBarItem> _bottomBarItems =
      const <BottomNavigationBarItem>[
    BottomNavigationBarItem(
      icon: Icon(Icons.public_outlined),
      label: 'Explore',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.home_outlined),
      label: 'Find home',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.location_on_outlined),
      label: 'Near me',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: _bottomBarItems,
      type: BottomNavigationBarType.fixed,
      currentIndex: widget.selectedIndex,
      onTap: widget.onItemTapped,
    );
  }
}
