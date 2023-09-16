import 'dart:async';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travel_point/injection_container.dart';
import 'package:travel_point/src/features/authentication/domain/entity/user.dart';
import 'package:travel_point/src/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:travel_point/src/features/authentication/presentation/bloc/auth_event.dart';
import 'package:travel_point/src/features/authentication/presentation/bloc/auth_state.dart';

class UserInfoPage extends StatefulWidget {
  final UserEntity? userEntity;

  const UserInfoPage({Key? key, this.userEntity}) : super(key: key);

  @override
  _UserInfoPageState createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage> {
  String? error;
  bool hideVerifyEmail = false;
  Timer? timer;

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
          appBar: AppBar(
            title: const Text('Profile'),
            centerTitle: true,
          ),
          body: Column(
            //review first then delete commented text
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              const Icon(
                Icons.person,
                size: 100,
                color: Colors.black54,
              ),
              const SizedBox(height: 20),
              Text(
                widget.userEntity?.displayName ?? 'Display Name: N/A',
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54),
              ),
              const SizedBox(height: 20),
              Text(
                widget.userEntity?.dateCreated != null
                    ? 'Date Created: ${DateFormat('yyyy-MM-dd HH:mm:ss').format(widget.userEntity!.dateCreated.toDate())}'
                    : 'Date Created: N/A',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 20),
              Text(
                widget.userEntity?.dateModified != null
                    ? 'Date Modified: ${DateFormat('yyyy-MM-dd HH:mm:ss').format(widget.userEntity!.dateModified!.toDate())}'
                    : 'Date Modified: N/A',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Email verified: ',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black54),
                  ),
                  widget.userEntity?.emailVerified == true
                      ? Icon(
                          Icons.check,
                          size: 15,
                          color: Theme.of(context).primaryColor,
                        )
                      : Icon(
                          Icons.close,
                          size: 15,
                          color: Theme.of(context).primaryColor,
                        ),
                ],
              ),
            ],
          ));
    }

    return BlocProvider<AuthBloc>(
        create: (context) => sl(),
        child: BlocBuilder<AuthBloc, AuthState>(builder: (_, state) {
          if (state is CheckEmailVerifyState) {
            if (state.isEmailVerified) {
              timer?.cancel();
            }
          }

          return defaultScreen(state);
        }));
  }
}
