// Simple provider setup for testing API

import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

import '../services/api_service.dart';

// My Courses (Only essential classes for now)
import '../features/my_courses/data/datasources/my_course_remote_datasource.dart';
import '../features/my_courses/data/datasources/assignment_remote_datasource.dart';
import '../features/my_courses/data/datasources/enrollment_remote_datasource.dart';
import '../features/my_courses/data/datasources/order_remote_datasource.dart';
import '../features/my_courses/data/repositories/my_course_repository_impl.dart';
import '../features/my_courses/data/repositories/assignment_repository_impl.dart';
import '../features/my_courses/data/repositories/enrollment_repository_impl.dart';
import '../features/my_courses/data/repositories/order_repository_impl.dart';
import '../features/my_courses/domain/repositories/my_course_repository.dart';
import '../features/my_courses/domain/repositories/assignment_repository.dart';
import '../features/my_courses/domain/repositories/enrollment_repository.dart';
import '../features/my_courses/domain/repositories/order_repository.dart';
import '../features/my_courses/domain/usecases/get_my_course_lessons.dart';
import '../features/my_courses/domain/usecases/get_my_course_detail.dart';
import '../features/my_courses/domain/usecases/get_course_progress.dart';
import '../features/my_courses/domain/usecases/complete_lesson.dart';
import '../features/my_courses/domain/usecases/submit_assignment.dart';
import '../features/my_courses/domain/usecases/get_assignment_submissions.dart';
import '../features/my_courses/domain/usecases/get_my_enrollments.dart';
import '../features/my_courses/domain/usecases/get_my_orders.dart';
import '../features/my_courses/domain/usecases/get_order_by_id.dart';
import '../features/my_courses/domain/usecases/checkout_order.dart';
import '../features/my_courses/domain/usecases/retry_checkout.dart';
import '../features/my_courses/presentation/providers/my_course_provider.dart';
import '../features/my_courses/presentation/providers/enrollment_provider.dart';
import '../features/my_courses/presentation/providers/assignment_provider.dart';
import '../features/my_courses/presentation/providers/order_provider.dart';

// Simple API Client for testing
class SimpleApiClient {
  final ApiService _apiService;

  SimpleApiClient(this._apiService);

  Future<Response> get(String path) => _apiService.get(path);
  Future<Response> post(String path, {dynamic data}) => _apiService.get(path);
  Future<Response> patch(String path, {dynamic data}) => _apiService.get(path);
}

// Simple NetworkInfo
class SimpleNetworkInfo {
  Future<bool> get isConnected async => true;
}

class ProviderSetup {
  static Widget createApp({required Widget child}) {
    return MultiProvider(
      providers: [
        // Network/API
        Provider<ApiService>(
          create: (_) => ApiService.create(baseUrl: 'https://api.igcse.local/mock'),
        ),
        Provider<SimpleApiClient>(
          create: (context) => SimpleApiClient(context.read<ApiService>()),
        ),
        Provider<SimpleNetworkInfo>(create: (_) => SimpleNetworkInfo()),

        // My Courses DataSources
        Provider<MyCourseRemoteDataSource>(
          create: (context) => MyCourseRemoteDataSourceImpl(context.read<SimpleApiClient>() as dynamic),
        ),
        Provider<AssignmentRemoteDataSource>(
          create: (context) => AssignmentRemoteDataSourceImpl(context.read<SimpleApiClient>() as dynamic),
        ),
        Provider<EnrollmentRemoteDataSource>(
          create: (context) => EnrollmentRemoteDataSourceImpl(context.read<SimpleApiClient>() as dynamic),
        ),
        Provider<OrderRemoteDataSource>(
          create: (context) => OrderRemoteDataSourceImpl(context.read<SimpleApiClient>() as dynamic),
        ),

        // My Courses Repositories
        Provider<MyCourseRepository>(
          create: (context) => MyCourseRepositoryImpl(
            remoteDataSource: context.read(),
            networkInfo: context.read(),
          ),
        ),
        Provider<AssignmentRepository>(
          create: (context) => AssignmentRepositoryImpl(
            remoteDataSource: context.read(),
            networkInfo: context.read(),
          ),
        ),
        Provider<EnrollmentRepository>(
          create: (context) => EnrollmentRepositoryImpl(
            remoteDataSource: context.read(),
            networkInfo: context.read(),
          ),
        ),
        Provider<OrderRepository>(
          create: (context) => OrderRepositoryImpl(
            context.read(),
          ),
        ),

        // My Courses Usecases
        Provider<GetMyCourseLessons>(
          create: (context) => GetMyCourseLessons(context.read()),
        ),
        Provider<GetMyCourseDetail>(
          create: (context) => GetMyCourseDetail(context.read()),
        ),
        Provider<GetCourseProgress>(
          create: (context) => GetCourseProgress(context.read()),
        ),
        Provider<CompleteLesson>(
          create: (context) => CompleteLesson(context.read()),
        ),
        Provider<SubmitAssignment>(
          create: (context) => SubmitAssignment(context.read()),
        ),
        Provider<GetAssignmentSubmissions>(
          create: (context) => GetAssignmentSubmissions(context.read()),
        ),
        Provider<GetMyEnrollments>(
          create: (context) => GetMyEnrollments(context.read()),
        ),
        Provider<GetMyOrders>(
          create: (context) => GetMyOrders(context.read()),
        ),
        Provider<GetOrderById>(
          create: (context) => GetOrderById(context.read()),
        ),
        Provider<CheckoutOrder>(
          create: (context) => CheckoutOrder(context.read()),
        ),
        Provider<RetryCheckout>(
          create: (context) => RetryCheckout(context.read()),
        ),

        // My Courses Providers
        ChangeNotifierProvider<MyCourseProvider>(
          create: (context) => MyCourseProvider(
            getMyCourseLessonsUseCase: context.read(),
            completeLessonUseCase: context.read(),
            getCourseProgressUseCase: context.read(),
            getMyCourseDetailUseCase: context.read(),
          ),
        ),
        ChangeNotifierProvider<EnrollmentProvider>(
          create: (context) => EnrollmentProvider(
            getMyEnrollmentsUseCase: context.read(),
          ),
        ),
        ChangeNotifierProvider<AssignmentProvider>(
          create: (context) => AssignmentProvider(
            submitAssignmentUseCase: context.read(),
            getAssignmentSubmissionsUseCase: context.read(),
          ),
        ),
        ChangeNotifierProvider<OrderProvider>(
          create: (context) => OrderProvider(
            getMyOrdersUseCase: context.read(),
            getOrderByIdUseCase: context.read(),
            checkoutOrderUseCase: context.read(),
            retryCheckoutUseCase: context.read(),
          ),
        ),
      ],
      child: child,
    );
  }
}
