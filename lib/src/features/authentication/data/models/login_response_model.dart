import 'auth_token_model.dart';
import 'user_model.dart';

class LoginResponseModel {
  final AuthTokenModel token;
  final UserModel user;

  const LoginResponseModel({
    required this.token,
    required this.user,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? json;
    
    // Parse token
    final token = AuthTokenModel.fromJson(json);
    
    // Parse user data - user info is directly in 'data', not nested
    final user = UserModel(
      id: data['id']?.toString() ?? 
          data['accountId']?.toString() ?? 
          data['userId']?.toString() ?? '',
      email: data['email'] as String? ?? '',
      name: data['fullName'] as String? ?? data['userName'] as String? ?? '',
    );
    
    return LoginResponseModel(
      token: token,
      user: user,
    );
  }
}
