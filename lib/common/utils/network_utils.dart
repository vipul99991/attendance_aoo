/// Network-related utilities
import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;
import 'package:http/http.dart' as http;
import '../constants/app_constants.dart';

class NetworkUtils {
  /// Perform a GET request with error handling
  static Future<NetworkResponse> get(
    String url, {
    Map<String, String>? headers,
    Duration? timeout,
  }) async {
    try {
      final response = await http
          .get(Uri.parse(url), headers: headers)
          .timeout(timeout ?? AppConstants.defaultNetworkTimeout);
      
      return NetworkResponse(
        statusCode: response.statusCode,
        data: _parseResponseData(response.body),
        headers: response.headers,
        success: response.statusCode >= 200 && response.statusCode < 300,
      );
    } on TimeoutException {
      return NetworkResponse(
        statusCode: -1,
        data: null,
        headers: {},
        success: false,
        error: AppConstants.timeoutError,
      );
    } on Exception catch (e) {
      return NetworkResponse(
        statusCode: -1,
        data: null,
        headers: {},
        success: false,
        error: e.toString(),
      );
    }
  }

  /// Perform a POST request with error handling
  static Future<NetworkResponse> post(
    String url, {
    Map<String, String>? headers,
    dynamic body,
    Encoding? encoding,
    Duration? timeout,
  }) async {
    try {
      final response = await http
          .post(
            Uri.parse(url),
            headers: headers,
            body: body,
            encoding: encoding,
          )
          .timeout(timeout ?? AppConstants.defaultNetworkTimeout);
      
      return NetworkResponse(
        statusCode: response.statusCode,
        data: _parseResponseData(response.body),
        headers: response.headers,
        success: response.statusCode >= 200 && response.statusCode < 300,
      );
    } on TimeoutException {
      return NetworkResponse(
        statusCode: -1,
        data: null,
        headers: {},
        success: false,
        error: AppConstants.timeoutError,
      );
    } on Exception catch (e) {
      return NetworkResponse(
        statusCode: -1,
        data: null,
        headers: {},
        success: false,
        error: e.toString(),
      );
    }
  }

  /// Perform a PUT request with error handling
  static Future<NetworkResponse> put(
    String url, {
    Map<String, String>? headers,
    dynamic body,
    Encoding? encoding,
    Duration? timeout,
  }) async {
    try {
      final response = await http
          .put(
            Uri.parse(url),
            headers: headers,
            body: body,
            encoding: encoding,
          )
          .timeout(timeout ?? AppConstants.defaultNetworkTimeout);
      
      return NetworkResponse(
        statusCode: response.statusCode,
        data: _parseResponseData(response.body),
        headers: response.headers,
        success: response.statusCode >= 200 && response.statusCode < 300,
      );
    } on TimeoutException {
      return NetworkResponse(
        statusCode: -1,
        data: null,
        headers: {},
        success: false,
        error: AppConstants.timeoutError,
      );
    } on Exception catch (e) {
      return NetworkResponse(
        statusCode: -1,
        data: null,
        headers: {},
        success: false,
        error: e.toString(),
      );
    }
  }

  /// Perform a DELETE request with error handling
  static Future<NetworkResponse> delete(
    String url, {
    Map<String, String>? headers,
    Duration? timeout,
  }) async {
    try {
      final response = await http
          .delete(Uri.parse(url), headers: headers)
          .timeout(timeout ?? AppConstants.defaultNetworkTimeout);
      
      return NetworkResponse(
        statusCode: response.statusCode,
        data: _parseResponseData(response.body),
        headers: response.headers,
        success: response.statusCode >= 200 && response.statusCode < 300,
      );
    } on TimeoutException {
      return NetworkResponse(
        statusCode: -1,
        data: null,
        headers: {},
        success: false,
        error: AppConstants.timeoutError,
      );
    } on Exception catch (e) {
      return NetworkResponse(
        statusCode: -1,
        data: null,
        headers: {},
        success: false,
        error: e.toString(),
      );
    }
  }

  /// Check if the device has internet connectivity
  static Future<bool> hasInternetConnection() async {
    try {
      final result = await http
          .get(Uri.parse('https://www.google.com'))
          .timeout(const Duration(seconds: 5));
      return result.statusCode == 200;
    } on TimeoutException {
      return false;
    } on Exception {
      return false;
    }
  }

 /// Check if a specific URL is reachable
 static Future<bool> isUrlReachable(String url, {Duration? timeout}) async {
    try {
      final result = await http
          .get(Uri.parse(url))
          .timeout(timeout ?? const Duration(seconds: 10));
      return result.statusCode >= 200 && result.statusCode < 400;
    } on TimeoutException {
      return false;
    } on Exception {
      return false;
    }
  }

  /// Build query parameters string from a map
  static String buildQueryParameters(Map<String, dynamic> parameters) {
    if (parameters.isEmpty) return '';
    
    List<String> paramList = [];
    parameters.forEach((key, value) {
      if (value != null) {
        String encodedValue = Uri.encodeComponent(value.toString());
        paramList.add('$key=$encodedValue');
      }
    });
    
    return '?${paramList.join('&')}';
  }

 /// Parse response data based on content type
  static dynamic _parseResponseData(String body) {
    if (body.isEmpty) return null;
    
    try {
      // Try to parse as JSON
      return json.decode(body);
    } catch (e) {
      // If JSON parsing fails, return the raw string
      return body;
    }
  }

  /// Format request headers with default values
  static Map<String, String> formatHeaders({
    Map<String, String>? additionalHeaders,
    String contentType = 'application/json',
    String? authToken,
  }) {
    Map<String, String> headers = {
      'Content-Type': contentType,
      'Accept': 'application/json',
    };
    
    if (authToken != null) {
      headers['Authorization'] = 'Bearer $authToken';
    }
    
    if (additionalHeaders != null) {
      headers.addAll(additionalHeaders);
    }
    
    return headers;
  }

  /// Retry a network request with exponential backoff
  static Future<NetworkResponse> retryRequest(
    Future<NetworkResponse> Function() request,
    {int maxRetries = 3, Duration baseDelay = const Duration(seconds: 1)},
  ) async {
    NetworkResponse? lastResponse;
    
    for (int attempt = 0; attempt <= maxRetries; attempt++) {
      lastResponse = await request();
      
      // If the request was successful, return the response
      if (lastResponse.success) {
        return lastResponse;
      }
      
      // If this was the last attempt, return the last response
      if (attempt == maxRetries) {
        break;
      }
      
      // Wait before retrying (exponential backoff)
      await Future.delayed(baseDelay * pow(2, attempt));
    }
    
    return lastResponse!;
  }

  /// Cancel ongoing requests using a CancelToken
  static void cancelRequests() {
    // Implementation would depend on the HTTP client used
    // This is a placeholder for cancellation functionality
 }

  /// Check if the response indicates a specific error type
  static bool isNetworkError(NetworkResponse response) {
    return response.statusCode == -1 && response.error != null;
  }

  /// Check if the response indicates a timeout error
  static bool isTimeoutError(NetworkResponse response) {
    return response.error?.contains('timeout') ?? false;
  }

  /// Check if the response indicates a server error
  static bool isServerError(NetworkResponse response) {
    return response.statusCode >= 500 && response.statusCode < 600;
  }

  /// Check if the response indicates a client error
  static bool isClientError(NetworkResponse response) {
    return response.statusCode >= 400 && response.statusCode < 500;
  }

  /// Check if the response indicates an unauthorized error
  static bool isUnauthorizedError(NetworkResponse response) {
    return response.statusCode == 401;
  }

  /// Check if the response indicates a forbidden error
 static bool isForbiddenError(NetworkResponse response) {
    return response.statusCode == 403;
  }

  /// Get error message from response based on status code
  static String getErrorMessage(NetworkResponse response) {
    if (response.error != null) {
      return response.error!;
    }
    
    switch (response.statusCode) {
      case 400:
        return 'Bad Request';
      case 401:
        return 'Unauthorized';
      case 403:
        return 'Forbidden';
      case 404:
        return 'Not Found';
      case 429:
        return 'Too Many Requests';
      case 500:
        return 'Internal Server Error';
      case 502:
        return 'Bad Gateway';
      case 503:
        return 'Service Unavailable';
      case 504:
        return 'Gateway Timeout';
      default:
        return 'An error occurred';
    }
  }
}

/// Response class for network operations
class NetworkResponse {
  final int statusCode;
  final dynamic data;
  final Map<String, String> headers;
  final bool success;
  final String? error;

  NetworkResponse({
    required this.statusCode,
    required this.data,
    required this.headers,
    required this.success,
    this.error,
  });
}