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
  const LoadingAuthState();
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
