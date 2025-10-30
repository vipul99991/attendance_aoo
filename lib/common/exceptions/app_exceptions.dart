/// Define custom application exceptions
class AppException implements Exception {
  final String message;
  final String? code;
  final dynamic details;

  AppException(this.message, {this.code, this.details});

  @override
  String toString() => 'AppException: $message';
}

class NetworkException extends AppException {
  NetworkException(String message, {String? code, dynamic details}) 
      : super(message, code: code, details: details);
}

class ServerException extends AppException {
  ServerException(String message, {String? code, dynamic details}) 
      : super(message, code: code, details: details);
}

class CacheException extends AppException {
  CacheException(String message, {String? code, dynamic details}) 
      : super(message, code: code, details: details);
}

class ValidationException extends AppException {
  ValidationException(String message, {String? code, dynamic details}) 
      : super(message, code: code, details: details);
}

class AuthenticationException extends AppException {
  AuthenticationException(String message, {String? code, dynamic details}) 
      : super(message, code: code, details: details);
}

class AuthorizationException extends AppException {
  AuthorizationException(String message, {String? code, dynamic details}) 
      : super(message, code: code, details: details);
}

class TimeoutException extends AppException {
  TimeoutException(String message, {String? code, dynamic details}) 
      : super(message, code: code, details: details);
}

class DatabaseException extends AppException {
  DatabaseException(String message, {String? code, dynamic details}) 
      : super(message, code: code, details: details);
}

class StorageException extends AppException {
  StorageException(String message, {String? code, dynamic details}) 
      : super(message, code: code, details: details);
}

class PermissionException extends AppException {
  PermissionException(String message, {String? code, dynamic details}) 
      : super(message, code: code, details: details);
}

class FormatException extends AppException {
  FormatException(String message, {String? code, dynamic details}) 
      : super(message, code: code, details: details);
}

class NotFoundException extends AppException {
  NotFoundException(String message, {String? code, dynamic details}) 
      : super(message, code: code, details: details);
}

class ConflictException extends AppException {
  ConflictException(String message, {String? code, dynamic details}) 
      : super(message, code: code, details: details);
}

class TooManyRequestsException extends AppException {
  TooManyRequestsException(String message, {String? code, dynamic details}) 
      : super(message, code: code, details: details);
}

class ServiceUnavailableException extends AppException {
  ServiceUnavailableException(String message, {String? code, dynamic details}) 
      : super(message, code: code, details: details);
}

class UnknownException extends AppException {
  UnknownException(String message, {String? code, dynamic details}) 
      : super(message, code: code, details: details);
}

class AttendanceException extends AppException {
  AttendanceException(String message, {String? code, dynamic details}) 
      : super(message, code: code, details: details);
}

class LeaveException extends AppException {
  LeaveException(String message, {String? code, dynamic details}) 
      : super(message, code: code, details: details);
}

class BiometricException extends AppException {
  BiometricException(String message, {String? code, dynamic details}) 
      : super(message, code: code, details: details);
}

class LocationException extends AppException {
  LocationException(String message, {String? code, dynamic details}) 
      : super(message, code: code, details: details);
}