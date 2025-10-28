class ServerException implements Exception {
  final String? message;
  final int? statusCode;
  
  const ServerException({
    this.message,
    this.statusCode,
  });
  
  @override
  String toString() => 'ServerException: ${message ?? 'Unknown error'} ${statusCode != null ? '($statusCode)' : ''}';
}

class NetworkException implements Exception {
  final String? message;
  
  const NetworkException({this.message});
  
  @override
  String toString() => 'NetworkException: ${message ?? 'No internet connection'}';
}

class CacheException implements Exception {
  final String? message;
  
  const CacheException({this.message});
  
  @override
  String toString() => 'CacheException: ${message ?? 'Cache error'}';
}

class UnauthorizedException implements Exception {
  final String? message;
  
  const UnauthorizedException({this.message});
  
  @override
  String toString() => 'UnauthorizedException: ${message ?? 'Unauthorized'}';
}

class NotFoundException implements Exception {
  final String? message;
  
  const NotFoundException({this.message});
  
  @override
  String toString() => 'NotFoundException: ${message ?? 'Resource not found'}';
}

class ValidationException implements Exception {
  final String? message;
  final Map<String, List<String>>? errors;
  
  const ValidationException({
    this.message,
    this.errors,
  });
  
  @override
  String toString() => 'ValidationException: ${message ?? 'Validation failed'}';
}
