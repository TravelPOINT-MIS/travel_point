import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class LoginAuthEvent extends AuthEvent {
  const LoginAuthEvent({required this.email, required this.password});

  final String email;
  final String password;

  @override
  List<Object?> get props => [email, password];
}

class SignupAuthEvent extends AuthEvent {
  final String displayName;
  final String email;
  final String password;
  final String confirmationPassword;

  const SignupAuthEvent(
      {required this.displayName,
      required this.email,
      required this.password,
      required this.confirmationPassword});

  @override
  List<Object?> get props =>
      [displayName, email, password, confirmationPassword];
}

class LoginWithGoogleAuthEvent extends AuthEvent {
  const LoginWithGoogleAuthEvent();
}

class LogoutUserAuthEvent extends AuthEvent {
  const LogoutUserAuthEvent();
}
