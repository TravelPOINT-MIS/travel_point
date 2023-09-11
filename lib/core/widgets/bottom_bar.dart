import 'package:flutter/material.dart';
import 'package:travel_point/core/type/type_def.dart';

class BottomNavigationBarApp extends StatefulWidget {
  final void Function(MapPageType) onItemTapped;
  final MapPageType activeMapTab;

  const BottomNavigationBarApp(
      {super.key, required this.onItemTapped, required this.activeMapTab});

  @override
  State<BottomNavigationBarApp> createState() => _BottomNavigationBarAppState();
}

class _BottomNavigationBarAppState extends State<BottomNavigationBarApp> {
  final Map<MapPageType, BottomNavigationBarItem> _bottomBarItems = {
    MapPageType.ExploreMap: const BottomNavigationBarItem(
      icon: Icon(Icons.public_outlined),
      label: 'Explore',
    ),
    MapPageType.FindHomeMap: const BottomNavigationBarItem(
      icon: Icon(Icons.home_outlined),
      label: 'Find home',
    ),
    MapPageType.NearByMap: const BottomNavigationBarItem(
      icon: Icon(Icons.location_on_outlined),
      label: 'Near me',
    ),
  };

  void _onItemTapped(int item) {
    MapPageType mapPageType = _bottomBarItems.keys.elementAt(item);

    return widget.onItemTapped(mapPageType);
  }

  int getIndex(MapPageType mapPageType) {
    int index = 0;

    for (MapPageType key in _bottomBarItems.keys) {
      if (key == mapPageType) {
        return index;
      }
      index++;
    }

    return -1;
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: _bottomBarItems.values.toList(),
      type: BottomNavigationBarType.fixed,
      currentIndex: getIndex(widget.activeMapTab),
      onTap: _onItemTapped,
    );
  }
}
