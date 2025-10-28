import '../../domain/entities/auth_token.dart';

class AuthTokenModel extends AuthToken {
  const AuthTokenModel({
    required super.accessToken,
    required super.refreshToken,
    required super.expiresAt,
  });

  factory AuthTokenModel.fromJson(Map<String, dynamic> json) {
    // API wraps response in {data: {...}}
    final data = json['data'] as Map<String, dynamic>? ?? json;
    
    final expiresIn = data['expiresIn'] as int? ?? data['expires_in'] as int? ?? 3600;
    final expiresAt = DateTime.now().add(Duration(seconds: expiresIn));

    return AuthTokenModel(
      accessToken: data['jwtToken'] as String? ?? 
                   data['accessToken'] as String? ?? 
                   data['access_token'] as String? ?? 
                   data['token'] as String,
      refreshToken: data['refreshToken'] as String? ?? 
                    data['refresh_token'] as String? ?? 
                    '',
      expiresAt: data['expiresAt'] != null
          ? DateTime.parse(data['expiresAt'] as String)
          : expiresAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'accessToken': accessToken,
      'refreshToken': refreshToken,
      'expiresAt': expiresAt.toIso8601String(),
    };
  }

  AuthToken toEntity() {
    return AuthToken(
      accessToken: accessToken,
      refreshToken: refreshToken,
      expiresAt: expiresAt,
    );
  }
}
