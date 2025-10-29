// App Configuration Constants
class AppConfig {
  // API Configuration
  static const String baseUrl = 'https://your-api-endpoint.com/api';
  static const String loginEndpoint = '/auth/login';
  static const String attendanceEndpoint = '/attendance';
  static const String leaveEndpoint = '/leave';

  // App Settings
  static const String appName = 'Attendance App';
  static const String appVersion = '1.0.0';

  // Working Hours
  static const String defaultStartTime = '09:00';
  static const String defaultEndTime = '17:00';
  static const int defaultBreakDuration = 60; // minutes

  // Location Settings
  static const int defaultLocationRadius = 100; // meters
  static const double defaultOfficeLatitude = 40.7128;
  static const double defaultOfficeLongitude = -74.0060;

  // HR Emails (Default - can be overridden from server)
  static const List<String> defaultHrEmails = [
    'hr1@company.com',
    'hr2@company.com',
  ];

  // Background Service Settings
  static const String backgroundTaskName = 'attendance_background_task';
  static const int backgroundSyncInterval = 15; // minutes

  // File Export Settings
  static const String exportDirectoryName = 'AttendanceExports';
  static const String excelFileName = 'attendance_report';
  static const String pdfFileName = 'attendance_report';

  // Theme Settings
  static const String themeStorageKey = 'app_theme_mode';
  static const String languageStorageKey = 'app_language';

  // Hive Box Names
  static const String userBoxName = 'user_data';
  static const String attendanceBoxName = 'attendance_records';
  static const String leaveBoxName = 'leave_requests';
  static const String settingsBoxName = 'app_settings';

  // Photo Settings
  static const int maxPhotoSize = 2 * 1024 * 1024; // 2MB
  static const double photoQuality = 0.8;
  static const int photoMaxWidth = 1024;
  static const int photoMaxHeight = 1024;
}

// UI Constants
class UIConstants {
  // Spacing
  static const double smallSpacing = 8.0;
  static const double mediumSpacing = 16.0;
  static const double largeSpacing = 24.0;
  static const double extraLargeSpacing = 32.0;

  // Border Radius
  static const double smallRadius = 8.0;
  static const double mediumRadius = 12.0;
  static const double largeRadius = 16.0;
  static const double extraLargeRadius = 20.0;

  // Icon Sizes
  static const double smallIconSize = 16.0;
  static const double mediumIconSize = 24.0;
  static const double largeIconSize = 32.0;
  static const double extraLargeIconSize = 48.0;

  // Button Heights
  static const double buttonHeight = 48.0;
  static const double largeButtonHeight = 56.0;

  // Card Elevation
  static const double cardElevation = 2.0;
  static const double raisedCardElevation = 4.0;
}

// Message Constants
class Messages {
  // Success Messages
  static const String loginSuccess = 'Login successful!';
  static const String checkInSuccess = 'Check-in successful!';
  static const String checkOutSuccess = 'Check-out successful!';
  static const String leaveApplied =
      'Leave application submitted successfully!';
  static const String dataExported = 'Data exported successfully!';

  // Error Messages
  static const String loginFailed =
      'Login failed. Please check your credentials.';
  static const String networkError =
      'Network error. Please check your connection.';
  static const String locationError =
      'Unable to get your location. Please enable GPS.';
  static const String cameraError =
      'Camera access denied. Please enable camera permission.';
  static const String exportError = 'Failed to export data. Please try again.';
  static const String permissionDenied =
      'Permission denied. Please grant necessary permissions.';

  // Validation Messages
  static const String fieldRequired = 'This field is required';
  static const String invalidEmail = 'Please enter a valid email address';
  static const String invalidEmployeeId = 'Please enter a valid employee ID';
  static const String passwordTooShort =
      'Password must be at least 6 characters';

  // Info Messages
  static const String alreadyCheckedIn = 'You have already checked in today.';
  static const String notCheckedIn = 'Please check in first.';
  static const String outsideOfficeArea = 'You are outside the office area.';
  static const String backgroundServiceRunning =
      'Attendance tracking is running in background.';
}

// Storage Keys
class StorageKeys {
  static const String isFirstLaunch = 'is_first_launch';
  static const String lastSyncTime = 'last_sync_time';
  static const String offlineMode = 'offline_mode';
  static const String biometricEnabled = 'biometric_enabled';
  static const String autoCheckOut = 'auto_check_out';
  static const String locationTracking = 'location_tracking';
  static const String notificationsEnabled = 'notifications_enabled';
  static const String darkTheme = 'dark_theme';
  static const String language = 'selected_language';
}

// Notification Constants
class NotificationConfig {
  static const String channelId = 'attendance_notifications';
  static const String channelName = 'Attendance Notifications';
  static const String channelDescription =
      'Notifications for attendance tracking';

  // Notification IDs
  static const int checkInReminder = 1001;
  static const int checkOutReminder = 1002;
  static const int leaveApproval = 1003;
  static const int overtimeAlert = 1004;
}

// Permission Constants
class PermissionTypes {
  static const String checkIn = 'check_in';
  static const String checkOut = 'check_out';
  static const String applyLeave = 'apply_leave';
  static const String viewAttendance = 'view_attendance';
  static const String exportData = 'export_data';
  static const String viewReports = 'view_reports';
  static const String approveLeave = 'approve_leave';
  static const String manageEmployees = 'manage_employees';
}
