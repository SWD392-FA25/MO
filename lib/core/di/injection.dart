import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';

import '../../src/features/authentication/data/datasources/auth_local_datasource.dart';
import '../../src/features/authentication/data/datasources/auth_remote_datasource.dart';
import '../../src/features/authentication/data/repositories/auth_repository_impl.dart';
import '../../src/features/authentication/domain/repositories/auth_repository.dart';
import '../../src/features/authentication/domain/usecases/forgot_password.dart';
import '../../src/features/authentication/domain/usecases/get_current_user.dart';
import '../../src/features/authentication/domain/usecases/google_sign_in.dart';
import '../../src/features/authentication/domain/usecases/sign_in.dart';
import '../../src/features/authentication/domain/usecases/sign_out.dart';
import '../../src/features/authentication/domain/usecases/sign_up.dart';
import '../../src/features/authentication/domain/usecases/verify_otp.dart';
import '../../src/features/authentication/presentation/providers/auth_provider.dart';
import '../../src/features/catalog/data/datasources/course_remote_datasource.dart';
import '../../src/features/catalog/data/repositories/course_repository_impl.dart';
import '../../src/features/catalog/domain/repositories/course_repository.dart';
import '../../src/features/catalog/domain/usecases/get_course_detail.dart';
import '../../src/features/catalog/domain/usecases/get_course_lessons.dart';
import '../../src/features/catalog/domain/usecases/get_courses.dart';
import '../../src/features/catalog/presentation/providers/course_provider.dart';
import '../../src/features/catalog/presentation/providers/livestream_provider.dart';
import '../../src/features/catalog/presentation/providers/package_provider.dart';
import '../../src/features/my_courses/data/datasources/enrollment_remote_datasource.dart';
import '../../src/features/my_courses/presentation/providers/enrollment_provider.dart';
import '../../src/features/my_courses/presentation/providers/my_course_provider.dart';
import '../../src/features/profile/presentation/providers/profile_provider.dart';
import '../../src/features/quiz/presentation/providers/quiz_provider.dart';
import '../../src/features/transactions/presentation/providers/order_provider.dart';
import '../../src/features/transactions/presentation/providers/payment_provider.dart';
import '../../src/features/my_courses/data/datasources/my_course_remote_datasource.dart';
import '../../src/features/my_courses/data/repositories/enrollment_repository_impl.dart';
import '../../src/features/my_courses/data/repositories/my_course_repository_impl.dart';
import '../../src/features/my_courses/domain/repositories/enrollment_repository.dart';
import '../../src/features/my_courses/domain/repositories/my_course_repository.dart';
import '../../src/features/my_courses/domain/usecases/complete_lesson.dart';
import '../../src/features/my_courses/domain/usecases/get_course_progress.dart';
import '../../src/features/my_courses/domain/usecases/get_my_course_lessons.dart';
import '../../src/features/my_courses/domain/usecases/get_my_enrollments.dart';
import '../../src/features/profile/data/datasources/profile_remote_datasource.dart';
import '../../src/features/profile/data/repositories/profile_repository_impl.dart';
import '../../src/features/profile/domain/repositories/profile_repository.dart';
import '../../src/features/profile/domain/usecases/get_profile.dart';
import '../../src/features/profile/domain/usecases/update_profile.dart';
import '../../src/features/transactions/data/datasources/order_remote_datasource.dart';
import '../../src/features/transactions/data/datasources/payment_remote_datasource.dart';
import '../../src/features/transactions/data/repositories/order_repository_impl.dart';
import '../../src/features/transactions/data/repositories/payment_repository_impl.dart';
import '../../src/features/transactions/domain/repositories/order_repository.dart';
import '../../src/features/transactions/domain/repositories/payment_repository.dart';
import '../../src/features/transactions/domain/usecases/checkout_order.dart';
import '../../src/features/transactions/domain/usecases/create_order.dart';
import '../../src/features/transactions/domain/usecases/create_vnpay_checkout.dart';
import '../../src/features/transactions/domain/usecases/get_my_orders.dart';
import '../../src/features/catalog/data/datasources/package_remote_datasource.dart';
import '../../src/features/catalog/data/repositories/package_repository_impl.dart';
import '../../src/features/catalog/domain/repositories/package_repository.dart';
import '../../src/features/catalog/domain/usecases/get_package_detail.dart';
import '../../src/features/catalog/domain/usecases/get_packages.dart';
import '../../src/features/quiz/data/datasources/quiz_remote_datasource.dart';
import '../../src/features/quiz/data/repositories/quiz_repository_impl.dart';
import '../../src/features/quiz/domain/repositories/quiz_repository.dart';
import '../../src/features/quiz/domain/usecases/create_quiz_attempt.dart';
import '../../src/features/quiz/domain/usecases/get_my_quiz_attempts.dart';
import '../../src/features/quiz/domain/usecases/get_quiz_for_take.dart';
import '../../src/features/quiz/domain/usecases/submit_quiz_attempt.dart';
import '../../src/features/my_courses/data/datasources/assignment_remote_datasource.dart';
import '../../src/features/my_courses/data/repositories/assignment_repository_impl.dart';
import '../../src/features/my_courses/domain/repositories/assignment_repository.dart';
import '../../src/features/my_courses/domain/usecases/submit_assignment.dart';
import '../../src/features/catalog/data/datasources/livestream_remote_datasource.dart';
import '../../src/features/catalog/data/repositories/livestream_repository_impl.dart';
import '../../src/features/catalog/domain/repositories/livestream_repository.dart';
import '../../src/features/catalog/domain/usecases/get_livestream_detail.dart';
import '../../src/features/catalog/domain/usecases/get_livestreams.dart';
import '../../src/features/transactions/data/datasources/payment_method_remote_datasource.dart';
import '../../src/features/transactions/data/repositories/payment_method_repository_impl.dart';
import '../../src/features/transactions/domain/repositories/payment_method_repository.dart';
import '../../src/features/transactions/domain/usecases/get_active_payment_methods.dart';
import '../../src/features/transactions/domain/usecases/get_payment_methods.dart';
import '../network/api_client.dart';
import '../network/network_info.dart';
import '../storage/secure_storage.dart';

final getIt = GetIt.instance;

Future<void> setupDependencies() async {
  await _setupCore();
  await _setupAuthentication();
  await _setupCourses();
  await _setupMyCourses();
  await _setupEnrollments();
  await _setupOrders();
  await _setupPayments();
  await _setupPackages();
  await _setupProfile();
  await _setupQuizzes();
  await _setupAssignments();
  await _setupLivestreams();
  await _setupPaymentMethods();
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
  getIt.registerLazySingleton(() => GoogleSignIn(getIt()));
  getIt.registerLazySingleton(() => SignOut(getIt()));
  getIt.registerLazySingleton(() => GetCurrentUser(getIt()));
  getIt.registerLazySingleton(() => ForgotPassword(getIt()));
  getIt.registerLazySingleton(() => VerifyOtp(getIt()));

  getIt.registerFactory(
    () => AuthProvider(
      signInUseCase: getIt(),
      signUpUseCase: getIt(),
      googleSignInUseCase: getIt(),
      signOutUseCase: getIt(),
      getCurrentUserUseCase: getIt(),
      forgotPasswordUseCase: getIt(),
      verifyOtpUseCase: getIt(),
    ),
  );
}

Future<void> _setupCourses() async {
  getIt.registerLazySingleton<CourseRemoteDataSource>(
    () => CourseRemoteDataSourceImpl(getIt()),
  );

  getIt.registerLazySingleton<CourseRepository>(
    () => CourseRepositoryImpl(
      remoteDataSource: getIt(),
      networkInfo: getIt(),
    ),
  );

  getIt.registerLazySingleton(() => GetCourses(getIt()));
  getIt.registerLazySingleton(() => GetCourseDetail(getIt()));
  getIt.registerLazySingleton(() => GetCourseLessons(getIt()));
  getIt.registerLazySingleton(() => GetLessonDetail(getIt()));

  getIt.registerFactory(
    () => CourseProvider(
      getCoursesUseCase: getIt(),
      getCourseDetailUseCase: getIt(),
      getCourseLessonsUseCase: getIt(),
      getLessonDetailUseCase: getIt(),
    ),
  );

  getIt.registerFactory(
    () => PackageProvider(
      getPackagesUseCase: getIt(),
      getPackageDetailUseCase: getIt(),
    ),
  );

  getIt.registerFactory(
    () => LivestreamProvider(
      getLivestreamsUseCase: getIt(),
      getLivestreamDetailUseCase: getIt(),
    ),
  );
}

Future<void> _setupMyCourses() async {
  getIt.registerLazySingleton<MyCourseRemoteDataSource>(
    () => MyCourseRemoteDataSourceImpl(getIt()),
  );

  getIt.registerLazySingleton<MyCourseRepository>(
    () => MyCourseRepositoryImpl(
      remoteDataSource: getIt(),
      networkInfo: getIt(),
    ),
  );

  getIt.registerLazySingleton(() => GetMyCourseLessons(getIt()));
  getIt.registerLazySingleton(() => CompleteLesson(getIt()));
  getIt.registerLazySingleton(() => GetCourseProgress(getIt()));

  getIt.registerFactory(
    () => MyCourseProvider(
      getMyCourseLessonsUseCase: getIt(),
      completeLessonUseCase: getIt(),
      getCourseProgressUseCase: getIt(),
    ),
  );
}

Future<void> _setupEnrollments() async {
  getIt.registerLazySingleton<EnrollmentRemoteDataSource>(
    () => EnrollmentRemoteDataSourceImpl(getIt()),
  );

  getIt.registerLazySingleton<EnrollmentRepository>(
    () => EnrollmentRepositoryImpl(
      remoteDataSource: getIt(),
      networkInfo: getIt(),
    ),
  );

  getIt.registerLazySingleton(() => GetMyEnrollments(getIt()));

  getIt.registerFactory(
    () => EnrollmentProvider(getMyEnrollmentsUseCase: getIt()),
  );
}

Future<void> _setupOrders() async {
  getIt.registerLazySingleton<OrderRemoteDataSource>(
    () => OrderRemoteDataSourceImpl(getIt()),
  );

  getIt.registerLazySingleton<OrderRepository>(
    () => OrderRepositoryImpl(
      remoteDataSource: getIt(),
      networkInfo: getIt(),
    ),
  );

  getIt.registerLazySingleton(() => CreateOrder(getIt()));
  getIt.registerLazySingleton(() => GetMyOrders(getIt()));
  getIt.registerLazySingleton(() => CheckoutOrder(getIt()));

  getIt.registerFactory(
    () => OrderProvider(
      createOrderUseCase: getIt(),
      getMyOrdersUseCase: getIt(),
      checkoutOrderUseCase: getIt(),
    ),
  );
}

Future<void> _setupPayments() async {
  getIt.registerLazySingleton<PaymentRemoteDataSource>(
    () => PaymentRemoteDataSourceImpl(getIt()),
  );

  getIt.registerLazySingleton<PaymentRepository>(
    () => PaymentRepositoryImpl(
      remoteDataSource: getIt(),
      networkInfo: getIt(),
    ),
  );

  getIt.registerLazySingleton(() => CreateVnPayCheckout(getIt()));

  getIt.registerFactory(
    () => PaymentProvider(
      getPaymentMethodsUseCase: getIt(),
      getActivePaymentMethodsUseCase: getIt(),
    ),
  );
}

Future<void> _setupPackages() async {
  getIt.registerLazySingleton<PackageRemoteDataSource>(
    () => PackageRemoteDataSourceImpl(getIt()),
  );

  getIt.registerLazySingleton<PackageRepository>(
    () => PackageRepositoryImpl(
      remoteDataSource: getIt(),
      networkInfo: getIt(),
    ),
  );

  getIt.registerLazySingleton(() => GetPackages(getIt()));
  getIt.registerLazySingleton(() => GetPackageDetail(getIt()));
}

Future<void> _setupProfile() async {
  getIt.registerLazySingleton<ProfileRemoteDataSource>(
    () => ProfileRemoteDataSourceImpl(getIt()),
  );

  getIt.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(
      remoteDataSource: getIt(),
      networkInfo: getIt(),
    ),
  );

  getIt.registerLazySingleton(() => GetProfile(getIt()));
  getIt.registerLazySingleton(() => UpdateProfile(getIt()));

  getIt.registerFactory(
    () => ProfileProvider(
      getProfileUseCase: getIt(),
      updateProfileUseCase: getIt(),
    ),
  );
}

Future<void> _setupQuizzes() async {
  getIt.registerLazySingleton<QuizRemoteDataSource>(
    () => QuizRemoteDataSourceImpl(getIt()),
  );

  getIt.registerLazySingleton<QuizRepository>(
    () => QuizRepositoryImpl(
      remoteDataSource: getIt(),
      networkInfo: getIt(),
    ),
  );

  getIt.registerLazySingleton(() => GetQuizForTake(getIt()));
  getIt.registerLazySingleton(() => CreateQuizAttempt(getIt()));
  getIt.registerLazySingleton(() => SubmitQuizAttempt(getIt()));
  getIt.registerLazySingleton(() => GetMyQuizAttempts(getIt()));

  getIt.registerFactory(
    () => QuizProvider(
      getQuizForTakeUseCase: getIt(),
      createQuizAttemptUseCase: getIt(),
      submitQuizAttemptUseCase: getIt(),
      getMyQuizAttemptsUseCase: getIt(),
    ),
  );
}

Future<void> _setupAssignments() async {
  getIt.registerLazySingleton<AssignmentRemoteDataSource>(
    () => AssignmentRemoteDataSourceImpl(getIt()),
  );

  getIt.registerLazySingleton<AssignmentRepository>(
    () => AssignmentRepositoryImpl(
      remoteDataSource: getIt(),
      networkInfo: getIt(),
    ),
  );

  getIt.registerLazySingleton(() => SubmitAssignment(getIt()));
}

Future<void> _setupLivestreams() async {
  getIt.registerLazySingleton<LivestreamRemoteDataSource>(
    () => LivestreamRemoteDataSourceImpl(getIt()),
  );

  getIt.registerLazySingleton<LivestreamRepository>(
    () => LivestreamRepositoryImpl(
      remoteDataSource: getIt(),
      networkInfo: getIt(),
    ),
  );

  getIt.registerLazySingleton(() => GetLivestreams(getIt()));
  getIt.registerLazySingleton(() => GetLivestreamDetail(getIt()));
}

Future<void> _setupPaymentMethods() async {
  getIt.registerLazySingleton<PaymentMethodRemoteDataSource>(
    () => PaymentMethodRemoteDataSourceImpl(getIt()),
  );

  getIt.registerLazySingleton<PaymentMethodRepository>(
    () => PaymentMethodRepositoryImpl(
      remoteDataSource: getIt(),
      networkInfo: getIt(),
    ),
  );

  getIt.registerLazySingleton(() => GetPaymentMethods(getIt()));
  getIt.registerLazySingleton(() => GetActivePaymentMethods(getIt()));
}
