class ApiConstants {
  // Base URL
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://api.example.com',
  );
  
  // API Version
  static const String apiVersion = '/api/v1';
  
  // Endpoints
  static const String auth = '/auth';
  static const String login = '$auth/login';
  static const String register = '$auth/register';
  static const String refreshToken = '$auth/refresh';
  static const String logout = '$auth/logout';
  
  static const String users = '/users';
  static const String profile = '/profile';
  
  static const String courses = '/courses';
  static const String categories = '/categories';
  static const String enrollments = '/enrollments';
  static const String lessons = '/lessons';
  static const String progress = '/progress';
  
  // Timeout durations
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  
  // Headers
  static const Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
}
