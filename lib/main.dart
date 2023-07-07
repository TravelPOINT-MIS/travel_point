import 'package:flutter/material.dart';
import 'package:travel_point/logIn.dart';
  
void main() => runApp(MyApp());  
  
/// This Widget is the main application widget.  
class MyApp extends StatelessWidget {  
  @override  
  Widget build(BuildContext context) {  
    return MaterialApp(  
      home: MyNavigationBar (),
    );  
  }  
}  
  
class MyNavigationBar extends StatefulWidget {  
  MyNavigationBar ({Key? key}) : super(key: key);  
  
  @override  
  _MyNavigationBarState createState() => _MyNavigationBarState();  
}  
  //proba
class _MyNavigationBarState extends State<MyNavigationBar > {  
  int _selectedIndex = 0;  
  static const List<Widget> _widgetOptions = <Widget>[  
    Text('Home Page', style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold)),  
    Text('Search Page', style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold)),  
    Text('Profile Page', style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold)),  
  ];  
  
  void _onItemTapped(int index) {  
    setState(() {  
      _selectedIndex = index;  
    });  
  }  
  
  @override  
  Widget build(BuildContext context) {  
    return Scaffold(  
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.person),
            tooltip: 'User Icon',
            onPressed: () {
              Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LoginPage()),
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
          backgroundColor:Colors.redAccent,  
      ),  
      body: Center(  
        child: _widgetOptions.elementAt(_selectedIndex),  
      ),  
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.redAccent, 
        unselectedItemColor: Colors.white38,  
        items: const <BottomNavigationBarItem>[  
          BottomNavigationBarItem(  
            icon: Icon(Icons.public_outlined),  
            label: 'Explore',  
            backgroundColor: Colors.redAccent,   
          ),  
          BottomNavigationBarItem(  
            icon: Icon(Icons.home_outlined),  
            label: 'Find home',  
            backgroundColor: Colors.redAccent, 
          ),  
          BottomNavigationBarItem(  
            icon: Icon(Icons.location_on_outlined),  
            label: 'Near me',  
            backgroundColor: Colors.redAccent,  
          ),  
        ],  
        type: BottomNavigationBarType.fixed,  
        currentIndex: _selectedIndex,  
        selectedItemColor: Colors.white,  
        iconSize: 40,  
        onTap: _onItemTapped,  
        elevation: 5  
      ),  
    );  
  }  
}
