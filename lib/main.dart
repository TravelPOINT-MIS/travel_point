import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:travel_point/model/user_data_model.dart';
import 'package:travel_point/theme/theme.dart';
import 'package:travel_point/ui/layout/bottom_bar.dart';
import 'package:travel_point/ui/layout/top_bar.dart';
import 'package:travel_point/ui/page/map_page.dart';
import 'package:travel_point/user/auth_user.dart';
import 'package:travel_point/user/user_service.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TravelPoint',
      theme: themeTravelPoint,
      home: const AuthUser(),
    );
  }
}

class MainNavigationPage extends StatefulWidget {
  const MainNavigationPage({Key? key}) : super(key: key);

  @override
  _MainNavigationPageState createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends State<MainNavigationPage> {
  int _selectedIndex = 0;
  UserData? test;

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
  void initState() {
    super.initState();
    getDate();
  }

  getDate() async {
    final test1 = await UserService.getUserDocument(
        FirebaseAuth.instance.currentUser!.uid);
    setState(() {
      test = test1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TopBarApp(),
      // TO BE REMOVED
      body: Column(
        children: [
          Text(
            test?.displayName ?? 'Display Name: N/A',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            test?.dateCreated != null
                ? 'Date Created: ${test!.dateCreated.toDate().toIso8601String()}'
                : 'Date Created: N/A',
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            test?.dateModified != null
                ? 'Date Modified: ${test!.dateModified!.toDate().toIso8601String()}'
                : 'Date Modified: N/A',
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Email Verified: ${test?.emailVerified ?? false}',
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
          const Expanded(
            child: MapPage(),
          ),

        ],
      ),
      bottomNavigationBar: BottomNavigationBarApp(
          onItemTapped: _onItemTapped, selectedIndex: _selectedIndex),
    );
  }
}
