import '../../../../../core/error/exceptions.dart';
import '../../../../../core/storage/secure_storage.dart';
import '../models/auth_token_model.dart';

abstract class AuthLocalDataSource {
  Future<void> cacheAuthToken(AuthTokenModel token);
  Future<AuthTokenModel?> getCachedAuthToken();
  Future<void> clearAuthToken();
  Future<void> cacheUserId(String userId);
  Future<String?> getCachedUserId();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SecureStorage storage;

  AuthLocalDataSourceImpl(this.storage);

  @override
  Future<void> cacheAuthToken(AuthTokenModel token) async {
    try {
      await storage.saveAccessToken(token.accessToken);
      await storage.saveRefreshToken(token.refreshToken);
    } catch (e) {
      throw CacheException('Failed to cache auth token');
    }
  }

  @override
  Future<AuthTokenModel?> getCachedAuthToken() async {
    try {
      final accessToken = await storage.getAccessToken();
      final refreshToken = await storage.getRefreshToken();

      if (accessToken == null || refreshToken == null) {
        return null;
      }

      return AuthTokenModel(
        accessToken: accessToken,
        refreshToken: refreshToken,
        expiresAt: DateTime.now().add(const Duration(hours: 1)),
      );
    } catch (e) {
      throw CacheException('Failed to get cached auth token');
    }
  }

  @override
  Future<void> clearAuthToken() async {
    try {
      await storage.clearAuthData();
    } catch (e) {
      throw CacheException('Failed to clear auth token');
    }
  }

  @override
  Future<void> cacheUserId(String userId) async {
    try {
      await storage.saveUserId(userId);
    } catch (e) {
      throw CacheException('Failed to cache user ID');
    }
  }

  @override
  Future<String?> getCachedUserId() async {
    try {
      return await storage.getUserId();
    } catch (e) {
      throw CacheException('Failed to get cached user ID');
    }
  }
}
