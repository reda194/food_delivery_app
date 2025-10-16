import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../constants/api_constants.dart';
import '../mock/mock_api_service.dart';
import 'dio_interceptor.dart';

/// API Client using Dio for HTTP requests
/// Singleton pattern for single instance throughout the app
class ApiClient {
  static ApiClient? _instance;
  late Dio _dio;

  // Mock mode flag - set to true to use mock data instead of real API
  static const bool _useMockData = true;

  ApiClient._internal() {
    _dio = Dio(_baseOptions);
    _dio.interceptors.add(AppInterceptor());

    // Add logging interceptor in debug mode
    if (kDebugMode) {
      _dio.interceptors.add(LogInterceptor(
        request: true,
        requestHeader: true,
        requestBody: true,
        responseHeader: false,
        responseBody: true,
        error: true,
        logPrint: (obj) => debugPrint(obj.toString()),
      ));
    }
  }

  factory ApiClient() {
    _instance ??= ApiClient._internal();
    return _instance!;
  }

  Dio get dio => _dio;

  static BaseOptions get _baseOptions => BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: ApiConstants.connectionTimeout,
        receiveTimeout: ApiConstants.receiveTimeout,
        headers: ApiConstants.headers,
        validateStatus: (status) {
          return status != null && status < 500;
        },
      );

  /// GET Request
  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    // Use mock data if mock mode is enabled
    if (_useMockData) {
      return _handleMockRequest('GET', path, queryParameters: queryParameters);
    }

    try {
      final response = await _dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  /// POST Request
  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    // Use mock data if mock mode is enabled
    if (_useMockData) {
      return _handleMockRequest('POST', path, data: data, queryParameters: queryParameters);
    }

    try {
      final response = await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  /// PUT Request
  Future<Response> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  /// DELETE Request
  Future<Response> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  /// PATCH Request
  Future<Response> patch(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.patch(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  /// Upload file
  Future<Response> uploadFile(
    String path,
    String filePath, {
    Map<String, dynamic>? data,
    String fileKey = 'file',
    ProgressCallback? onSendProgress,
  }) async {
    final formData = FormData.fromMap({
      ...?data,
      fileKey: await MultipartFile.fromFile(filePath),
    });

    return post(
      path,
      data: formData,
      options: Options(
        headers: {'Content-Type': 'multipart/form-data'},
      ),
    );
  }

  /// Download file
  Future<Response> downloadFile(
    String urlPath,
    String savePath, {
    ProgressCallback? onReceiveProgress,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.download(
        urlPath,
        savePath,
        onReceiveProgress: onReceiveProgress,
        cancelToken: cancelToken,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  /// Handle mock requests based on method and path
  Future<Response> _handleMockRequest(
    String method,
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    // Remove base URL from path if present
    final cleanPath = path.replaceFirst(ApiConstants.baseUrl, '');

    switch (method) {
      case 'GET':
        return _handleMockGetRequest(cleanPath, queryParameters);
      case 'POST':
        return _handleMockPostRequest(cleanPath, data);
      default:
        throw UnsupportedError('Mock method $method not supported');
    }
  }

  /// Handle mock GET requests
  Future<Response> _handleMockGetRequest(String path, Map<String, dynamic>? queryParameters) async {
    if (path == '/categories') {
      return MockApiService.getCategories();
    } else if (path == '/restaurants/featured') {
      return MockApiService.getFeaturedRestaurants();
    } else if (path == '/restaurants') {
      return MockApiService.getAllRestaurants();
    } else if (path.startsWith('/restaurants/') && path.endsWith('/menu')) {
      final restaurantId = path.split('/')[2];
      return MockApiService.getMenuItems(restaurantId);
    } else if (path.startsWith('/restaurants/') && path.endsWith('/reviews')) {
      final restaurantId = path.split('/')[2];
      return MockApiService.getReviews(restaurantId);
    } else if (path.startsWith('/restaurants/')) {
      final restaurantId = path.split('/')[2];
      return MockApiService.getRestaurantDetails(restaurantId);
    }

    throw UnsupportedError('Mock GET path $path not supported');
  }

  /// Handle mock POST requests
  Future<Response> _handleMockPostRequest(String path, dynamic data) async {
    if (path.startsWith('/restaurants/') && path.endsWith('/reviews')) {
      final restaurantId = path.split('/')[2];
      return MockApiService.submitReview(restaurantId, data as Map<String, dynamic>);
    } else if (path.startsWith('/reviews/') && path.endsWith('/helpful')) {
      final reviewId = path.split('/')[2];
      return MockApiService.markReviewHelpful(reviewId);
    }

    throw UnsupportedError('Mock POST path $path not supported');
  }
}
