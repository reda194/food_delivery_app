/// Base Exception class
class AppException implements Exception {
  final String message;

  AppException(this.message);

  @override
  String toString() => message;
}

/// Server Exception
class ServerException extends AppException {
  ServerException([super.message = 'Server error occurred']);
}

/// Cache Exception
class CacheException extends AppException {
  CacheException([super.message = 'Cache error occurred']);
}

/// Network Exception
class NetworkException extends AppException {
  NetworkException([super.message = 'Network error - check your connection']);
}

/// Authentication Exception
/// Note: Named AppAuthException to avoid conflict with Supabase's AuthException
class AppAuthException extends AppException {
  AppAuthException([super.message = 'Authentication failed']);
}

/// Not Found Exception
class NotFoundException extends AppException {
  NotFoundException([super.message = 'Resource not found']);
}

/// Unauthorized Exception
class UnauthorizedException extends AppException {
  UnauthorizedException([super.message = 'Unauthorized access']);
}

/// Supabase Exception
class SupabaseException extends AppException {
  SupabaseException([super.message = 'Supabase error occurred']);
}

/// Validation Exception
class ValidationException extends AppException {
  ValidationException([super.message = 'Validation failed']);
}

/// Database Exception
class DatabaseException extends AppException {
  DatabaseException([super.message = 'Database error occurred']);
}

/// Timeout Exception
class TimeoutException extends AppException {
  TimeoutException([super.message = 'Request timed out']);
}

/// File Upload Exception
class FileUploadException extends AppException {
  FileUploadException([super.message = 'File upload failed']);
}

/// Real-time Subscription Exception
class SubscriptionException extends AppException {
  SubscriptionException([super.message = 'Subscription error']);
}
