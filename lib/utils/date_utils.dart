import 'package:intl/intl.dart';

/// Utility class for date formatting and operations
class DateUtils {
  /// Formats a DateTime to 'yyyy-MM-dd' format
  static String formatDate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  /// Formats a DateTime to 'MMM dd, yyyy' format
  static String formatDisplayDate(DateTime date) {
    return DateFormat('MMM dd, yyyy').format(date);
  }

  /// Formats a DateTime to 'hh:mm a' format
  static String formatTime(DateTime date) {
    return DateFormat('hh:mm a').format(date);
 }

  /// Formats a DateTime to 'MMM d' format
  static String formatShortMonthDay(DateTime date) {
    return DateFormat('MMM d').format(date);
  }

  /// Formats a DateTime to 'MMM d, yyyy' format
  static String formatMonthDayYear(DateTime date) {
    return DateFormat('MMM d, yyyy').format(date);
 }

  /// Checks if two dates are on the same day
  static bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  /// Gets the start of the day for a given DateTime
 static DateTime startOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  /// Gets the end of the day for a given DateTime
  static DateTime endOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day, 23, 59, 999, 999);
  }
}