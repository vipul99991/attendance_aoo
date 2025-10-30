/// Validation-related constants
class ValidationConstants {
  // Email Validation
  static const String emailPattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
  static const int minEmailLength = 5;
  static const int maxEmailLength = 254;
  static const String emailErrorMessage = 'Please enter a valid email address';
  
  // Password Validation
  static const String passwordPattern = r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$';
  static const int minPasswordLength = 8;
  static const int maxPasswordLength = 128;
  static const String passwordErrorMessage = 'Password must contain at least 8 characters with uppercase, lowercase, number and special character';
 static const String weakPasswordMessage = 'Password is too weak';
 static const String mediumPasswordMessage = 'Password strength is medium';
 static const String strongPasswordMessage = 'Password strength is strong';
  
  // Name Validation
  static const String namePattern = r'^[a-zA-Z\s\-\'\.]{2,50}$';
  static const int minNameLength = 2;
  static const int maxNameLength = 50;
  static const String nameErrorMessage = 'Name must be between 2 and 50 characters';
  
  // Phone Number Validation
  static const String phonePattern = r'^[+]?[0-9]{10,15}$';
  static const int minPhoneLength = 10;
  static const int maxPhoneLength = 15;
  static const String phoneErrorMessage = 'Please enter a valid phone number';
  
  // Username Validation
  static const String usernamePattern = r'^[a-zA-Z0-9_]{3,20}$';
  static const int minUsernameLength = 3;
  static const int maxUsernameLength = 20;
  static const String usernameErrorMessage = 'Username must be 3-20 characters, letters, numbers and underscores only';
  
  // Date Validation
  static const String datePattern = r'^\d{2}/\d{2}/\d{4}$';
  static const String dateFormat = 'dd/MM/yyyy';
  static const String dateErrorMessage = 'Please enter a valid date in dd/MM/yyyy format';
  
  // Time Validation
  static const String timePattern = r'^([01]?[0-9]|2[0-3]):[0-5][0-9]$';
  static const String timeFormat = 'HH:mm';
  static const String timeErrorMessage = 'Please enter a valid time in HH:mm format';
  
  // Numeric Validation
  static const String numericPattern = r'^\d+$';
  static const String numericWithDecimalPattern = r'^\d+\.?\d*$';
  static const String numericErrorMessage = 'Please enter a valid number';
  static const double minNumericValue = 0.0;
  static const double maxNumericValue = 999999.99;
  
  // Text Validation
  static const int minTextLength = 1;
  static const int maxTextLength = 1000;
  static const String textErrorMessage = 'Text is required';
  static const String textTooShortMessage = 'Text is too short';
  static const String textTooLongMessage = 'Text exceeds maximum length';
  
  // ID Validation
  static const String idPattern = r'^[a-zA-Z0-9]{6,32}$';
  static const int minIdLength = 6;
  static const int maxIdLength = 32;
  static const String idErrorMessage = 'ID must be 6-32 characters, letters and numbers only';
  
  // Attendance Validation
  static const String checkInTimePattern = r'^([0-8]|0[0-9]|1[0-9]|2[0-3]):[0-5][0-9]$';
  static const String checkOutTimePattern = r'^([0-9]|0[0-9]|1[0-9]|2[0-3]):[0-5][0-9]$';
  static const String checkInErrorMessage = 'Please enter a valid check-in time (00:00-23:59)';
  static const String checkOutErrorMessage = 'Please enter a valid check-out time (00:00-23:59)';
  static const int minCheckInHour = 0;
  static const int maxCheckInHour = 23;
  static const int minCheckOutHour = 0;
  static const int maxCheckOutHour = 23;
  
  // Leave Request Validation
  static const double minLeaveDays = 0.5;
  static const int maxLeaveDays = 365;
  static const String leaveDaysErrorMessage = 'Leave days must be between 0.5 and 365';
  static const String leaveReasonMinLengthMessage = 'Leave reason must be at least 10 characters';
  static const int minLeaveReasonLength = 10;
  static const int maxLeaveReasonLength = 500;
  
  // Common Validation Messages
  static const String requiredFieldMessage = 'This field is required';
  static const String invalidInputMessage = 'Invalid input provided';
  static const String fieldTooShortMessage = 'Field is too short';
  static const String fieldTooLongMessage = 'Field exceeds maximum length';
  static const String fieldNotMatchingMessage = 'Fields do not match';
 static const String fieldNotUniqueMessage = 'Value already exists';
  
  // Validation Severity Levels
  static const String validationError = 'error';
  static const String validationWarning = 'warning';
  static const String validationInfo = 'info';
  static const String validationSuccess = 'success';
  
  // Validation Configuration
  static const bool validateOnInput = true;
  static const bool validateOnSubmit = true;
  static const bool showValidationMessages = true;
  static const bool realTimeValidation = true;
  static const Duration validationDebounceDuration = Duration(milliseconds: 500);
}