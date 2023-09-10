import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travel_point/core/widgets/drawer_bar.dart';
import 'package:travel_point/injection_container.dart';
import 'package:travel_point/core/widgets/bottom_bar.dart';
import 'package:travel_point/core/widgets/top_bar.dart';
import 'package:travel_point/src/features/map/presentation/bloc/map_bloc.dart';
import 'package:travel_point/src/features/map/presentation/views/map_page.dart';


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  String? error;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }


  @override
  Widget build(BuildContext context) {
    // Widget defaultScreen(AuthState state) {
      return Scaffold(
        appBar: const TopBarApp(),
        endDrawer: const DrawerMenu(),
        // TO BE REMOVED
        body: error == null
            ? Column(
                children: [
                  BlocProvider<MapBloc>(
                      create: (context) => sl(),
                      child: const Expanded(
                        child: MapPage(),
                      ))
                ],
              )
            : Text(error ?? 'error'),
        bottomNavigationBar: BottomNavigationBarApp(
            onItemTapped: _onItemTapped, selectedIndex: _selectedIndex),
      );
    }
  }
