import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/di/injection.dart';
import 'features/authentication/presentation/providers/auth_provider.dart';
import 'features/authentication/presentation/pages/auth_completion_page.dart';
import 'features/authentication/presentation/pages/auth_welcome_page.dart';
import 'features/authentication/presentation/pages/create_new_password_page.dart';
import 'features/authentication/presentation/pages/fill_profile_page.dart';
import 'features/authentication/presentation/pages/forgot_password_page.dart';
import 'features/authentication/presentation/pages/sign_in_page.dart';
import 'features/authentication/presentation/pages/sign_up_page.dart';
import 'features/authentication/presentation/pages/verify_otp_page.dart';
import 'features/catalog/presentation/pages/category_page.dart';
import 'features/catalog/presentation/pages/courses_list_page.dart';
import 'features/catalog/presentation/pages/popular_courses_page.dart';
import 'features/catalog/presentation/pages/search_page.dart';
import 'features/course_detail/presentation/pages/tabs/course_curriculum_page.dart';
import 'features/course_detail/presentation/pages/tabs/course_reviews_page.dart';
import 'features/course_detail/presentation/pages/course_detail_page.dart';
import 'features/course_detail/presentation/pages/lesson_detail_page.dart' as course_detail;
import 'features/dashboard/presentation/pages/dashboard_page.dart';
import 'features/lunaby/presentation/pages/lunaby_page.dart';
import 'features/my_courses/presentation/pages/my_course_lessons_page.dart';
import 'features/my_courses/presentation/pages/my_course_lessons_view_page.dart';
import 'features/my_courses/presentation/pages/my_courses_page.dart';
import 'features/my_courses/presentation/pages/lesson_detail_page.dart';
import 'features/my_courses/presentation/pages/assignment_page.dart';
import 'features/my_courses/presentation/pages/orders_page.dart';
import 'features/my_courses/presentation/pages/order_detail_page.dart';
import 'features/onboarding/presentation/pages/onboarding_page.dart';
import 'features/profile/presentation/pages/profile_page.dart';
import 'features/quiz/presentation/pages/quiz_page.dart';
import 'features/splash/presentation/pages/splash_page.dart';
import 'features/transactions/presentation/pages/transactions_page.dart';

GoRouter buildRouter() {
  final authProvider = getIt<AuthProvider>();

  return GoRouter(
    initialLocation: '/splash',
    refreshListenable: authProvider,
    redirect: (context, state) {
      final authProvider = getIt<AuthProvider>();
      final isAuthenticated = authProvider.isAuthenticated;
      final isInitialized = authProvider.isInitialized;
      final location = state.matchedLocation;

      // Don't redirect during initialization or on splash
      if (!isInitialized || location == '/splash') {
        return null;
      }

      // Protected routes (require authentication)
      final protectedRoutes = [
        '/my-courses',
        '/profile',
        '/transactions',
        '/lunaby',
      ];

      final isProtectedRoute = protectedRoutes.any(
        (route) => location.startsWith(route),
      );

      // Redirect unauthenticated users trying to access protected routes
      if (!isAuthenticated && isProtectedRoute) {
        return '/auth/sign-in';
      }

      // Redirect authenticated users away from auth pages
      if (isAuthenticated && 
          location.startsWith('/auth') && 
          location != '/auth/sign-out') {
        return '/dashboard';
      }

      return null; // No redirect needed
    },
    routes: [
      GoRoute(
        path: '/splash',
        name: 'splash',
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: '/onboarding',
        name: 'onboarding',
        builder: (context, state) => const OnboardingPage(),
      ),
      GoRoute(
        path: '/auth/welcome',
        name: 'auth_welcome',
        builder: (context, state) => const AuthWelcomePage(),
      ),
      GoRoute(
        path: '/auth/sign-up',
        builder: (context, state) => const SignUpPage(),
      ),
      GoRoute(
        path: '/auth/sign-in',
        builder: (context, state) => const SignInPage(),
      ),
      GoRoute(
        path: '/auth/fill-profile',
        builder: (context, state) => const FillProfilePage(),
      ),
      GoRoute(
        path: '/auth/forgot',
        builder: (context, state) => const ForgotPasswordPage(),
      ),
      GoRoute(
        path: '/auth/verify-otp',
        builder: (context, state) => const VerifyOtpPage(),
      ),
      GoRoute(
        path: '/auth/create-password',
        builder: (context, state) => const CreateNewPasswordPage(),
      ),
      GoRoute(
        path: '/auth/congratulations',
        builder: (context, state) {
          final contextParam = state.uri.queryParameters['context'];
          final type = contextParam == 'password'
              ? AuthCompletionType.passwordReset
              : AuthCompletionType.signUp;
          return AuthCompletionPage(contextType: type);
        },
      ),
      GoRoute(
        path: '/dashboard',
        builder: (context, state) => const DashboardPage(),
      ),
      GoRoute(path: '/', redirect: (context, state) => '/dashboard'),
      GoRoute(
        path: '/categories',
        name: 'categories',
        builder: (context, state) => const CategoryPage(),
      ),
      GoRoute(
        path: '/courses/popular',
        name: 'popular_courses',
        builder: (context, state) => const PopularCoursesPage(),
      ),
      GoRoute(
        path: '/courses/list',
        name: 'courses_list',
        builder: (context, state) {
          final query = state.uri.queryParameters['query'] ?? 'Graphic Design';
          return CoursesListPage(initialQuery: query);
        },
      ),
      GoRoute(
        path: '/search',
        name: 'search',
        builder: (context, state) => const SearchPage(),
      ),
      GoRoute(
        path: '/courses/:id',
        name: 'course_detail',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return CourseDetailPage(courseId: id);
        },
      ),
      GoRoute(
        path: '/courses/:id/curriculum',
        builder: (context, state) =>
            CourseCurriculumPage(courseId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/courses/:courseId/lessons/:lessonId',
        name: 'lesson_detail',
        builder: (context, state) {
          final courseId = state.pathParameters['courseId']!;
          final lessonId = state.pathParameters['lessonId']!;
          return course_detail.LessonDetailPage(courseId: courseId, lessonId: lessonId);
        },
      ),
      GoRoute(
        path: '/courses/:courseId/lessons/:lessonId/assignments/:assignmentId',
        name: 'assignment_detail',
        builder: (context, state) => AssignmentPage(
          courseId: state.pathParameters['courseId']!,
        ),
      ),
      GoRoute(
        path: '/courses/reviews',
        builder: (context, state) => const CourseReviewsPage(),
      ),
      GoRoute(
        path: '/courses/reviews/write',
        builder: (context, state) => const CourseWriteReviewPage(),
      ),
      GoRoute(
        path: '/my-courses',
        builder: (context, state) => const MyCoursesPage(),
      ),
      GoRoute(
        path: '/my-courses/ongoing/:id',
        builder: (context, state) =>
            MyCourseLessonsPage(courseId: state.pathParameters['id']!, isCompleted: false),
      ),
      GoRoute(
        path: '/my-courses/completed/:id',
        builder: (context, state) =>
            MyCourseLessonsPage(courseId: state.pathParameters['id']!, isCompleted: true),
      ),
      GoRoute(
        path: '/my-courses/:id/video',
        builder: (context, state) =>
            MyCourseVideoPage(courseId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/my-courses/:id/completed',
        builder: (context, state) =>
            CourseCompletionPage(courseId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/my-courses/:id/assignments',
        builder: (context, state) =>
            AssignmentPage(courseId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/lunaby',
        builder: (context, state) => const LunabyPage(),
      ),
      GoRoute(
        path: '/transactions',
        builder: (context, state) => const TransactionsPage(),
      ),
      
      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfilePage(),
      ),
      GoRoute(
        path: '/profile/edit',
        builder: (context, state) => const EditProfilePage(),
      ),
      GoRoute(
        path: '/profile/notifications',
        builder: (context, state) => const NotificationsPage(),
      ),
      GoRoute(
        path: '/profile/payment-options',
        builder: (context, state) => const PaymentOptionsPage(),
      ),
      GoRoute(
        path: '/profile/payment-options/add',
        builder: (context, state) => const AddNewCardPage(),
      ),
      GoRoute(
        path: '/profile/bookmarks',
        builder: (context, state) => const BookmarksPage(),
      ),
      GoRoute(
        path: '/my-courses/ongoing/:courseId',
        builder: (context, state) => MyCourseLessonsViewPage(courseId: state.pathParameters['courseId']!),
      ),
      GoRoute(
        path: '/lesson/:courseId/:lessonId',
        builder: (context, state) {
          final courseId = state.pathParameters['courseId']!;
          final lessonId = state.pathParameters['lessonId']!;
          return LessonDetailPage(courseId: courseId, lessonId: lessonId);
        },
      ),
      GoRoute(
        path: '/assignment/:courseId/:lessonId',
        builder: (context, state) {
          final courseId = state.pathParameters['courseId']!;
          final lessonId = state.pathParameters['lessonId']!;
          // We'll need assignmentId, will use lessonId as fallback for now
          return AssignmentPage(courseId: courseId, lessonId: lessonId, assignmentId: lessonId);
        },
      ),
      GoRoute(
        path: '/orders',
        builder: (context, state) => const OrdersPage(),
      ),
      GoRoute(
        path: '/orders/:orderId',
        builder: (context, state) {
          // Use transactions OrderProvider instead of my_courses
          return OrderDetailPage(orderId: state.pathParameters['orderId']!);
        },
      ),
      GoRoute(
        path: '/quiz/:quizId',
        builder: (context, state) => QuizPage(quizId: state.pathParameters['quizId']!),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(title: const Text('Not Found')),
      body: Center(child: Text(state.error?.toString() ?? 'Page not found')),
    ),
  );
}
