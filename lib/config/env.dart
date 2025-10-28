enum Environment { dev, staging, prod }

class Env {
  static Environment _current = Environment.dev;

  static Environment get current => _current;

  static void setEnvironment(Environment env) {
    _current = env;
  }

  static String get apiBaseUrl {
    switch (_current) {
      case Environment.dev:
        return 'https://igcse-learninghub-api-ajbhg7anb8cfcaa2.southeastasia-01.azurewebsites.net/api/v1';
      case Environment.staging:
        return 'https://igcse-learninghub-api-ajbhg7anb8cfcaa2.southeastasia-01.azurewebsites.net/api/v1';
      case Environment.prod:
        return 'https://igcse-learninghub-api-ajbhg7anb8cfcaa2.southeastasia-01.azurewebsites.net/api/v1';
    }
  }

  static Duration get connectionTimeout => const Duration(seconds: 30);
  static Duration get receiveTimeout => const Duration(seconds: 30);

  static bool get enableLogging => _current != Environment.prod;
}
