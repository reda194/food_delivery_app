import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Custom Dio Interceptor for handling authentication and request/response modifications
class AppInterceptor extends Interceptor {
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Add authentication token to headers if available
    final token = await _getAuthToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    // Add device info headers
    options.headers['Device-Type'] = 'mobile';
    options.headers['Platform'] = defaultTargetPlatform.name;

    debugPrint('🌐 REQUEST[${options.method}] => PATH: ${options.path}');

    super.onRequest(options, handler);
  }

  @override
  void onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) {
    debugPrint(
      '✅ RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}',
    );

    super.onResponse(response, handler);
  }

  @override
  void onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    debugPrint(
      '❌ ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}',
    );
    debugPrint('❌ ERROR MESSAGE: ${err.message}');

    // Handle 401 Unauthorized - refresh token or logout
    if (err.response?.statusCode == 401) {
      // Attempt to refresh token
      final refreshed = await _refreshAuthToken();
      if (refreshed) {
        // Retry the original request
        return handler.resolve(await _retry(err.requestOptions));
      } else {
        // Logout user
        await _logout();
      }
    }

    super.onError(err, handler);
  }

  /// Get authentication token from storage
  Future<String?> _getAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  /// Refresh authentication token
  Future<bool> _refreshAuthToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final refreshToken = prefs.getString('refresh_token');

      if (refreshToken == null) return false;

      // Make API call to refresh token
      // final dio = Dio();
      // final response = await dio.post('/auth/refresh-token', data: {
      //   'refresh_token': refreshToken,
      // });

      // if (response.statusCode == 200) {
      //   final newToken = response.data['access_token'];
      //   final newRefreshToken = response.data['refresh_token'];

      //   await prefs.setString('auth_token', newToken);
      //   await prefs.setString('refresh_token', newRefreshToken);

      //   return true;
      // }

      return false;
    } catch (e) {
      debugPrint('Error refreshing token: $e');
      return false;
    }
  }

  /// Retry failed request with new token
  Future<Response<dynamic>> _retry(RequestOptions requestOptions) async {
    final options = Options(
      method: requestOptions.method,
      headers: requestOptions.headers,
    );

    final dio = Dio();
    return dio.request<dynamic>(
      requestOptions.path,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
      options: options,
    );
  }

  /// Logout user and clear tokens
  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('refresh_token');
    await prefs.remove('user_data');

    // Navigate to login screen
    // This should be handled by the app's navigation service
    debugPrint('🚪 User logged out due to authentication failure');
  }
}
