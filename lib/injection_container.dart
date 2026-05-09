import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:meshwark_rider/core/constants/constants.dart';
import 'package:meshwark_rider/core/network/api_client.dart';
import 'package:meshwark_rider/features/auth/data/datasources/auth_datasource.dart';
import 'package:meshwark_rider/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:meshwark_rider/features/auth/domain/repositories/auth_repository.dart';
import 'package:meshwark_rider/features/auth/domain/usecases/auth_usecases.dart';
import 'package:meshwark_rider/features/auth/presentation/bloc/login_bloc.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  // Core
  sl.registerLazySingleton<Dio>(() {
    final dio = Dio(BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      receiveTimeout: const Duration(milliseconds: ApiConstants.apiTimeOut),
      sendTimeout: const Duration(milliseconds: ApiConstants.apiTimeOut),
      headers: {
        'content-type': 'application/json',
        'accept': 'application/json'
      },
    ));
    return dio;
  });

  sl.registerLazySingleton<ApiClient>(() => ApiClient(sl()));

  // Auth Feature
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(sl()),
  );

  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl()),
  );

  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => RegisterUseCase(sl()));
  sl.registerLazySingleton(() => ForgotPasswordUseCase(sl()));
  sl.registerLazySingleton(() => VerifyCodeUseCase(sl()));
  sl.registerLazySingleton(() => GetCurrentUserUseCase(sl()));
  sl.registerLazySingleton(() => LogoutUseCase(sl()));

  sl.registerFactory(
    () => LoginBloc(
      loginUseCase: sl(),
      logoutUseCase: sl(),
    ),
  );
}
