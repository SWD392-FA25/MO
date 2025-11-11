import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:igcse_learning_hub/core/error/failures.dart';
import 'package:igcse_learning_hub/src/features/authentication/domain/entities/user.dart';
import 'package:igcse_learning_hub/src/features/authentication/domain/repositories/auth_repository.dart';
import 'package:igcse_learning_hub/src/features/authentication/domain/usecases/sign_in.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late SignIn useCase;
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    useCase = SignIn(mockRepository);
  });

  const testEmail = 'test@example.com';
  const testPassword = 'password123';

  final testUser = User(
    id: 'test_user_id',
    email: testEmail,
    name: 'Test User',
  );

  test('should return User when sign in is successful', () async {
    when(() => mockRepository.signIn(
          email: any(named: 'email'),
          password: any(named: 'password'),
        )).thenAnswer((_) async => Right(testUser));

    final result = await useCase(
      const SignInParams(email: testEmail, password: testPassword),
    );

    expect(result, Right(testUser));
    verify(() => mockRepository.signIn(
          email: testEmail,
          password: testPassword,
        )).called(1);
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return ValidationFailure when email is invalid', () async {
    const invalidEmail = 'invalid-email';

    final result = await useCase(
      const SignInParams(email: invalidEmail, password: testPassword),
    );

    expect(result, isA<Left>());
    result.fold(
      (failure) {
        expect(failure, isA<ValidationFailure>());
        expect(failure.message, contains('valid email'));
      },
      (_) => fail('Should return failure'),
    );
    verifyNever(() => mockRepository.signIn(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ));
  });

  test('should return ValidationFailure when password is too short', () async {
    const shortPassword = '123';

    final result = await useCase(
      const SignInParams(email: testEmail, password: shortPassword),
    );

    expect(result, isA<Left>());
    result.fold(
      (failure) {
        expect(failure, isA<ValidationFailure>());
        expect(failure.message, contains('at least 6 characters'));
      },
      (_) => fail('Should return failure'),
    );
    verifyNever(() => mockRepository.signIn(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ));
  });

  test('should return ServerFailure when sign in fails', () async {
    when(() => mockRepository.signIn(
          email: any(named: 'email'),
          password: any(named: 'password'),
        )).thenAnswer((_) async => const Left(ServerFailure('Login failed')));

    final result = await useCase(
      const SignInParams(email: testEmail, password: testPassword),
    );

    expect(result, isA<Left>());
    result.fold(
      (failure) {
        expect(failure, isA<ServerFailure>());
        expect(failure.message, 'Login failed');
      },
      (_) => fail('Should return failure'),
    );
  });
}
