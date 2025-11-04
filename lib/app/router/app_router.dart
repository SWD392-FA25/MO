import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/authentication/presentation/pages/auth_welcome_page.dart';
import '../../features/authentication/presentation/pages/sign_in_page.dart';
import '../../features/authentication/presentation/pages/sign_up_page.dart';
import '../../features/courses/presentation/pages/category_page.dart';
import '../../features/courses/presentation/pages/courses_list_page.dart';
import '../../features/courses/presentation/pages/popular_courses_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/onboarding/presentation/pages/onboarding_page.dart';
import '../../features/splash/presentation/pages/splash_page.dart';

GoRouter buildRouter() {
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
