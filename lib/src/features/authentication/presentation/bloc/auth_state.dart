import 'package:equatable/equatable.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class InitialAuthState extends AuthState {
  const InitialAuthState();
}

class LoadingAuthState extends AuthState {
  final String loadingMessage;

  const LoadingAuthState({String? loadingMessage})
      : loadingMessage = loadingMessage ?? 'Loading...';
}

class ResultAuthState extends AuthState {
  const ResultAuthState();
}

class ErrorAuthState extends AuthState {
  const ErrorAuthState(this.errorMessage, this.errorCode);

  final String errorMessage;
  final String errorCode;

  @override
  List<Object?> get props => [errorMessage, errorCode];
}

class CheckEmailVerifyState extends AuthState {
  const CheckEmailVerifyState(this.isEmailVerified);

  final bool isEmailVerified;

  @override
  List<Object?> get props => [isEmailVerified];
}
