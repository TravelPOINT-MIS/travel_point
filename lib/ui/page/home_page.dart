import 'dart:async';
import 'package:flutter/material.dart';
import 'package:travel_point/model/user_data_model.dart';
import 'package:travel_point/theme/theme.dart';
import 'package:travel_point/ui/layout/bottom_bar.dart';
import 'package:travel_point/ui/layout/top_bar.dart';
import 'package:travel_point/ui/page/map_page.dart';
import 'package:travel_point/user/user_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  bool hideVerifyEmail = UserService.isCurrentUserEmailVerified();
  Timer? timer;
  UserData? userData;

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

  // TODO Proof of concept -> to be refactored
  @override
  void initState() {
    super.initState();
    getInitData();
  }

  getInitData() async {
    final userDataFromDoc = await UserService.getCurrentUserDocument();

    print(userDataFromDoc);

    setState(() {
      userData = userDataFromDoc;
    });
  }

  void sendEmailVerification() {
    UserService.sendCurrentUserVerificationEmail();

    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        });

    timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      UserService.checkCurrentUserEmailVerified().then((isVerified) {
        if (isVerified) {
          timer.cancel();

          setState(() {
            hideVerifyEmail = true;
          });

          Navigator.of(context).pop();
        }
      });
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TopBarApp(),
      // TO BE REMOVED
      body: Column(
        children: [
          Text(
            userData?.displayName ?? 'Display Name: N/A',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            userData?.dateCreated != null
                ? 'Date Created: ${userData!.dateCreated.toDate().toIso8601String()}'
                : 'Date Created: N/A',
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            userData?.dateModified != null
                ? 'Date Modified: ${userData!.dateModified!.toDate().toIso8601String()}'
                : 'Date Modified: N/A',
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Email Verified: ${UserService.isCurrentUserEmailVerified()}',
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
          !hideVerifyEmail
              ? TextButton(
                  onPressed: sendEmailVerification,
                  child: const Text(
                    'Verify email!',
                    style: TextStyle(color: Colors.redAccent),
                  ),
                )
              : const Text(''),
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
