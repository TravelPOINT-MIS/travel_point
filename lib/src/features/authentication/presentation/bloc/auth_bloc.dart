import 'package:bloc/bloc.dart';
import 'package:travel_point/src/features/authentication/domain/usecase/check_email_verify_user.dart';
import 'package:travel_point/src/features/authentication/domain/usecase/email_verify_user.dart';
import 'package:travel_point/src/features/authentication/domain/usecase/login_user.dart';
import 'package:travel_point/src/features/authentication/domain/usecase/login_user_with_google.dart';
import 'package:travel_point/src/features/authentication/domain/usecase/logout_user.dart';
import 'package:travel_point/src/features/authentication/domain/usecase/signup_user.dart';
import 'package:travel_point/src/features/authentication/presentation/bloc/auth_event.dart';
import 'package:travel_point/src/features/authentication/presentation/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUserUsecase _loginUserUsecase;
  final SignupUserUsecase _signupUserUsecase;
  final LoginUserWithGoogleUsecase _loginUserWithGoogleUsecase;
  final LogoutUserUsecase _logoutUserUsecase;
  final CheckEmailVerifyUserUsecase _checkEmailVerifyUserUsecase;
  final EmailVerifyUserUsecase _emailVerifyUserUsecase;

  AuthBloc(
      this._loginUserUsecase,
      this._signupUserUsecase,
      this._loginUserWithGoogleUsecase,
      this._logoutUserUsecase,
      this._checkEmailVerifyUserUsecase,
      this._emailVerifyUserUsecase)
      : super(const InitialAuthState()) {
    on<LoginAuthEvent>(_loginUserHandler);

    on<SignupAuthEvent>(_signUpUserHandler);

    on<LoginWithGoogleAuthEvent>(_loginWithGoogleHandler);

    on<LogoutUserAuthEvent>(_logoutUserHandler);

    on<CheckEmailVerifyUserAuthEvent>(_checkEmailVerifyUserHandler);

    on<EmailVerifyUserAuthEvent>(_emailVerifyUserHandler);
  }

  Future<void> _loginUserHandler(
      LoginAuthEvent event, Emitter<AuthState> emitter) async {
    emit(const LoadingAuthState(loadingMessage: 'Logging in user..'));

    final result = await _loginUserUsecase(
        LoginParams(email: event.email, password: event.password));

    result.fold(
        (failure) =>
            emit(ErrorAuthState(failure.errorMessage, failure.errorCode)),
        (success) => emit(const InitialAuthState()));
  }

  Future<void> _signUpUserHandler(
      SignupAuthEvent event, Emitter<AuthState> emitter) async {
    emit(const LoadingAuthState(loadingMessage: 'Setting up user..'));

    final result = await _signupUserUsecase(CreateUserParams(
        displayName: event.displayName,
        email: event.email,
        password: event.password,
        confirmationPassword: event.confirmationPassword));

    result.fold(
        (failure) =>
            emit(ErrorAuthState(failure.errorMessage, failure.errorCode)),
        (success) => emit(const InitialAuthState()));
  }

  Future<void> _loginWithGoogleHandler(
      LoginWithGoogleAuthEvent event, Emitter<AuthState> emitter) async {
    emit(const LoadingAuthState(loadingMessage: 'Setting google account..'));

    final result = await _loginUserWithGoogleUsecase();

    result.fold(
        (failure) =>
            emit(ErrorAuthState(failure.errorMessage, failure.errorCode)),
        (success) => emit(const InitialAuthState()));
  }

  Future<void> _logoutUserHandler(
      LogoutUserAuthEvent event, Emitter<AuthState> emitter) async {
    emit(const LoadingAuthState(loadingMessage: 'Logging out user..'));

    final result = await _logoutUserUsecase();

    result.fold(
        (failure) =>
            emit(ErrorAuthState(failure.errorMessage, failure.errorCode)),
        (success) => emit(const InitialAuthState()));
  }

  Future<void> _checkEmailVerifyUserHandler(
      CheckEmailVerifyUserAuthEvent event, Emitter<AuthState> emitter) async {
    emit(const InitialAuthState());

    final result = await _checkEmailVerifyUserUsecase();

    result.fold(
        (failure) =>
            emit(ErrorAuthState(failure.errorMessage, failure.errorCode)),
        (isEmailVerified) => emit(CheckEmailVerifyState(isEmailVerified)));
  }

  Future<void> _emailVerifyUserHandler(
      EmailVerifyUserAuthEvent event, Emitter<AuthState> emitter) async {
    emit(
        const LoadingAuthState(loadingMessage: 'Sending email verification..'));

    final result = await _emailVerifyUserUsecase();

    result.fold(
        (failure) =>
            emit(ErrorAuthState(failure.errorMessage, failure.errorCode)),
        (success) => emit(const InitialAuthState()));
  }
}
