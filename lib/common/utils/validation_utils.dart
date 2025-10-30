/// Enhanced validation utilities with clear interfaces
import 'package:flutter/foundation.dart';
import '../constants/validation_constants.dart';

class ValidationUtils {
  /// Validate email address format
  static bool isValidEmail(String email) {
    if (email.isEmpty) return false;
    if (email.length < ValidationConstants.minEmailLength || 
        email.length > ValidationConstants.maxEmailLength) {
      return false;
    }
    return RegExp(ValidationConstants.emailPattern).hasMatch(email);
  }

  /// Validate password strength
  static PasswordStrengthResult validatePassword(String password) {
    if (password.isEmpty) {
      return PasswordStrengthResult(
        isValid: false,
        strength: PasswordStrength.weak,
        message: ValidationConstants.requiredFieldMessage,
      );
    }

    if (password.length < ValidationConstants.minPasswordLength) {
      return PasswordStrengthResult(
        isValid: false,
        strength: PasswordStrength.weak,
        message: ValidationConstants.passwordErrorMessage,
      );
    }

    bool hasUppercase = password.contains(RegExp(r'[A-Z]'));
    bool hasLowercase = password.contains(RegExp(r'[a-z]'));
    bool hasDigit = password.contains(RegExp(r'[0-9]'));
    bool hasSpecialChar = password.contains(RegExp(r'[@$!%*?&]'));

    int strengthScore = 0;
    if (hasUppercase) strengthScore++;
    if (hasLowercase) strengthScore++;
    if (hasDigit) strengthScore++;
    if (hasSpecialChar) strengthScore++;

    PasswordStrength strength;
    String message;

    if (strengthScore >= 4 && password.length >= ValidationConstants.minPasswordLength) {
      strength = PasswordStrength.strong;
      message = ValidationConstants.strongPasswordMessage;
    } else if (strengthScore >= 3) {
      strength = PasswordStrength.medium;
      message = ValidationConstants.mediumPasswordMessage;
    } else {
      strength = PasswordStrength.weak;
      message = ValidationConstants.weakPasswordMessage;
    }

    return PasswordStrengthResult(
      isValid: strengthScore >= 4 && password.length >= ValidationConstants.minPasswordLength,
      strength: strength,
      message: message,
    );
  }

  /// Validate name format
  static bool isValidName(String name) {
    if (name.isEmpty) return false;
    if (name.length < ValidationConstants.minNameLength || 
        name.length > ValidationConstants.maxNameLength) {
      return false;
    }
    return RegExp(ValidationConstants.namePattern).hasMatch(name);
  }

  /// Validate phone number format
  static bool isValidPhone(String phone) {
    if (phone.isEmpty) return false;
    // Remove any spaces, hyphens, or parentheses for validation
    String cleanPhone = phone.replaceAll(RegExp(r'[\s\-\(\)]'), '');
    if (cleanPhone.length < ValidationConstants.minPhoneLength || 
        cleanPhone.length > ValidationConstants.maxPhoneLength) {
      return false;
    }
    return RegExp(ValidationConstants.phonePattern).hasMatch(cleanPhone);
  }

  /// Validate username format
  static bool isValidUsername(String username) {
    if (username.isEmpty) return false;
    if (username.length < ValidationConstants.minUsernameLength || 
        username.length > ValidationConstants.maxUsernameLength) {
      return false;
    }
    return RegExp(ValidationConstants.usernamePattern).hasMatch(username);
  }

 /// Validate date format
  static bool isValidDate(String date) {
    if (date.isEmpty) return false;
    if (!RegExp(ValidationConstants.datePattern).hasMatch(date)) {
      return false;
    }
    
    try {
      List<String> parts = date.split('/');
      int day = int.parse(parts[0]);
      int month = int.parse(parts[1]);
      int year = int.parse(parts[2]);
      
      DateTime testDate = DateTime(year, month, day);
      return testDate.day == day && testDate.month == month && testDate.year == year;
    } catch (e) {
      return false;
    }
  }

  /// Validate time format
  static bool isValidTime(String time) {
    if (time.isEmpty) return false;
    if (!RegExp(ValidationConstants.timePattern).hasMatch(time)) {
      return false;
    }
    
    try {
      List<String> parts = time.split(':');
      int hour = int.parse(parts[0]);
      int minute = int.parse(parts[1]);
      
      return hour >= 0 && hour <= 23 && minute >= 0 && minute <= 59;
    } catch (e) {
      return false;
    }
  }

  /// Validate numeric value
  static bool isValidNumeric(String value, {bool allowDecimals = true}) {
    if (value.isEmpty) return false;
    
    RegExp pattern = allowDecimals 
        ? RegExp(ValidationConstants.numericWithDecimalPattern) 
        : RegExp(ValidationConstants.numericPattern);
    
    if (!pattern.hasMatch(value)) {
      return false;
    }
    
    try {
      double parsedValue = double.parse(value);
      return parsedValue >= ValidationConstants.minNumericValue && 
             parsedValue <= ValidationConstants.maxNumericValue;
    } catch (e) {
      return false;
    }
  }

  /// Validate text length
  static bool isValidText(String text, {int? minLength, int? maxLength}) {
    int actualMinLength = minLength ?? ValidationConstants.minTextLength;
    int actualMaxLength = maxLength ?? ValidationConstants.maxTextLength;
    
    if (text.length < actualMinLength) {
      return false;
    }
    
    if (text.length > actualMaxLength) {
      return false;
    }
    
    return true;
  }

  /// Validate ID format
  static bool isValidId(String id) {
    if (id.isEmpty) return false;
    if (id.length < ValidationConstants.minIdLength || 
        id.length > ValidationConstants.maxIdLength) {
      return false;
    }
    return RegExp(ValidationConstants.idPattern).hasMatch(id);
  }

  /// Validate check-in time
  static bool isValidCheckInTime(String time) {
    if (time.isEmpty) return false;
    if (!RegExp(ValidationConstants.checkInTimePattern).hasMatch(time)) {
      return false;
    }
    
    try {
      List<String> parts = time.split(':');
      int hour = int.parse(parts[0]);
      int minute = int.parse(parts[1]);
      
      return hour >= ValidationConstants.minCheckInHour && 
             hour <= ValidationConstants.maxCheckInHour && 
             minute >= 0 && minute <= 59;
    } catch (e) {
      return false;
    }
  }

  /// Validate check-out time
  static bool isValidCheckOutTime(String time) {
    if (time.isEmpty) return false;
    if (!RegExp(ValidationConstants.checkOutTimePattern).hasMatch(time)) {
      return false;
    }
    
    try {
      List<String> parts = time.split(':');
      int hour = int.parse(parts[0]);
      int minute = int.parse(parts[1]);
      
      return hour >= ValidationConstants.minCheckOutHour && 
             hour <= ValidationConstants.maxCheckOutHour && 
             minute >= 0 && minute <= 59;
    } catch (e) {
      return false;
    }
  }

  /// Validate leave days
  static bool isValidLeaveDays(double days) {
    return days >= ValidationConstants.minLeaveDays && 
           days <= ValidationConstants.maxLeaveDays;
  }

  /// Validate leave reason
  static bool isValidLeaveReason(String reason) {
    if (reason.isEmpty) return false;
    if (reason.length < ValidationConstants.minLeaveReasonLength) {
      return false;
    }
    if (reason.length > ValidationConstants.maxLeaveReasonLength) {
      return false;
    }
    return true;
  }

  /// Combine multiple validation rules
 static ValidationResult validateMultiple(List<ValidationRule> rules) {
    List<String> errors = [];
    
    for (ValidationRule rule in rules) {
      if (!rule.validator(rule.value)) {
        errors.add(rule.errorMessage);
      }
    }
    
    return ValidationResult(
      isValid: errors.isEmpty,
      errors: errors,
    );
  }
}

/// Password strength levels
enum PasswordStrength { weak, medium, strong }

/// Result class for password validation
class PasswordStrengthResult {
  final bool isValid;
  final PasswordStrength strength;
  final String message;

  PasswordStrengthResult({
    required this.isValid,
    required this.strength,
    required this.message,
  });
}

/// Result class for multiple validation
class ValidationResult {
  final bool isValid;
  final List<String> errors;

  ValidationResult({
    required this.isValid,
    required this.errors,
  });
}

/// Class representing a validation rule
class ValidationRule {
  final bool Function(String value) validator;
  final String value;
  final String errorMessage;

  ValidationRule({
    required this.validator,
    required this.value,
    required this.errorMessage,
  });
}