import 'package:flutter_test/flutter_test.dart';
import 'package:igcse_learning_hub/core/di/injection.dart';
import 'package:igcse_learning_hub/src/features/catalog/domain/usecases/get_courses.dart';
import 'package:igcse_learning_hub/src/features/authentication/domain/usecases/sign_in.dart';

void main() {
  setUpAll(() async {
    // Initialize dependencies
    await setupDependencies();
  });

  group('API Integration Tests', () {
    test('Test GET courses API', () async {
      // Arrange
      final getCoursesUseCase = getIt<GetCourses>();

      // Act
      final result = await getCoursesUseCase.call(
        GetCoursesParams(page: 1, pageSize: 10),
      );

      // Assert
      result.fold(
        (failure) {
          print('❌ Error: ${failure.message}');
          fail('API call failed: ${failure.message}');
        },
        (courses) {
          print('✅ Success! Got ${courses.length} courses');
          expect(courses, isNotEmpty);
        },
      );
    });

    test('Test Login API', () async {
      // Arrange
      final signInUseCase = getIt<SignIn>();

      // Act
      final result = await signInUseCase.call(
        SignInParams(
          email: 'test@example.com',
          password: 'password123',
        ),
      );

      // Assert
      result.fold(
        (failure) => print('❌ Login failed: ${failure.message}'),
        (token) => print('✅ Login success! Token: ${token.accessToken}'),
      );
    });
  });
}
