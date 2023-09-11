import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travel_point/src/features/authentication/domain/entity/user.dart';
import 'package:travel_point/src/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:travel_point/src/features/authentication/presentation/bloc/auth_event.dart';

class UserInfoPage extends StatefulWidget {
  const UserInfoPage({Key? key}) : super(key: key);

  @override
  _UserInfoPage createState() => _UserInfoPage();
}

class _UserInfoPage extends State<UserInfoPage> {
  UserEntity? userData;
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
  Widget build(BuildContext context) {
      return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
      ),
      body: error == null?
      Column(
        //add style
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 20),
                        const Icon(Icons.person,size: 100,),
                        const SizedBox(height: 20),
                        Text(
                          //userData?.displayName ?? 'Display Name: N/A',
                          FirebaseAuth.instance.currentUser?.displayName ?? 'Display Name: N/A',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            
                          ),
                          
                        ),
                        const SizedBox(height: 20),
                        Text(
                          userData?.dateCreated != null
                              ? 'Date Created: ${userData!.dateCreated.toDate().toIso8601String()}'
                              : 'Date Created: N/A',
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 14),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          userData?.dateModified != null
                              ? 'Date Modified: ${userData!.dateModified!.toDate().toIso8601String()}'
                              : 'Date Modified: N/A',
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 14),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Email Verified: ${FirebaseAuth.instance.currentUser?.emailVerified}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 14),
                        ),
                        FirebaseAuth.instance.currentUser?.emailVerified == false
                            ? TextButton(
                                onPressed: () => handleEmailVerify(context),
                                child: const Text('Verify email!',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.redAccent)),
                              )
                            : const Text('')
                      ],
                    ): Text(error ?? 'error'),
      );
  }
}