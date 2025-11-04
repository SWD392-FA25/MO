import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'config/env.dart';
import 'core/di/injection.dart';
import 'core/error/failures.dart';
import 'core/usecases/usecase.dart';
import 'src/app_router.dart';
import 'src/features/authentication/presentation/providers/auth_provider.dart';
import 'src/features/catalog/domain/usecases/get_courses.dart';
import 'src/features/catalog/presentation/providers/course_provider.dart';
import 'src/features/catalog/presentation/providers/livestream_provider.dart';
import 'src/features/catalog/presentation/providers/package_provider.dart';
import 'src/features/my_courses/presentation/providers/enrollment_provider.dart';
import 'src/features/my_courses/presentation/providers/my_course_provider.dart';
import 'src/features/profile/presentation/providers/profile_provider.dart';
import 'src/features/quiz/presentation/providers/quiz_provider.dart';
import 'src/features/transactions/presentation/providers/order_provider.dart';
import 'src/features/transactions/presentation/providers/payment_provider.dart';
import 'src/features/catalog/domain/usecases/get_livestreams.dart';
import 'src/features/catalog/domain/usecases/get_packages.dart';
import 'src/features/my_courses/domain/usecases/get_my_enrollments.dart';
import 'src/features/quiz/domain/usecases/get_my_quiz_attempts.dart';
import 'src/features/transactions/domain/usecases/get_active_payment_methods.dart';
import 'src/features/transactions/domain/usecases/get_my_orders.dart';
import 'src/state/app_state.dart';
import 'src/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Env.setEnvironment(Environment.dev);

  await setupDependencies();

  // 🧪 TEST APIs - Comment out sau khi test xong
  // await _testAPIs();  // ✅ APIs tested and working!

  runApp(const IGCSELearningHub());
}

/// Test các API endpoints để đảm bảo hoạt động
Future<void> _testAPIs() async {
  print('\n');
  print('=' * 70);
  print('🧪 TESTING ALL API ENDPOINTS');
  print('=' * 70);

  int successCount = 0;
  int failCount = 0;

  // ============================================================
  // PUBLIC APIs (Không cần authentication)
  // ============================================================
  print('\n📂 SECTION 1: PUBLIC APIs (No Auth Required)');
  print('─' * 70);

  // Test 1: Get Courses
  try {
    print('\n📚 Test 1: GET /courses');
    final getCoursesUseCase = getIt<GetCourses>();
    final result = await getCoursesUseCase.call(GetCoursesParams());

    result.fold(
      (failure) {
        print('❌ FAILED: ${failure.message}');
        print('   Status: ${failure is ServerFailure ? failure.statusCode : "N/A"}');
        failCount++;
      },
      (courses) {
        print('✅ SUCCESS: Got ${courses.length} courses');
        if (courses.isNotEmpty) {
          print('   Sample: "${courses.first.title}" - \$${courses.first.price}');
        }
        successCount++;
      },
    );
  } catch (e) {
    print('❌ ERROR: $e');
    failCount++;
  }

  // Test 2: Get Packages
  try {
    print('\n📦 Test 2: GET /packages');
    final getPackagesUseCase = getIt<GetPackages>();
    final result = await getPackagesUseCase.call(NoParams());

    result.fold(
      (failure) {
        print('❌ FAILED: ${failure.message}');
        failCount++;
      },
      (packages) {
        print('✅ SUCCESS: Got ${packages.length} packages');
        if (packages.isNotEmpty) {
          print('   Sample: "${packages.first.name}" - \$${packages.first.price}');
        }
        successCount++;
      },
    );
  } catch (e) {
    print('❌ ERROR: $e');
    failCount++;
  }

  // Test 3: Get Livestreams
  try {
    print('\n📺 Test 3: GET /livestreams');
    final getLivestreamsUseCase = getIt<GetLivestreams>();
    final result = await getLivestreamsUseCase.call(NoParams());

    result.fold(
      (failure) {
        print('❌ FAILED: ${failure.message}');
        failCount++;
      },
      (livestreams) {
        print('✅ SUCCESS: Got ${livestreams.length} livestreams');
        if (livestreams.isNotEmpty) {
          print('   Sample: "${livestreams.first.title}" - ${livestreams.first.status}');
        }
        successCount++;
      },
    );
  } catch (e) {
    print('❌ ERROR: $e');
    failCount++;
  }

  // Test 4: Get Payment Methods
  try {
    print('\n💳 Test 4: GET /payment-methods/active');
    final getPaymentMethodsUseCase = getIt<GetActivePaymentMethods>();
    final result = await getPaymentMethodsUseCase.call(NoParams());

    result.fold(
      (failure) {
        print('❌ FAILED: ${failure.message}');
        failCount++;
      },
      (methods) {
        print('✅ SUCCESS: Got ${methods.length} payment methods');
        if (methods.isNotEmpty) {
          print('   Sample: "${methods.first.name}" - ${methods.first.type}');
        }
        successCount++;
      },
    );
  } catch (e) {
    print('❌ ERROR: $e');
    failCount++;
  }

  // ============================================================
  // PROTECTED APIs (Cần authentication)
  // ============================================================
  print('\n\n🔐 SECTION 2: PROTECTED APIs (Auth Required)');
  print('─' * 70);
  print('⚠️  Note: These APIs require login. Expected to fail with 401.');

  // Test 5: Get My Enrollments
  try {
    print('\n🎓 Test 5: GET /me/enrollments');
    final getEnrollmentsUseCase = getIt<GetMyEnrollments>();
    final result = await getEnrollmentsUseCase.call(NoParams());

    result.fold(
      (failure) {
        if (failure is UnauthorizedFailure || 
            (failure is ServerFailure && failure.statusCode == 401)) {
          print('⚠️  Expected 401: ${failure.message}');
          print('   → Normal: API requires login');
        } else {
          print('❌ FAILED: ${failure.message}');
          failCount++;
        }
      },
      (enrollments) {
        print('✅ SUCCESS: Got ${enrollments.length} enrollments');
        successCount++;
      },
    );
  } catch (e) {
    print('❌ ERROR: $e');
  }

  // Test 6: Get My Orders
  try {
    print('\n🛒 Test 6: GET /me/orders');
    final getOrdersUseCase = getIt<GetMyOrders>();
    final result = await getOrdersUseCase.call(NoParams());

    result.fold(
      (failure) {
        if (failure is UnauthorizedFailure || 
            (failure is ServerFailure && failure.statusCode == 401)) {
          print('⚠️  Expected 401: ${failure.message}');
          print('   → Normal: API requires login');
        } else {
          print('❌ FAILED: ${failure.message}');
          failCount++;
        }
      },
      (orders) {
        print('✅ SUCCESS: Got ${orders.length} orders');
        successCount++;
      },
    );
  } catch (e) {
    print('❌ ERROR: $e');
  }

  // Test 7: Get My Quiz Attempts
  try {
    print('\n🧠 Test 7: GET /student/quiz-attempts');
    final getQuizAttemptsUseCase = getIt<GetMyQuizAttempts>();
    final result = await getQuizAttemptsUseCase.call(NoParams());

    result.fold(
      (failure) {
        if (failure is UnauthorizedFailure || 
            (failure is ServerFailure && failure.statusCode == 401)) {
          print('⚠️  Expected 401: ${failure.message}');
          print('   → Normal: API requires login');
        } else {
          print('❌ FAILED: ${failure.message}');
          failCount++;
        }
      },
      (attempts) {
        print('✅ SUCCESS: Got ${attempts.length} quiz attempts');
        successCount++;
      },
    );
  } catch (e) {
    print('❌ ERROR: $e');
  }

  // ============================================================
  // SUMMARY
  // ============================================================
  print('\n');
  print('=' * 70);
  print('📊 TEST SUMMARY');
  print('=' * 70);
  print('✅ Successful:       $successCount tests');
  print('❌ Failed:           $failCount tests');
  print('⚠️  Auth Required:   ${7 - successCount - failCount} tests (expected)');
  print('📦 Total Tested:     7 endpoints');
  print('');
  if (successCount >= 4) {
    print('🎉 PUBLIC APIs WORKING! Ready to build UI!');
  } else {
    print('⚠️  Some public APIs failed. Check errors above.');
  }
  print('=' * 70);
  print('\n');
}

class IGCSELearningHub extends StatelessWidget {
  const IGCSELearningHub({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // App State
        ChangeNotifierProvider(create: (_) => AppState()),
        
        // Authentication
        ChangeNotifierProvider(create: (_) => getIt<AuthProvider>()),
        
        // Catalog Features
        ChangeNotifierProvider(create: (_) => getIt<CourseProvider>()),
        ChangeNotifierProvider(create: (_) => getIt<PackageProvider>()),
        ChangeNotifierProvider(create: (_) => getIt<LivestreamProvider>()),
        
        // My Courses
        ChangeNotifierProvider(create: (_) => getIt<EnrollmentProvider>()),
        ChangeNotifierProvider(create: (_) => getIt<MyCourseProvider>()),
        
        // Transactions
        ChangeNotifierProvider(create: (_) => getIt<OrderProvider>()),
        ChangeNotifierProvider(create: (_) => getIt<PaymentProvider>()),
        
        // Quiz
        ChangeNotifierProvider(create: (_) => getIt<QuizProvider>()),
        
        // Profile
        ChangeNotifierProvider(create: (_) => getIt<ProfileProvider>()),
      ],
      child: MaterialApp.router(
        title: 'IGCSE Learning Hub',
        theme: buildAppTheme(),
        routerConfig: buildRouter(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
