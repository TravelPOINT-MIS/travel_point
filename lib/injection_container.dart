import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:travel_point/src/features/authentication/data/datasource/auth_remote_data_source.dart';
import 'package:travel_point/src/features/authentication/data/repository/auth_repository_impl.dart';
import 'package:travel_point/src/features/authentication/domain/repository/auth_repository.dart';
import 'package:travel_point/src/features/authentication/domain/usecase/login_user.dart';
import 'package:travel_point/src/features/authentication/domain/usecase/login_user_with_google.dart';
import 'package:travel_point/src/features/authentication/domain/usecase/logout_user.dart';
import 'package:travel_point/src/features/authentication/domain/usecase/signup_user.dart';
import 'package:travel_point/src/features/authentication/presentation/bloc/auth_bloc.dart';

final sl = GetIt.instance;

Future<void> initializeDependencies() async {
  sl.registerSingleton<Dio>(Dio());

  sl.registerSingleton<FirebaseAuth>(FirebaseAuth.instance);

  sl.registerSingleton<FirebaseFirestore>(FirebaseFirestore.instance);

  sl.registerSingleton<GoogleSignIn>(GoogleSignIn());

  sl.registerSingleton<AuthRemoteDataSource>(
      AuthRemoteDataSourceImpl(sl(), sl(), sl()));

  sl.registerSingleton<AuthRepository>(AuthRepositoryImpl(sl()));

  sl.registerSingleton<LoginUserUsecase>(LoginUserUsecase(sl()));

  sl.registerSingleton<SignupUserUsecase>(SignupUserUsecase(sl()));

  sl.registerSingleton<LoginUserWithGoogleUsecase>(
      LoginUserWithGoogleUsecase(sl()));

  sl.registerSingleton<LogoutUserUsecase>(LogoutUserUsecase(sl()));

  sl.registerFactory<AuthBloc>(() => AuthBloc(sl(), sl(), sl(), sl()));
}
