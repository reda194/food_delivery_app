import 'package:logger/logger.dart';
import '../constants/app_constants.dart';

/// Centralized logging service for the application
class LoggerService {
  static LoggerService? _instance;
  static LoggerService get instance => _instance ??= LoggerService._();

  late final Logger _logger;

  LoggerService._() {
    _logger = Logger(
      level: AppConstants.isDebugMode ? Level.debug : Level.info,
      printer: PrettyPrinter(
        methodCount: 2,
        errorMethodCount: 8,
        lineLength: 120,
        colors: true,
        printEmojis: true,
        noBoxingByDefault: false,
      ),
    );
  }

  /// Log debug information
  void debug(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _logger.d(message, error: error, stackTrace: stackTrace);
  }

  /// Log info
  void info(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _logger.i(message, error: error, stackTrace: stackTrace);
  }

  /// Log warning
  void warning(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _logger.w(message, error: error, stackTrace: stackTrace);
  }

  /// Log error
  void error(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _logger.e(message, error: error, stackTrace: stackTrace);
  }

  /// Log success (green emoji)
  void success(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    if (AppConstants.isDebugMode) {
      _logger.i('✅ $message', error: error, stackTrace: stackTrace);
    }
  }

  /// Log critical error
  void critical(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _logger.wtf(message, error: error, stackTrace: stackTrace);
  }

  /// Custom log for network requests
  void network(String method, String url, {int? statusCode, String? body}) {
    if (AppConstants.isDebugMode) {
      final statusEmoji = _getStatusEmoji(statusCode);
      _logger.d('$statusEmoji $method $url');
      
      if (statusCode != null) {
        _logger.d('Status: $statusCode');
      }
      
      if (body != null && body.isNotEmpty) {
        _logger.d('Body: $body');
      }
    }
  }

  /// Custom log for database operations
  void database(String operation, String table, {String? details}) {
    if (AppConstants.isDebugMode) {
      _logger.d('🗄️ $operation on $table');
      if (details != null) {
        _logger.d('Details: $details');
      }
    }
  }

  /// Custom log for authentication events
  void auth(String event, {String? userId}) {
    if (AppConstants.isDebugMode) {
      final user = userId ?? 'unknown';
      _logger.i('🔐 $event for user: $user');
    }
  }

  /// Custom log for performance metrics
  void performance(String operation, Duration duration, {String? details}) {
    if (AppConstants.isDebugMode) {
      _logger.w('⏱️ $operation took ${duration.inMilliseconds}ms');
      if (details != null) {
        _logger.w('Details: $details');
      }
    }
  }

  /// Log analytics events (only in production for privacy)
  void analytics(
    String event,
    Map<String, dynamic> parameters, {
    String? userId,
  }) {
    if (!AppConstants.isDebugMode) {
      _logger.i('📊 Analytics: $event');
      if (userId != null) {
        _logger.i('User: $userId');
      }
      parameters.forEach((key, value) {
        _logger.i('$key: $value');
      });
    }
  }

  /// Get emoji for HTTP status codes
  String _getStatusEmoji(int? statusCode) {
    if (statusCode == null) return '📡';
    
    if (statusCode >= 200 && statusCode < 300) return '✅';
    if (statusCode >= 300 && statusCode < 400) return '↩️';
    if (statusCode >= 400 && statusCode < 500) return '⚠️';
    if (statusCode >= 500) return '❌';
    
    return '❓';
  }

  /// Create a scoped logger for specific features
  Logger scoped(String scope) {
    return Logger(
      printer: PrettyPrinter(
        methodCount: 0,
        errorMethodCount: 3,
        lineLength: 80,
        colors: true,
        printEmojis: true,
      ),
    );
  }

  /// Log performance for async operations
  Future<T> measureAsync<T>(
    String operation,
    Future<T> Function() function, {
    String? details,
  }) async {
    final stopwatch = Stopwatch()..start();
    
    try {
      final result = await function();
      stopwatch.stop();
      performance(operation, stopwatch.elapsed, details: details);
      return result;
    } catch (e) {
      stopwatch.stop();
      performance('$operation (failed)', stopwatch.elapsed, details: '$details\nError: $e');
      rethrow;
    }
  }

  /// Log performance for sync operations
  T measure<T>(
    String operation,
    T Function() function, {
    String? details,
  }) {
    final stopwatch = Stopwatch()..start();
    
    try {
      final result = function();
      stopwatch.stop();
      performance(operation, stopwatch.elapsed, details: details);
      return result;
    } catch (e) {
      stopwatch.stop();
      performance('$operation (failed)', stopwatch.elapsed, details: '$details\nError: $e');
      rethrow;
    }
  }
}
