import 'package:dio/dio.dart';

class ApiService {
  final Dio _dio;

  ApiService._(this._dio);

  factory ApiService.create({String baseUrl = 'https://api.igcse.local/mock'}) {
    final dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 5),
        receiveTimeout: const Duration(seconds: 5),
        headers: {'Content-Type': 'application/json'},
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          await Future.delayed(const Duration(milliseconds: 200));
          return handler.next(options);
        },
        onResponse: (response, handler) {
          return handler.next(response);
        },
        onError: (e, handler) {
          return handler.next(e);
        },
      ),
    );

    return ApiService._(dio);
  }

  Future<Response<dynamic>> get(String path) => _dio.get(path);
}
