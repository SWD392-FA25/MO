import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// Temporary imports - will be updated when pages are moved to features
import '../../src/ui/pages/auth_welcome_page.dart';
import '../../src/ui/pages/category_page.dart';
import '../../src/ui/pages/courses_list_page.dart';
import '../../src/ui/pages/home_page.dart';
import '../../src/ui/pages/onboarding_page.dart';
import '../../src/ui/pages/popular_courses_page.dart';
import '../../src/ui/pages/sign_in_page.dart';
import '../../src/ui/pages/sign_up_page.dart';
import '../../src/ui/pages/splash_page.dart';

// Router provider
final appRouterProvider = Provider<GoRouter>((ref) {
  return _buildRouter(ref);
});

GoRouter _buildRouter(ProviderRef ref) {
  return GoRouter(
    initialLocation: '/splash',
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
        name: 'sign_up',
        builder: (context, state) => const SignUpPage(),
      ),
      GoRoute(
        path: '/auth/sign-in',
        name: 'sign_in',
        builder: (context, state) => const SignInPage(),
      ),
      GoRoute(
        path: '/dashboard/home',
        name: 'home',
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(path: '/', redirect: (context, state) => '/dashboard/home'),
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
    ],
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(title: const Text('Not Found')),
      body: Center(child: Text(state.error?.toString() ?? 'Page not found')),
    ),
  );
}
