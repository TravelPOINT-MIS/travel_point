import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:travel_point/src/features/authentication/data/datasource/auth_remote_data_source.dart';
import 'package:travel_point/src/features/authentication/data/repository/auth_repository_impl.dart';
import 'package:travel_point/src/features/authentication/domain/repository/auth_repository.dart';
import 'package:travel_point/src/features/authentication/domain/usecase/check_email_verify_user.dart';
import 'package:travel_point/src/features/authentication/domain/usecase/email_verify_user.dart';
import 'package:travel_point/src/features/authentication/domain/usecase/login_user.dart';
import 'package:travel_point/src/features/authentication/domain/usecase/login_user_with_google.dart';
import 'package:travel_point/src/features/authentication/domain/usecase/logout_user.dart';
import 'package:travel_point/src/features/authentication/domain/usecase/signup_user.dart';
import 'package:travel_point/src/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:travel_point/src/features/map/data/datasource/map_remote_data_source.dart';
import 'package:travel_point/src/features/map/data/repository/map_repository_impl.dart';
import 'package:travel_point/src/features/map/domain/repository/map_repository.dart';
import 'package:travel_point/src/features/map/domain/usecase/get_user_current_location.dart';
import 'package:travel_point/src/features/map/presentation/bloc/map_bloc.dart';

final sl = GetIt.instance;

Future<void> initializeDependencies() async {
  sl.registerSingleton<Dio>(Dio());

  sl.registerSingleton<FirebaseAuth>(FirebaseAuth.instance);

  sl.registerSingleton<FirebaseFirestore>(FirebaseFirestore.instance);

  sl.registerSingleton<GoogleSignIn>(GoogleSignIn());

  sl.registerSingleton<AuthRemoteDataSource>(
      AuthRemoteDataSourceImpl(sl(), sl(), sl()));

  sl.registerSingleton<MapRemoteDataSource>(MapRemoteDataSourceImpl());

  sl.registerSingleton<AuthRepository>(AuthRepositoryImpl(sl()));

  sl.registerSingleton<MapRepository>(MapRepositoryImpl(sl()));

  sl.registerSingleton<LoginUserUsecase>(LoginUserUsecase(sl()));

  sl.registerSingleton<SignupUserUsecase>(SignupUserUsecase(sl()));

  sl.registerSingleton<LoginUserWithGoogleUsecase>(
      LoginUserWithGoogleUsecase(sl()));

  sl.registerSingleton<LogoutUserUsecase>(LogoutUserUsecase(sl()));

  sl.registerSingleton<CheckEmailVerifyUserUsecase>(
      CheckEmailVerifyUserUsecase(sl()));

  sl.registerSingleton<EmailVerifyUserUsecase>(EmailVerifyUserUsecase(sl()));

  sl.registerFactory<AuthBloc>(
      () => AuthBloc(sl(), sl(), sl(), sl(), sl(), sl()));

  sl.registerSingleton<GetUserCurrentLocationUsecase>(
      GetUserCurrentLocationUsecase(sl()));

  sl.registerFactory<MapBloc>(() => MapBloc(sl()));
}
