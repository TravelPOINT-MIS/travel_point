import 'package:bloc/bloc.dart';
import 'package:travel_point/src/features/authentication/domain/usecase/login_user.dart';
import 'package:travel_point/src/features/authentication/domain/usecase/login_user_with_google.dart';
import 'package:travel_point/src/features/authentication/domain/usecase/signup_user.dart';
import 'package:travel_point/src/features/authentication/presentation/bloc/auth_event.dart';
import 'package:travel_point/src/features/authentication/presentation/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUserUsecase _loginUserUsecase;
  final SignupUserUsecase _signupUserUsecase;
  final LoginUserWithGoogleUsecase _loginUserWithGoogleUsecase;

  AuthBloc(this._loginUserUsecase, this._signupUserUsecase,
      this._loginUserWithGoogleUsecase)
      : super(const InitialAuthState()) {
    on<LoginAuthEvent>(_loginUserHandler);

    on<SignupAuthEvent>(_signUpUserHandler);

    on<LoginWithGoogleAuthEvent>(_loginWithGoogleHandler);
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

  Future<void> _loginWithGoogleHandler(
      LoginWithGoogleAuthEvent event, Emitter<AuthState> emitter) async {
    emit(const LoadingAuthState());

    final result = await _loginUserWithGoogleUsecase();

    result.fold(
        (failure) =>
            emit(ErrorAuthState(failure.errorMessage, failure.errorCode)),
        (success) => null);
  }
}
