import 'package:dio/dio.dart';

import '../../config/env.dart';
import '../error/exceptions.dart';

class ApiClient {
  final Dio _dio;

  ApiClient._(this._dio);

  factory ApiClient.create() {
    final dio = Dio(
      BaseOptions(
        baseUrl: Env.apiBaseUrl,
        connectTimeout: Env.connectionTimeout,
        receiveTimeout: Env.receiveTimeout,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        validateStatus: (status) {
          return status != null && status < 500;
        },
      ),
    );

    if (Env.enableLogging) {
      dio.interceptors.add(LogInterceptor(
        requestBody: true,
        responseBody: true,
        error: true,
      ));
    }

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          return handler.next(options);
        },
        onResponse: (response, handler) {
          return handler.next(response);
        },
        onError: (error, handler) {
          final exception = _handleDioError(error);
          return handler.reject(
            DioException(
              requestOptions: error.requestOptions,
              error: exception,
              response: error.response,
              type: error.type,
            ),
          );
        },
      ),
    );

    return ApiClient._(dio);
  }

  void setAuthToken(String token) {
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  void removeAuthToken() {
    _dio.options.headers.remove('Authorization');
  }

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.get<T>(
        path,
        queryParameters: queryParameters,
        options: options,
      );
      _validateResponse(response);
      return response;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.post<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      _validateResponse(response);
      return response;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.put<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      _validateResponse(response);
      return response;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.delete<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      _validateResponse(response);
      return response;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  void _validateResponse(Response response) {
    final statusCode = response.statusCode;
    if (statusCode == null) {
      throw ServerException('No status code received');
    }

    if (statusCode == 401) {
      throw UnauthorizedException(
        _extractErrorMessage(response) ?? 'Unauthorized access',
      );
    }

    if (statusCode >= 400 && statusCode < 500) {
      throw ServerException(
        _extractErrorMessage(response) ?? 'Client error occurred',
        statusCode,
      );
    }

    if (statusCode >= 500) {
      throw ServerException(
        _extractErrorMessage(response) ?? 'Server error occurred',
        statusCode,
      );
    }
  }

  static Exception _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return NetworkException('Connection timeout. Please try again.');

      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final message = _extractErrorMessage(error.response);

        if (statusCode == 401) {
          return UnauthorizedException(message ?? 'Unauthorized access');
        }

        return ServerException(
          message ?? 'Server error occurred',
          statusCode,
        );

      case DioExceptionType.cancel:
        return ServerException('Request was cancelled');

      case DioExceptionType.connectionError:
        return NetworkException(
          'No internet connection. Please check your network.',
        );

      case DioExceptionType.unknown:
        if (error.error != null && error.error is Exception) {
          return error.error as Exception;
        }
        return NetworkException('An unexpected error occurred');

      default:
        return ServerException('An unexpected error occurred');
    }
  }

  static String? _extractErrorMessage(Response? response) {
    if (response?.data == null) return null;

    final data = response!.data;

    if (data is Map<String, dynamic>) {
      return data['message'] as String? ??
          data['error'] as String? ??
          data['msg'] as String?;
    }

    return null;
  }
}
