/// Implement exception handling utilities
import 'dart:developer' as developer;
import 'app_exceptions.dart';

class ExceptionHandler {
  /// Handle exceptions and return a standardized error response
  static AppError handle(dynamic error, {StackTrace? stackTrace}) {
    AppError appError;

    if (error is AppException) {
      // Already an AppException, return as is
      appError = AppError(
        message: error.message,
        code: error.code,
        exception: error,
        details: error.details,
        stackTrace: stackTrace,
      );
    } else if (error is Exception || error is Error) {
      // Dart exceptions or errors
      appError = _mapDartException(error, stackTrace);
    } else {
      // Unknown error type
      appError = AppError(
        message: error.toString(),
        code: 'UNKNOWN_ERROR',
        exception: UnknownException(error.toString()),
        details: error,
        stackTrace: stackTrace,
      );
    }

    // Log the error for debugging purposes
    _logError(appError);

    return appError;
  }

  /// Map Dart exceptions to AppException
  static AppError _mapDartException(dynamic error, StackTrace? stackTrace) {
    String message = error.toString();
    String code = 'UNKNOWN_ERROR';

    if (error is FormatException) {
      code = 'FORMAT_ERROR';
      return AppError(
        message: message,
        code: code,
        exception: FormatException(message),
        details: error,
        stackTrace: stackTrace,
      );
    } else if (error is TypeError) {
      code = 'TYPE_ERROR';
      return AppError(
        message: message,
        code: code,
        exception: AppException(message, code: code),
        details: error,
        stackTrace: stackTrace,
      );
    } else if (error is StateError) {
      code = 'STATE_ERROR';
      return AppError(
        message: message,
        code: code,
        exception: AppException(message, code: code),
        details: error,
        stackTrace: stackTrace,
      );
    } else if (error is ArgumentError) {
      code = 'ARGUMENT_ERROR';
      return AppError(
        message: message,
        code: code,
        exception: ValidationException(message, code: code),
        details: error,
        stackTrace: stackTrace,
      );
    } else if (error is RangeError) {
      code = 'RANGE_ERROR';
      return AppError(
        message: message,
        code: code,
        exception: AppException(message, code: code),
        details: error,
        stackTrace: stackTrace,
      );
    } else if (error is UnsupportedError) {
      code = 'UNSUPPORTED_ERROR';
      return AppError(
        message: message,
        code: code,
        exception: AppException(message, code: code),
        details: error,
        stackTrace: stackTrace,
      );
    } else if (error is OutOfMemoryError) {
      code = 'OUT_OF_MEMORY_ERROR';
      return AppError(
        message: 'Out of memory',
        code: code,
        exception: AppException('Out of memory', code: code),
        details: error,
        stackTrace: stackTrace,
      );
    } else if (error is StackOverflowError) {
      code = 'STACK_OVERFLOW_ERROR';
      return AppError(
        message: 'Stack overflow',
        code: code,
        exception: AppException('Stack overflow', code: code),
        details: error,
        stackTrace: stackTrace,
      );
    } else {
      // General dart exception
      return AppError(
        message: message,
        code: code,
        exception: UnknownException(message),
        details: error,
        stackTrace: stackTrace,
      );
    }
  }

  /// Log error to console and any error tracking service
  static void _logError(AppError appError) {
    developer.log(
      'AppError: ${appError.code}',
      name: 'ExceptionHandler',
      error: appError.exception,
      stackTrace: appError.stackTrace,
      level: 1000, // Error level
    );

    // Additional error tracking could be added here
    // e.g., Sentry, Firebase Crashlytics, etc.
  }

  /// Execute a function with exception handling
  static Future<T> executeWithErrorHandling<T>(
    Future<T> Function() operation, {
    void Function(AppError)? onError,
  }) async {
    try {
      return await operation();
    } catch (error, stackTrace) {
      AppError appError = handle(error, stackTrace: stackTrace);
      
      onError?.call(appError);
      
      // Re-throw the handled error
      throw appError;
    }
  }

  /// Execute a synchronous function with exception handling
  static T executeSyncWithErrorHandling<T>(
    T Function() operation, {
    void Function(AppError)? onError,
  }) {
    try {
      return operation();
    } catch (error, stackTrace) {
      AppError appError = handle(error, stackTrace: stackTrace);
      
      onError?.call(appError);
      
      // Re-throw the handled error
      throw appError;
    }
 }

  /// Check if an error is a network-related error
  static bool isNetworkError(AppError error) {
    return error.code?.contains('NETWORK') == true ||
           error.code?.contains('CONNECTION') == true ||
           error.code?.contains('TIMEOUT') == true ||
           error.exception is NetworkException;
  }

  /// Check if an error is a server-related error
 static bool isServerError(AppError error) {
    return error.code?.contains('SERVER') == true ||
           error.code?.contains('50') == true || // 5xx status codes
           error.exception is ServerException;
  }

  /// Check if an error is a client-related error (4xx status codes)
  static bool isClientError(AppError error) {
    return error.code?.contains('CLIENT') == true ||
           error.code?.contains('40') == true || // 4xx status codes
           error.code?.contains('AUTH') == true ||
           error.exception is ValidationException ||
           error.exception is AuthenticationException ||
           error.exception is AuthorizationException;
  }

  /// Check if an error is a validation-related error
  static bool isValidationError(AppError error) {
    return error.code?.contains('VALIDATION') == true ||
           error.exception is ValidationException;
  }

  /// Check if an error is related to permissions
  static bool isPermissionError(AppError error) {
    return error.code?.contains('PERMISSION') == true ||
           error.exception is PermissionException;
  }

  /// Get user-friendly error message
  static String getUserFriendlyMessage(AppError error) {
    switch (error.code) {
      case 'NETWORK_ERROR':
        return 'Please check your internet connection and try again.';
      case 'TIMEOUT_ERROR':
        return 'Request timed out. Please try again.';
      case 'AUTH_ERROR':
      case 'UNAUTHORIZED':
        return 'Authentication failed. Please log in again.';
      case 'FORBIDDEN':
        return 'You do not have permission to perform this action.';
      case 'NOT_FOUND':
        return 'The requested resource was not found.';
      case 'CONFLICT':
        return 'The request conflicts with existing data.';
      case 'TOO_MANY_REQUESTS':
        return 'Too many requests. Please try again later.';
      case 'SERVICE_UNAVAILABLE':
        return 'Service is temporarily unavailable. Please try again later.';
      case 'UNKNOWN_ERROR':
      default:
        return 'An unexpected error occurred. Please try again.';
    }
  }
}

/// Standardized error response class
class AppError {
  final String message;
  final String? code;
  final AppException exception;
  final dynamic details;
  final StackTrace? stackTrace;

  AppError({
    required this.message,
    this.code,
    required this.exception,
    this.details,
    this.stackTrace,
  });

  @override
  String toString() {
    return 'AppError{message: $message, code: $code, exception: $exception, details: $details}';
  }
}