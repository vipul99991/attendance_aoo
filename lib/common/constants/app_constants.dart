/// App-wide constants including API endpoints, default values, time constants, etc.
class AppConstants {
  // API Endpoints
  static const String baseUrl = 'https://api.example.com';
  static const String attendanceEndpoint = '/api/attendance';
  static const String usersEndpoint = '/api/users';
  static const String authEndpoint = '/api/auth';
  static const String leaveEndpoint = '/api/leave';
  static const String reportsEndpoint = '/api/reports';
  
  // Default Values
  static const String defaultAppName = 'Attendance App';
  static const String defaultDateFormat = 'dd/MM/yyyy';
  static const String defaultTimeFormat = 'hh:mm a';
  static const String defaultDateTimeFormat = 'dd/MM/yyyy hh:mm a';
  static const int defaultPageSize = 20;
  static const String defaultLanguageCode = 'en';
  static const String defaultCountryCode = 'US';
  
  // Time Constants
  static const Duration defaultAnimationDuration = Duration(milliseconds: 300);
  static const Duration defaultNetworkTimeout = Duration(seconds: 30);
  static const Duration defaultDebounceDuration = Duration(milliseconds: 500);
  static const Duration defaultRefreshInterval = Duration(minutes: 5);
  static const Duration defaultSessionTimeout = Duration(hours: 2);
  static const Duration defaultCacheExpiry = Duration(hours: 1);
  
  // App Limits
  static const int maxImageSizeInBytes = 5 * 1024 * 1024; // 5MB
  static const int maxFileSizeInBytes = 10 * 1024 * 1024; // 10MB
  static const int maxRetryAttempts = 3;
  static const int maxConcurrentRequests = 5;
  
  // Storage Keys
  static const String userTokenKey = 'user_token';
  static const String userIdKey = 'user_id';
  static const String userRoleKey = 'user_role';
  static const String themeModeKey = 'theme_mode';
  static const String languageCodeKey = 'language_code';
  static const String onboardingCompletedKey = 'onboarding_completed';
  static const String lastSyncTimeKey = 'last_sync_time';
  
  // Notifications
  static const String attendanceReminderChannelId = 'attendance_reminder';
  static const String attendanceReminderChannelName = 'Attendance Reminder';
  static const String attendanceReminderChannelDescription = 'Reminders for attendance check-in/check-out';
  
  // Cache Keys
  static const String attendanceCacheKey = 'attendance_cache';
  static const String usersCacheKey = 'users_cache';
  static const String leaveRequestsCacheKey = 'leave_requests_cache';
  
  // Validation Patterns
  static const String emailPattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
  static const String phonePattern = r'^[+]?[0-9]{10,15}$';
  static const String passwordPattern = r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$';
  
  // Error Messages
  static const String networkError = 'Network error occurred';
  static const String serverError = 'Server error occurred';
  static const String unknownError = 'An unknown error occurred';
  static const String timeoutError = 'Request timed out';
  static const String invalidDataError = 'Invalid data received';
  
  // Success Messages
  static const String operationSuccessful = 'Operation completed successfully';
  static const String dataSaved = 'Data saved successfully';
  static const String dataUpdated = 'Data updated successfully';
  
  // Status Codes
  static const int successCode = 200;
  static const int unauthorizedCode = 401;
  static const int forbiddenCode = 403;
  static const int notFoundCode = 404;
  static const int internalServerError = 500;
  
  // Default Dimensions
  static const double defaultPadding = 16.0;
  static const double defaultMargin = 16.0;
  static const double defaultBorderRadius = 8.0;
  static const double defaultElevation = 4.0;
  static const double defaultIconSize = 24.0;
  static const double defaultButtonHeight = 48.0;
  
  // App Settings
  static const bool defaultAutoSync = true;
  static const bool defaultLocationTracking = true;
 static const bool defaultPushNotifications = true;
  static const bool defaultBiometricAuth = false;
}