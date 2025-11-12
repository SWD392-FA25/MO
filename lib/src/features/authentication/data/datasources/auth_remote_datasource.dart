import '../../../../../core/error/exceptions.dart';
import '../../../../../core/network/api_client.dart';
import '../models/auth_token_model.dart';
import '../models/login_response_model.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<LoginResponseModel> signIn({
    required String email,
    required String password,
  });

  Future<LoginResponseModel> signUp({
    required String email,
    required String password,
    required String name,
    String? phoneNumber,
  });

  Future<LoginResponseModel> googleSignIn({
    required String firebaseIdToken,
  });

  Future<void> signOut();

  Future<void> revokeToken(String refreshToken);

  Future<UserModel> getCurrentUser();

  Future<AuthTokenModel> refreshToken(String refreshToken);

  Future<void> forgotPassword(String email);

  Future<void> resetPassword({
    required String token,
    required String newPassword,
  });

  Future<void> verifyOtp({
    required String email,
    required String otp,
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient client;

  AuthRemoteDataSourceImpl(this.client);

  @override
  Future<LoginResponseModel> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await client.post(
        '/Authentication/login',
        data: {
          'emailOrUsername': email,
          'password': password,
        },
      );

      if (response.data == null) {
        throw ServerException('No data received from server');
      }

      // DEBUG: Print actual response
      print('🟢 LOGIN SUCCESS - Response: ${response.data}');

      final responseData = response.data as Map<String, dynamic>;
      final loginResponse = LoginResponseModel.fromJson(responseData);
      
      print('👤 User data: ID=${loginResponse.user.id}, Email=${loginResponse.user.email}');

      return loginResponse;
    } catch (e) {
      print('🔴 LOGIN ERROR: $e');
      if (e is ServerException || e is NetworkException || e is UnauthorizedException) {
        rethrow;
      }
      throw ServerException('Failed to sign in: ${e.toString()}');
    }
  }

  @override
  Future<LoginResponseModel> googleSignIn({
    required String firebaseIdToken,
  }) async {
    try {
      print('🔍 [DATASOURCE] Starting Google Sign-In request');
      
      final requestData = {
        'FirebaseIdToken': firebaseIdToken,
      };
      
      print('🔍 [DATASOURCE] Request data keys: ${requestData.keys.toList()}');
      print('🔍 [DATASOURCE] FirebaseIdToken length: ${firebaseIdToken.length}');
      print('🔍 [DATASOURCE] FirebaseIdToken preview: ${firebaseIdToken.substring(0, 100)}...');
      
      final response = await client.post(
        '/Authentication/google-login',
        data: requestData,
      );

      if (response.data == null) {
        throw ServerException('No data received from server');
      }

      final responseData = response.data as Map<String, dynamic>;
      print('🔍 [DATASOURCE] Response data: $responseData');
      return LoginResponseModel.fromJson(responseData);
    } catch (e) {
      print('🔍 [DATASOURCE] Error in Google Sign-In: ${e.toString()}');
      if (e is ServerException || e is NetworkException || e is UnauthorizedException) {
        rethrow;
      }
      throw ServerException('Failed to sign in with Google: ${e.toString()}');
    }
  }

  @override
  Future<LoginResponseModel> signUp({
    required String email,
    required String password,
    required String name,
    String? phoneNumber,
  }) async {
    try {
      print('🔵 REGISTER REQUEST - Data: {email: $email, userName: ${email.split('@')[0]}, role: Student}');
      
      final response = await client.post(
        '/Authentication/register',
        data: {
          'email': email,
          'password': password,
          'fullName': name,
          'userName': email.split('@')[0],
          'role': 'Student',
          if (phoneNumber != null) 'phoneNumber': phoneNumber,
        },
      );

      if (response.data == null) {
        throw ServerException('No data received from server');
      }

      // DEBUG: Print actual response
      print('🟢 REGISTER SUCCESS - Response: ${response.data}');

      final responseData = response.data as Map<String, dynamic>;
      final loginResponse = LoginResponseModel.fromJson(responseData);
      
      print('👤 User data: ID=${loginResponse.user.id}, Email=${loginResponse.user.email}');

      return loginResponse;
    } catch (e) {
      print('🔴 REGISTER ERROR: $e');
      if (e is ServerException || e is NetworkException) {
        rethrow;
      }
      throw ServerException('Failed to sign up: ${e.toString()}');
    }
  }

  @override
  Future<void> signOut() async {
    try {
      // API might not have logout endpoint, just clear local tokens
      // await client.post('/Authentication/logout');
    } catch (e) {
      if (e is ServerException || e is NetworkException) {
        rethrow;
      }
      throw ServerException('Failed to sign out: ${e.toString()}');
    }
  }

  @override
  Future<void> revokeToken(String refreshToken) async {
    try {
      await client.post(
        '/Authentication/revoke',
        data: {'refreshToken': refreshToken},
      );
    } catch (e) {
      if (e is ServerException || e is NetworkException) {
        rethrow;
      }
      throw ServerException('Failed to revoke token: ${e.toString()}');
    }
  }

  @override
  Future<UserModel> getCurrentUser() async {
    try {
      // Parse user info from JWT token claims
      // JWT format: header.payload.signature
      // Payload contains user claims including userId
      
      // For now, return a basic user model
      // The real user data should come from login/register response
      // and be cached in AuthProvider
      
      return const UserModel(
        id: 'jwt-user',
        email: 'user@example.com', 
        name: 'User',
      );
    } catch (e) {
      if (e is ServerException || e is NetworkException || e is UnauthorizedException) {
        rethrow;
      }
      throw ServerException('Failed to get current user: ${e.toString()}');
    }
  }

  @override
  Future<AuthTokenModel> refreshToken(String refreshToken) async {
    try {
      final response = await client.post(
        '/Authentication/refresh',
        data: {'refreshToken': refreshToken},
      );

      if (response.data == null) {
        throw ServerException('No data received from server');
      }

      return AuthTokenModel.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      if (e is ServerException || e is NetworkException || e is UnauthorizedException) {
        rethrow;
      }
      throw ServerException('Failed to refresh token: ${e.toString()}');
    }
  }

  @override
  Future<void> forgotPassword(String email) async {
    try {
      // Note: Swagger shows /Accounts/reset-password but requires userNameOrEmail + newPassword
      // This might not be a "forgot password" flow, but a direct reset
      // You may need to clarify with backend team
      await client.post(
        '/Accounts/reset-password',
        data: {
          'userNameOrEmail': email,
          'newPassword': '',
          'confirmNewPassword': '',
        },
      );
    } catch (e) {
      if (e is ServerException || e is NetworkException) {
        rethrow;
      }
      throw ServerException('Failed to send password reset: ${e.toString()}');
    }
  }

  @override
  Future<void> resetPassword({
    required String token,
    required String newPassword,
  }) async {
    try {
      await client.post(
        '/auth/reset-password',
        data: {
          'token': token,
          'newPassword': newPassword,
        },
      );
    } catch (e) {
      if (e is ServerException || e is NetworkException) {
        rethrow;
      }
      throw ServerException('Failed to reset password: ${e.toString()}');
    }
  }

  @override
  Future<void> verifyOtp({
    required String email,
    required String otp,
  }) async {
    try {
      await client.post(
        '/auth/verify-otp',
        data: {
          'email': email,
          'otp': otp,
        },
      );
    } catch (e) {
      if (e is ServerException || e is NetworkException) {
        rethrow;
      }
      throw ServerException('Failed to verify OTP: ${e.toString()}');
    }
  }
}
