import 'dart:async';
import 'package:flutter/material.dart';
import 'package:travel_point/src/features/authentication/domain/entity/user.dart';
import 'package:travel_point/config/theme.dart';
import 'package:travel_point/src/features/authentication/domain/usecase/login_user.dart';
import 'package:travel_point/src/ui/layout/bottom_bar.dart';
import 'package:travel_point/src/ui/layout/top_bar.dart';
import 'package:travel_point/src/ui/page/map_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  bool hideVerifyEmail = true;
  Timer? timer;
  UserEntity? userData;
  String? error;
  late final LoginUserUsecase authUsecase;

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
    getInitData();
    super.initState();
  }

  getInitData() async {
    // // TODO no user is shown because the listener is triggered immediately after sign up since we dont use custom navigation and rely on .authStateChange()..
    // final userDataFromDoc = await authUsecase.getCurrentUser();
    //
    // setState(() {
    //   userDataFromDoc.fold((l) {
    //     error = l.errorMessage;
    //   }, (r) {
    //     userData = r;
    //   });
    // });
  }

  void sendEmailVerification() {
    // AuthService.sendCurrentUserVerificationEmail();
    //
    // showDialog(
    //     barrierDismissible: false,
    //     context: context,
    //     builder: (context) {
    //       return const Center(
    //         child: CircularProgressIndicator(),
    //       );
    //     });
    //
    // timer = Timer.periodic(const Duration(seconds: 2), (timer) {
    //   AuthService.checkCurrentUserEmailVerified().then((isVerified) {
    //     if (isVerified) {
    //       timer.cancel();
    //
    //       setState(() {
    //         hideVerifyEmail = true;
    //       });
    //
    //       Navigator.of(context).pop();
    //     }
    //   });
    // });
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
      body: error == null
          ? Column(
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
                      ? 'Date Created: ${userData!.dateCreated?.toDate().toIso8601String()}'
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
                  'Email Verified: ',
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
            )
          : Text(error ?? 'error'),
      bottomNavigationBar: BottomNavigationBarApp(
          onItemTapped: _onItemTapped, selectedIndex: _selectedIndex),
    );
  }
}
