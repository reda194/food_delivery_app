/// Base Exception class
class AppException implements Exception {
  final String message;

  AppException(this.message);

  @override
  String toString() => message;
}

/// Server Exception
class ServerException extends AppException {
  ServerException([String message = 'Server error occurred'])
      : super(message);
}

/// Cache Exception
class CacheException extends AppException {
  CacheException([String message = 'Cache error occurred']) : super(message);
}

/// Network Exception
class NetworkException extends AppException {
  NetworkException([String message = 'Network error - check your connection'])
      : super(message);
}

/// Authentication Exception
class AuthException extends AppException {
  AuthException([String message = 'Authentication failed']) : super(message);
}

/// Not Found Exception
class NotFoundException extends AppException {
  NotFoundException([String message = 'Resource not found'])
      : super(message);
}

/// Unauthorized Exception
class UnauthorizedException extends AppException {
  UnauthorizedException([String message = 'Unauthorized access'])
      : super(message);
}

/// Supabase Exception
class SupabaseException extends AppException {
  SupabaseException([String message = 'Supabase error occurred'])
      : super(message);
}

/// Validation Exception
class ValidationException extends AppException {
  ValidationException([String message = 'Validation failed']) : super(message);
}

/// Database Exception
class DatabaseException extends AppException {
  DatabaseException([String message = 'Database error occurred'])
      : super(message);
}

/// Timeout Exception
class TimeoutException extends AppException {
  TimeoutException([String message = 'Request timed out']) : super(message);
}

/// File Upload Exception
class FileUploadException extends AppException {
  FileUploadException([String message = 'File upload failed']) : super(message);
}

/// Real-time Subscription Exception
class SubscriptionException extends AppException {
  SubscriptionException([String message = 'Subscription error'])
      : super(message);
}
