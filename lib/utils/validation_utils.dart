/// Utility class for input validation
class ValidationUtils {
  /// Validates if a string is not null or empty
  static bool isValidString(String? value) {
    return value != null && value.trim().isNotEmpty;
  }

  /// Validates email format
 static bool isValidEmail(String? email) {
    if (!isValidString(email)) return false;
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email!);
  }

 /// Validates if a string is a valid employee ID
  static bool isValidEmployeeId(String? employeeId) {
    if (!isValidString(employeeId)) return false;
    // Assuming employee ID format: starts with letters/numbers, can contain hyphens
    final idRegex = RegExp(r'^[A-Za-z0-9]+[\w-]*$');
    return idRegex.hasMatch(employeeId!);
  }

 /// Validates password strength (at least 6 characters)
  static bool isValidPassword(String? password) {
    if (!isValidString(password)) return false;
    return password!.length >= 6;
  }

  /// Validates phone number format
  static bool isValidPhone(String? phone) {
    if (!isValidString(phone)) return false;
    // Simple phone validation - can be extended based on requirements
    final phoneRegex = RegExp(r'^[\+]?[1-9][\d]{3,14}$');
    return phoneRegex.hasMatch(phone!);
  }

 /// Validates if a number is positive
  static bool isPositiveNumber(num? value) {
    return value != null && value > 0;
  }

  /// Validates if a value is within a specified range
  static bool isInRange(num? value, num min, num max) {
    if (value == null) return false;
    return value >= min && value <= max;
  }

  /// Validates if a DateTime is in the past
  static bool isPastDate(DateTime? date) {
    if (date == null) return false;
    return date.isBefore(DateTime.now());
  }

 /// Validates if a DateTime is in the future
  static bool isFutureDate(DateTime? date) {
    if (date == null) return false;
    return date.isAfter(DateTime.now());
  }

  /// Validates if a DateTime is today
  static bool isToday(DateTime? date) {
    if (date == null) return false;
    final today = DateTime.now();
    return date.year == today.year &&
        date.month == today.month &&
        date.day == today.day;
  }
}