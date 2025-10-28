abstract class Failure {
  final String message;
  final String? code;
  
  const Failure({
    required this.message,
    this.code,
  });
  
  @override
  String toString() => 'Failure: $message ${code != null ? '($code)' : ''}';
}

// Network failures
class ServerFailure extends Failure {
  const ServerFailure({
    required super.message,
    super.code,
  });
}

class NetworkFailure extends Failure {
  const NetworkFailure({
    super.message = 'No internet connection',
    super.code,
  });
}

class TimeoutFailure extends Failure {
  const TimeoutFailure({
    super.message = 'Request timeout',
    super.code,
  });
}

// Auth failures
class AuthFailure extends Failure {
  const AuthFailure({
    required super.message,
    super.code,
  });
}

class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure({
    super.message = 'Unauthorized access',
    super.code,
  });
}

// Cache failures
class CacheFailure extends Failure {
  const CacheFailure({
    super.message = 'Cache error',
    super.code,
  });
}

// Validation failures
class ValidationFailure extends Failure {
  final Map<String, List<String>>? errors;
  
  const ValidationFailure({
    required super.message,
    super.code,
    this.errors,
  });
}
