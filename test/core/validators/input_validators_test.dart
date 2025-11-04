import 'package:flutter_test/flutter_test.dart';
import 'package:igcse_learning_hub/core/validators/input_validators.dart';

void main() {
  group('InputValidators', () {
    group('email', () {
      test('should return null for valid email', () {
        expect(InputValidators.email('test@example.com'), null);
        expect(InputValidators.email('user.name@domain.co.uk'), null);
      });

      test('should return error for empty email', () {
        expect(InputValidators.email(''), 'Email is required');
        expect(InputValidators.email(null), 'Email is required');
      });

      test('should return error for invalid email format', () {
        expect(
          InputValidators.email('invalid-email'),
          'Please enter a valid email address',
        );
        expect(
          InputValidators.email('test@'),
          'Please enter a valid email address',
        );
        expect(
          InputValidators.email('@example.com'),
          'Please enter a valid email address',
        );
      });
    });

    group('password', () {
      test('should return null for valid password', () {
        expect(InputValidators.password('password123'), null);
        expect(InputValidators.password('123456'), null);
      });

      test('should return error for empty password', () {
        expect(InputValidators.password(''), 'Password is required');
        expect(InputValidators.password(null), 'Password is required');
      });

      test('should return error for short password', () {
        expect(
          InputValidators.password('12345'),
          'Password must be at least 6 characters',
        );
        expect(
          InputValidators.password('abc'),
          'Password must be at least 6 characters',
        );
      });
    });

    group('confirmPassword', () {
      test('should return null when passwords match', () {
        expect(
          InputValidators.confirmPassword('password123', 'password123'),
          null,
        );
      });

      test('should return error when confirm password is empty', () {
        expect(
          InputValidators.confirmPassword('', 'password123'),
          'Please confirm your password',
        );
        expect(
          InputValidators.confirmPassword(null, 'password123'),
          'Please confirm your password',
        );
      });

      test('should return error when passwords do not match', () {
        expect(
          InputValidators.confirmPassword('password123', 'different'),
          'Passwords do not match',
        );
      });
    });

    group('name', () {
      test('should return null for valid name', () {
        expect(InputValidators.name('John Doe'), null);
        expect(InputValidators.name('AB'), null);
      });

      test('should return error for empty name', () {
        expect(InputValidators.name(''), 'Name is required');
        expect(InputValidators.name(null), 'Name is required');
      });

      test('should return error for short name', () {
        expect(
          InputValidators.name('A'),
          'Name must be at least 2 characters',
        );
      });
    });
  });
}
