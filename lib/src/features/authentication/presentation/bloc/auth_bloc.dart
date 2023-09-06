import 'package:bloc/bloc.dart';
import 'package:travel_point/src/features/authentication/domain/usecase/login_user.dart';
import 'package:travel_point/src/features/authentication/domain/usecase/signup_user.dart';
import 'package:travel_point/src/features/authentication/presentation/bloc/auth_event.dart';
import 'package:travel_point/src/features/authentication/presentation/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUserUsecase _loginUserUsecase;
  final SignupUserUsecase _signupUserUsecase;

  AuthBloc(this._loginUserUsecase, this._signupUserUsecase)
      : super(const InitialAuthState()) {
    on<LoginAuthEvent>(_loginUserHandler);

    on<SignupAuthEvent>(_signUpUserHandler);
  }

  Future<void> _loginUserHandler(
      LoginAuthEvent event, Emitter<AuthState> emitter) async {
    emit(const LoadingAuthState());

    final result = await _loginUserUsecase(
        LoginParams(email: event.email, password: event.password));

    result.fold(
        (failure) =>
            emit(ErrorAuthState(failure.errorMessage, failure.errorCode)),
        (success) => null);
  }

  Future<void> _signUpUserHandler(
      SignupAuthEvent event, Emitter<AuthState> emitter) async {
    emit(const LoadingAuthState());

    final result = await _signupUserUsecase(CreateUserParams(
        displayName: event.displayName,
        email: event.email,
        password: event.password,
        confirmationPassword: event.confirmationPassword));

    result.fold(
        (failure) =>
            emit(ErrorAuthState(failure.errorMessage, failure.errorCode)),
        (success) => null);
  }
}
