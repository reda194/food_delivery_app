import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:crypto/crypto.dart';
import '../constants/app_constants.dart';
import '../errors/exceptions.dart';
import '../services/logger_service.dart';
import '../services/supabase_service.dart';

/// Secure API Service with Rate Limiting and Caching
class ApiService {
  static ApiService? _instance;
  static ApiService get instance => _instance ??= ApiService._();

  late final Dio _dio;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  final LoggerService _logger = LoggerService.instance;

  // Rate limiting
  final Map<String, List<DateTime>> _rateLimitTracker = {};
  final int _maxRequestsPerMinute = 60;
  final Duration _rateLimitWindow = const Duration(minutes: 1);

  // Request cache
  final Map<String, CachedResponse> _cache = {};
  final Map<String, Timer> _cacheTimers = {};

  ApiService._() {
    _dio = Dio(BaseOptions(
      connectTimeout: AppConstants.connectionTimeout,
      receiveTimeout: AppConstants.connectionTimeout,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'User-Agent': 'FoodDelivery/1.0.0',
      },
    ));

    _setupInterceptors();
  }

  /// Setup Dio interceptors for logging and authentication
  void _setupInterceptors() {
    // Request interceptor
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        await _addAuthenticationHeader(options);
        
        // Add request tracking for rate limiting
        await _checkRateLimit(options.path);
        
        // Log outgoing requests
        _logger.network(
          options.method,
          options.path,
          statusCode: null,
          body: _isSafeToLog(options.data) ? jsonEncode(options.data) : '[Binary Data]',
        );
        
        handler.next(options);
      },
      onResponse: (response, handler) {
        // Log successful responses
        _logger.network(
          response.requestOptions.method,
          response.requestOptions.path,
          statusCode: response.statusCode,
        );
        
        handler.next(response);
      },
      onError: (error, handler) {
        // Handle 401 unauthorized - token refresh
        if (error.response?.statusCode == 401) {
          _handleUnauthorizedError(error);
        }
        
        // Log error responses
        _logger.network(
          error.requestOptions.method,
          error.requestOptions.path,
          statusCode: error.response?.statusCode,
        );
        
        // Map HTTP errors to custom exceptions
        final exception = _mapDioErrorToException(error);
        _logger.error('API Error: ${exception.toString()}');
        
        handler.next(DioException(
          requestOptions: error.requestOptions,
          error: exception,
          response: error.response,
        ));
      },
    ));
  }

  /// Add authentication header to requests
  Future<void> _addAuthenticationHeader(RequestOptions options) async {
    try {
      final token = _secureStorage.read(key: 'user_token');
      options.headers['Authorization'] = 'Bearer $token';
        } catch (e) {
      _logger.warning('Failed to add auth header: $e');
    }
  }

  /// Implement rate limiting
  Future<void> _checkRateLimit(String endpoint) async {
    final key = endpoint.split('/').first;
    final now = DateTime.now();
    
    if (!_rateLimitTracker.containsKey(key)) {
      _rateLimitTracker[key] = [];
    }

    // Clean old requests outside the window
    _rateLimitTracker[key]!.removeWhere(
      (timestamp) => now.difference(timestamp) > _rateLimitWindow,
    );

    // Check rate limit
    if (_rateLimitTracker[key]!.length >= _maxRequestsPerMinute) {
      _logger.warning('Rate limit exceeded for endpoint: $endpoint');
      throw RateLimitException('Too many requests. Please try again later.');
    }

    // Add current request
    _rateLimitTracker[key]!.add(now);
  }

  /// Handle 401 unauthorized errors
  Future<void> _handleUnauthorizedError(DioException error) async {
    try {
      // Attempt to refresh the token
      await SupabaseService.instance.refreshSession();
      
      // If successful, the interceptor will retry with new token
      _logger.info('Token refresh successful');
    } catch (e) {
      // If refresh fails, clear tokens and force re-login
      await _secureStorage.deleteAll();
      _logger.error('Token refresh failed: $e');

      // Navigate to login screen (would need to be handled by app state)
      throw AppAuthException('Session expired. Please log in again.');
    }
  }

  /// Map Dio errors to custom exceptions
  Exception _mapDioErrorToException(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
        return TimeoutException('Request timed out. Please check your connection.');
        
      case DioExceptionType.connectionError:
        return NetworkException('No internet connection. Please check your network.');
        
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final message = error.response?.data?['message'] ?? 'Server error';
        
        switch (statusCode) {
          case 400:
            return ValidationException(message);
          case 401:
            return AppAuthException(message);
          case 403:
            return UnauthorizedException(message);
          case 404:
            return NotFoundException(message);
          case 429:
            return RateLimitException(message);
          case 500:
          case 502:
          case 503:
          case 504:
            return ServerException(AppConstants.serverErrorMessage);
          default:
            return ServerException('Request failed with status $statusCode');
        }
        
      default:
        return ServerException(AppConstants.defaultErrorMessage);
    }
  }

  /// ==================== GET REQUESTS ====================

  /// Generic GET request with caching
  Future<T> get<T>(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    T Function(dynamic)? fromJson,
    Duration cacheDuration = AppConstants.cacheExpiration,
    bool bypassCache = false,
  }) async {
    return _requestWithCache<T>(
      'GET',
      endpoint,
      fromJson: fromJson,
      queryParameters: queryParameters,
      cacheDuration: cacheDuration,
      bypassCache: bypassCache,
    );
  }

  /// GET request without caching
  Future<Map<String, dynamic>> getRaw(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.get(endpoint, queryParameters: queryParameters);
      return response.data as Map<String, dynamic>;
    } catch (e) {
      throw _extractException(e);
    }
  }

  /// ==================== POST REQUESTS ====================

  /// Generic POST request
  Future<T> post<T>(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    T Function(dynamic)? fromJson,
    Duration cacheDuration = AppConstants.cacheExpiration,
  }) async {
    try {
      final response = await _requestWithRetry<T>(
        () => _dio.post(
          endpoint,
          data: data,
          queryParameters: queryParameters,
        ),
        fromJson: fromJson,
      );

      // Invalidate cache for related GET requests
      _invalidateRelatedCache(endpoint);

      return response;
    } catch (e) {
      throw _extractException(e);
    }
  }

  /// ==================== PUT REQUESTS ====================

  /// Generic PUT request
  Future<T> put<T>(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    T Function(dynamic)? fromJson,
  }) async {
    try {
      final response = await _requestWithRetry<T>(
        () => _dio.put(
          endpoint,
          data: data,
          queryParameters: queryParameters,
        ),
        fromJson: fromJson,
      );

      // Invalidate cache for related GET requests
      _invalidateRelatedCache(endpoint);

      return response;
    } catch (e) {
      throw _extractException(e);
    }
  }

  /// ==================== DELETE REQUESTS ====================

  /// Generic DELETE request
  Future<T> delete<T>(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    T Function(dynamic)? fromJson,
  }) async {
    try {
      final response = await _requestWithRetry<T>(
        () => _dio.delete(
          endpoint,
          queryParameters: queryParameters,
        ),
        fromJson: fromJson,
      );

      // Invalidate cache for related GET requests
      _invalidateRelatedCache(endpoint);

      return response;
    } catch (e) {
      throw _extractException(e);
    }
  }

  /// ==================== FILE UPLOAD ====================

  /// Upload file with progress tracking
  Future<String> uploadFile(
    String endpoint,
    File file, {
    Map<String, dynamic>? data,
    ProgressCallback? onProgress,
  }) async {
    try {
      final formData = FormData.fromMap({
        'file': MultipartFile.fromBytes(
          await file.readAsBytes(),
          filename: file.path.split('/').last,
        ),
        ...?data,
      });

      final response = await _dio.post(
        endpoint,
        data: formData,
        onSendProgress: onProgress,
      );

      return response.data['url'] as String;
    } catch (e) {
      throw _extractException(e);
    }
  }

  /// Download file with progress tracking
  Future<File> downloadFile(
    String endpoint,
    String savePath, {
    ProgressCallback? onProgress,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.download(
        endpoint,
        savePath,
        onReceiveProgress: onProgress,
        queryParameters: queryParameters,
        options: Options(
          responseType: ResponseType.stream,
        ),
      );

      return File(savePath);
    } catch (e) {
      throw _extractException(e);
    }
  }

  /// ==================== BATCH OPERATIONS ====================

  /// Execute multiple requests concurrently
  Future<List<T>> batchRequest<T>(
    List<Future<T>> requests, {
    Duration timeout = const Duration(seconds: 30),
  }) async {
    try {
      return await Future.wait(
        requests,
        eagerError: true,
      ).timeout(timeout);
    } catch (e) {
      throw _extractException(e);
    }
  }

  /// ==================== CACHING ====================

  /// Request with caching support
  Future<T> _requestWithCache<T>(
    String method,
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    T Function(dynamic)? fromJson,
    Duration cacheDuration = AppConstants.cacheExpiration,
    bool bypassCache = false,
  }) async {
    final cacheKey = _generateCacheKey(method, endpoint, queryParameters);
    
    // Check cache first
    if (!bypassCache && method == 'GET') {
      final cached = _getCachedResponse<T>(cacheKey, fromJson);
      if (cached != null) {
        return cached;
      }
    }

    // Make actual request
    return _requestWithRetry<T>(() {
      switch (method) {
        case 'GET':
          return _dio.get(endpoint, queryParameters: queryParameters);
        default:
          throw UnsupportedError('Method $method not supported in cache');
      }
    }, fromJson: fromJson, cacheKey: cacheKey, cacheDuration: cacheDuration);
  }

  /// Request with retry logic
  Future<T> _requestWithRetry<T>(
    Future<Response> Function() requestFunction, {
    T Function(dynamic)? fromJson,
    String? cacheKey,
    Duration cacheDuration = AppConstants.cacheExpiration,
    int maxRetries = 3,
  }) async {
    int attempts = 0;
    dynamic lastError;

    while (attempts < maxRetries) {
      try {
        final response = await requestFunction();
        final data = fromJson != null 
            ? fromJson(response.data) 
            : response.data as T;

        // Cache the response if applicable
        if (cacheKey != null && response.statusCode == 200) {
          _cacheResponse(cacheKey, data, cacheDuration);
        }

        return data;
      } catch (e) {
        attempts++;
        lastError = e;

        if (attempts < maxRetries) {
          final delay = Duration(milliseconds: 1000 * attempts);
          _logger.warning('Request failed (attempt $attempts/$maxRetries), retrying in ${delay.inMilliseconds}ms');
          await Future.delayed(delay);
        }
      }
    }

    throw _extractException(lastError);
  }

  /// Cache response
  void _cacheResponse(String key, dynamic data, Duration duration) {
    _cache[key] = CachedResponse(data, DateTime.now().add(duration));
    
    // Set timer to invalidate cache
    _cacheTimers[key]?.cancel();
    _cacheTimers[key] = Timer(duration, () {
      _cache.remove(key);
      _cacheTimers.remove(key);
    });
  }

  /// Get cached response
  T? _getCachedResponse<T>(String key, T Function(dynamic)? fromJson) {
    final cached = _cache[key];
    if (cached != null && cached.isValid) {
      return fromJson != null ? fromJson(cached.data) : cached.data as T;
    }
    return null;
  }

  /// Invalidate related cache entries
  void _invalidateRelatedCache(String endpoint) {
    final keysToRemove = <String>[];
    for (final key in _cache.keys) {
      if (key.contains(endpoint)) {
        keysToRemove.add(key);
      }
    }
    
    for (final key in keysToRemove) {
      _cache.remove(key);
      _cacheTimers[key]?.cancel();
      _cacheTimers.remove(key);
    }
  }

  /// Generate cache key
  String _generateCacheKey(
    String method,
    String endpoint,
    Map<String, dynamic>? queryParams,
  ) {
    final queryStr = queryParams?.entries
        .map((e) => '${e.key}=${e.value}')
        .join('&') ?? '';
    
    return _hashString('$method:$endpoint:$queryStr');
  }

  /// Hash string for cache keys
  String _hashString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  /// ==================== UTILITY METHODS ====================

  /// Check if data is safe to log (not sensitive)
  bool _isSafeToLog(dynamic data) {
    if (data == null) return true;
    if (data is Map) {
      final sensitiveKeys = ['password', 'token', 'secret', 'key'];
      for (final key in data.keys) {
        if (sensitiveKeys.any((sensitive) => key.toString().toLowerCase().contains(sensitive))) {
          return false;
        }
      }
    }
    return true;
  }

  /// Extract exception from error
  Exception _extractException(dynamic error) {
    if (error is DioException) {
      return _mapDioErrorToException(error);
    }
    if (error is Exception) {
      return error;
    }
    return ServerException(AppConstants.defaultErrorMessage);
  }

  /// Clear all cached data
  void clearCache() {
    for (final timer in _cacheTimers.values) {
      timer.cancel();
    }
    _cache.clear();
    _cacheTimers.clear();
    _logger.info('API cache cleared');
  }

  /// Get cache statistics
  Map<String, dynamic> getCacheStats() {
    return {
      'size': _cache.length,
      'keys': _cache.keys.toList(),
      'memory_usage': _cache.length * 1024, // Rough estimate
    };
  }

  /// Dispose resources
  void dispose() {
    clearCache();
    _dio.close();
    _rateLimitTracker.clear();
    _logger.info('API service disposed');
  }
}

/// Cached response data class
class CachedResponse {
  final dynamic data;
  final DateTime expiry;

  CachedResponse(this.data, this.expiry);

  bool get isValid => DateTime.now().isBefore(expiry);
}

/// Rate limit exception
class RateLimitException extends AppException {
  RateLimitException(super.message);
}
