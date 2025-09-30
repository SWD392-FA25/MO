import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'ui/pages/login_page.dart';
import 'ui/pages/home_page.dart';
import 'ui/pages/membership_page.dart';
import 'ui/pages/courses_page.dart';
import 'ui/pages/lesson_page.dart';
import 'ui/pages/practice_page.dart';
import 'ui/pages/mock_test_page.dart';
import 'ui/pages/profile_page.dart';
import 'ui/pages/payment_page.dart';

GoRouter buildRouter() {
  return GoRouter(
    initialLocation: '/login',
    routes: [
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: '/membership',
        name: 'membership',
        builder: (context, state) => const MembershipPage(),
      ),
      GoRoute(
        path: '/courses',
        name: 'courses',
        builder: (context, state) => const CoursesPage(),
      ),
      GoRoute(
        path: '/lesson/:id',
        name: 'lesson',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return LessonPage(lessonId: id);
        },
      ),
      GoRoute(
        path: '/practice',
        name: 'practice',
        builder: (context, state) => const PracticePage(),
      ),
      GoRoute(
        path: '/mock-test',
        name: 'mock_test',
        builder: (context, state) => const MockTestPage(),
      ),
      GoRoute(
        path: '/profile',
        name: 'profile',
        builder: (context, state) => const ProfilePage(),
      ),
      GoRoute(
        path: '/payment',
        name: 'payment',
        builder: (context, state) => const PaymentPage(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(title: const Text('Not Found')),
      body: Center(child: Text(state.error?.toString() ?? 'Page not found')),
    ),
    redirect: (context, state) {
      // Simple redirect stub; in future, check auth status
      return null;
    },
  );
}
