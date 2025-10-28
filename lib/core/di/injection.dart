import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';

import '../../src/features/authentication/data/datasources/auth_local_datasource.dart';
import '../../src/features/authentication/data/datasources/auth_remote_datasource.dart';
import '../../src/features/authentication/data/repositories/auth_repository_impl.dart';
import '../../src/features/authentication/domain/repositories/auth_repository.dart';
import '../../src/features/authentication/domain/usecases/forgot_password.dart';
import '../../src/features/authentication/domain/usecases/get_current_user.dart';
import '../../src/features/authentication/domain/usecases/sign_in.dart';
import '../../src/features/authentication/domain/usecases/sign_out.dart';
import '../../src/features/authentication/domain/usecases/sign_up.dart';
import '../../src/features/authentication/domain/usecases/verify_otp.dart';
import '../../src/features/authentication/presentation/providers/auth_provider.dart';
import '../network/api_client.dart';
import '../network/network_info.dart';
import '../storage/secure_storage.dart';

final getIt = GetIt.instance;

Future<void> setupDependencies() async {
  await _setupCore();
  await _setupAuthentication();
}

Future<void> _setupCore() async {
  getIt.registerLazySingleton(() => ApiClient.create());

  getIt.registerLazySingleton(() => Connectivity());

  getIt.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(getIt()),
  );

  const secureStorageOptions = AndroidOptions(
    encryptedSharedPreferences: true,
  );

  getIt.registerLazySingleton(
    () => const FlutterSecureStorage(aOptions: secureStorageOptions),
  );

  getIt.registerLazySingleton(
    () => SecureStorage(getIt()),
  );
}

Future<void> _setupAuthentication() async {
  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(getIt()),
  );

  getIt.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(getIt()),
  );

  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: getIt(),
      localDataSource: getIt(),
      networkInfo: getIt(),
      apiClient: getIt(),
    ),
  );

  getIt.registerLazySingleton(() => SignIn(getIt()));
  getIt.registerLazySingleton(() => SignUp(getIt()));
  getIt.registerLazySingleton(() => SignOut(getIt()));
  getIt.registerLazySingleton(() => GetCurrentUser(getIt()));
  getIt.registerLazySingleton(() => ForgotPassword(getIt()));
  getIt.registerLazySingleton(() => VerifyOtp(getIt()));

  getIt.registerFactory(
    () => AuthProvider(
      signInUseCase: getIt(),
      signUpUseCase: getIt(),
      signOutUseCase: getIt(),
      getCurrentUserUseCase: getIt(),
      forgotPasswordUseCase: getIt(),
      verifyOtpUseCase: getIt(),
    ),
  );
}
