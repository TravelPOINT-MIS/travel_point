import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travel_point/core/widgets/error_snackbar.dart';
import 'package:travel_point/injection_container.dart';
import 'package:travel_point/src/features/authentication/domain/entity/user.dart';
import 'package:travel_point/src/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:travel_point/src/features/authentication/presentation/bloc/auth_event.dart';
import 'package:travel_point/src/features/authentication/presentation/bloc/auth_state.dart';
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
  bool hideVerifyEmail = false;
  Timer? timer;
  UserEntity? userData;
  String? error;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void checkEmailVerification(BuildContext context) {
    timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      final authBloc = BlocProvider.of<AuthBloc>(context);

      const checkEmailVerifyEvent = CheckEmailVerifyUserAuthEvent();

      authBloc.add(checkEmailVerifyEvent);
    });
  }

  void handleEmailVerify(context) {
    ScaffoldMessenger.of(context).clearSnackBars();

    final authBloc = BlocProvider.of<AuthBloc>(context);

    const emailVerifyEvent = EmailVerifyUserAuthEvent();

    authBloc.add(emailVerifyEvent);

    checkEmailVerification(context);
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget defaultScreen(AuthState state) {
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
                    'Email Verified: ${FirebaseAuth.instance.currentUser!.emailVerified}',
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  !hideVerifyEmail
                      ? TextButton(
                          onPressed: () => handleEmailVerify(context),
                          child: const Text(
                            'Verify email!',
                            style: TextStyle(color: Colors.redAccent),
                          ),
                        )
                      : const Text(''),
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

    return BlocBuilder<AuthBloc, AuthState>(builder: (_, state) {
      if (state is CheckEmailVerifyState) {
        if (state.isEmailVerified) {
          timer?.cancel();
        }
      }

      return Stack(
        children: [
          AbsorbPointer(
            absorbing:
                state is LoadingAuthState || state is LoggingOutAuthState,
            child: defaultScreen(state),
          ),
          if (state is LoadingAuthState || state is LoggingOutAuthState)
            AlertDialog(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 16),
                  Text((state is LoadingAuthState)
                      ? "Setting up..."
                      : "Logging out..."),
                ],
              ),
            ),
          if (state is ErrorAuthState)
            ErrorSnackbarWidget(
              errorCode: state.errorCode,
              errorMessage: state.errorMessage,
              context: context,
            )
        ],
      );
    });
  }
}
