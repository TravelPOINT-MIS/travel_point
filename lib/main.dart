import 'package:flutter/material.dart';
import 'package:travel_point/theme/theme.dart';
import 'package:travel_point/ui/layout/bottomBar.dart';
import 'package:travel_point/ui/layout/topBar.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TravelPoint',
      theme: themeTravelPoint,
      home: const MyNavigationBar(),
    );
  }
}

class MyNavigationBar extends StatefulWidget {
  const MyNavigationBar({Key? key}) : super(key: key);

  @override
  _MyNavigationBarState createState() => _MyNavigationBarState();
}

// proba
class _MyNavigationBarState extends State<MyNavigationBar> {
  int _selectedIndex = 0;

  static final List<Widget> _widgetOptions = <Widget>[
    Text('Home Page', style: themeTravelPoint.textTheme.headlineLarge),
    Text('Find Home', style: themeTravelPoint.textTheme.headlineLarge),
    Text('Near Me', style: themeTravelPoint.textTheme.headlineLarge),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TopBarApp(),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBarApp(
          onItemTapped: _onItemTapped, selectedIndex: _selectedIndex),
    );
  }
}
